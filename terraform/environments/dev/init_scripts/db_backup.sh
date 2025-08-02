#!/bin/bash

set -euo pipefail

echo "Fetching Kubernetes secrets from namespace 'default'..."

# 1. Extract DB secrets from Kubernetes secret
SECRET_NAME="mariadb-secret"
NAMESPACE="default"

export DB_USER=$(k3s kubectl get secret $SECRET_NAME -n $NAMESPACE -o jsonpath="{.data.DB_USER}" | base64 -d)
export DB_PASSWORD=$(k3s kubectl get secret $SECRET_NAME -n $NAMESPACE -o jsonpath="{.data.DB_PASS" | base64 -d)
export DB_NAME=$(k3s kubectl get secret $SECRET_NAME -n $NAMESPACE -o jsonpath="{.data.DB_NAME}" | base64 -d)
export DB_HOST=$(k3s kubectl get secret $SECRET_NAME -n $NAMESPACE -o jsonpath="{.data.DB_HOST}" | base64 -d)
export DB_PORT=$(k3s kubectl get secret $SECRET_NAME -n $NAMESPACE -o jsonpath="{.data.DB_PORT}" | base64 -d)

echo "Secrets loaded. Starting dump..."

# 2. Define dump path
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
DUMP_FILE="/tmp/${DB_NAME}_backup_${TIMESTAMP}.sql.gz"

# 3. Run dump
mysqldump -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" | gzip > "$DUMP_FILE"

echo "Dump created at $DUMP_FILE"

# 4. Upload to S3
S3_BUCKET="wp-presta-backups"
S3_KEY="backups/${DB_NAME}_${TIMESTAMP}.sql.gz"

echo "Uploading to S3 bucket s3://$S3_BUCKET/$S3_KEY..."
aws s3 cp "$DUMP_FILE" "s3://$S3_BUCKET/$S3_KEY"

echo "Backup uploaded successfully to s3://$S3_BUCKET/$S3_KEY"

