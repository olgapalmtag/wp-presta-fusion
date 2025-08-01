#!/bin/bash

set -euo pipefail

echo "Manuelles Löschen aller Ressourcen startet..."

# SSH-Zugang zur K3s-Instanz
KEY_FILE="/home/ubuntu/key.pem"
K3S_USER="ubuntu"
K3S_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=wp-presta-fusion-k3s"   --query "Reservations[].Instances[].PublicIpAddress" --output text)

echo "Lösche Kubernetes Deployments auf $K3S_IP..."
{
  ssh -o StrictHostKeyChecking=no -i "$KEY_FILE" "$K3S_USER@$K3S_IP" <<EOF
    set -e
    if command -v kubectl >/dev/null 2>&1; then
      KUBECTL="kubectl"
    elif command -v k3s >/dev/null 2>&1; then
      KUBECTL="k3s kubectl"
    else
      echo "Kein kubectl oder k3s gefunden – Abbruch."
      exit 1
    fi
    $KUBECTL delete -f /home/ubuntu/wordpress --ignore-not-found
    $KUBECTL delete -f /home/ubuntu/prestashop --ignore-not-found
    rm -rf /home/ubuntu/wordpress /home/ubuntu/prestashop || true
EOF
} || echo "Kubernetes-Ressourcen konnten nicht gelöscht werden, fahre fort..."

sleep 30

# 2. ALB Komponenten
echo "Delete ALB Listener, Target Group und Load Balancer..."
TG_ARN=$(aws elbv2 describe-target-groups --names wp-presta-fusion-tg --query "TargetGroups[0].TargetGroupArn" --output text) || true
LB_ARN=$(aws elbv2 describe-load-balancers --names wp-presta-fusion-alb --query "LoadBalancers[0].LoadBalancerArn" --output text) || true
LISTENER_ARN=$(aws elbv2 describe-listeners --load-balancer-arn $LB_ARN --query "Listeners[0].ListenerArn" --output text) || true

aws elbv2 delete-listener --listener-arn $LISTENER_ARN || true
aws elbv2 delete-target-group --target-group-arn $TG_ARN || true
aws elbv2 delete-load-balancer --load-balancer-arn $LB_ARN || true

sleep 30

# 3. Security Groups
echo "Delete Security Groups..."
for sg in wp-presta-fusion-alb-sg wp-presta-fusion-instance-sg; do
  SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=$sg --query "SecurityGroups[0].GroupId" --output text)
  aws ec2 delete-security-group --group-id $SG_ID || true
done

# 4. RDS
echo "Delete RDS MariaDB-Instance..."
aws rds delete-db-instance --db-instance-identifier wp-presta-fusion-mariadb --skip-final-snapshot || true
sleep 120

echo "Delete RDS Subnet Group..."
aws rds delete-db-subnet-group --db-subnet-group-name mariadb-subnet-group || true

# 1. EC2-Instanzen löschen
echo "Delete EC2-Instanzen..."
aws ec2 terminate-instances --instance-ids $(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=wp-presta-fusion-*" \
  --query "Reservations[].Instances[].InstanceId" --output text) || true

sleep 30

# 5. IAM
echo "Delete IAM-Rollen, Policies und Profile..."
aws iam remove-role-from-instance-profile --instance-profile-name ec2-s3-backup-profile --role-name ec2-s3-backup-role || true
aws iam delete-instance-profile --instance-profile-name ec2-s3-backup-profile || true
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
aws iam detach-role-policy --role-name ec2-s3-backup-role --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/s3-backup-policy || true
aws iam delete-policy --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/s3-backup-policy || true
aws iam delete-role --role-name ec2-s3-backup-role || true

# 6. S3
echo "Delete S3 Bucket..."
aws s3 rm s3://wp-presta-backups --recursive || true
aws s3api delete-bucket-lifecycle --bucket wp-presta-backups || true
aws s3api delete-bucket --bucket wp-presta-backups || true

# 7. TLS-Zertifikate: lokal erzeugt – keine AWS-Aktion nötig

# 8. Netzwerk: VPC und Subnets
echo "Delete Route Table Associations..."
for rta in $(aws ec2 describe-route-tables --filters "Name=tag:Name,Values=wp-presta-fusion-*" --query "RouteTables[].Associations[].RouteTableAssociationId" --output text); do
  aws ec2 disassociate-route-table --association-id $rta || true
done

echo "Delete Subnets..."
for subnet in $(aws ec2 describe-subnets --filters "Name=tag:Name,Values=wp-presta-fusion-*" --query "Subnets[].SubnetId" --output text); do
  aws ec2 delete-subnet --subnet-id $subnet || true
done

echo "Delete Route Tables..."
for rt in $(aws ec2 describe-route-tables --filters "Name=tag:Name,Values=wp-presta-fusion-*" --query "RouteTables[].RouteTableId" --output text); do
  aws ec2 delete-route-table --route-table-id $rt || true
done

echo "Delete Internet Gateway..."
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=wp-presta-fusion-vpc" --query "Vpcs[0].VpcId" --output text)
IGW_ID=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID" --query "InternetGateways[0].InternetGatewayId" --output text)
aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID || true
aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID || true

echo "Starte Löschung aller VPCs mit Tag-Name 'wp-presta-fusion-*'..."

# VPC-IDs ermitteln
VPC_IDS=$(aws ec2 describe-vpcs \
  --filters "Name=tag:Name,Values=wp-presta-fusion-*" \
  --query "Vpcs[].VpcId" \
  --output text)

if [ -z "$VPC_IDS" ]; then
  echo "Keine VPCs mit diesem Namen gefunden."
  exit 0
fi

# VPCs durchlaufen und löschen
for vpc in $VPC_IDS; do
  echo "Versuche VPC $vpc zu löschen..."

  # Vorher ggf. abhängige Ressourcen prüfen/löschen (Internet Gateways etc.)
  IGW_ID=$(aws ec2 describe-internet-gateways \
    --filters "Name=attachment.vpc-id,Values=$vpc" \
    --query "InternetGateways[0].InternetGatewayId" \
    --output text 2>/dev/null || true)

  if [ "$IGW_ID" != "None" ] && [ -n "$IGW_ID" ]; then
    echo "Internet Gateway $IGW_ID von VPC $vpc trennen und löschen..."
    aws ec2 detach-internet-gateway --internet-gateway-id "$IGW_ID" --vpc-id "$vpc" || true
    aws ec2 delete-internet-gateway --internet-gateway-id "$IGW_ID" || true
  fi

  # VPC löschen
  aws ec2 delete-vpc --vpc-id "$vpc" && \
    echo "VPC $vpc erfolgreich gelöscht." || \
    echo "VPC $vpc konnte nicht gelöscht werden. Möglicherweise hängen noch Ressourcen daran."
done

echo "VPC-Löschung abgeschlossen."
echo "All Ressourcen are deleted."

