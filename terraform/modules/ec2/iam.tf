resource "aws_iam_role" "ec2_s3_backup_role" {
  name = "ec2-s3-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "s3_backup_policy" {
  name        = "s3-backup-policy"
  description = "Allow EC2 instance to access S3 backup bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::wp-presta-backups",
          "arn:aws:s3:::wp-presta-backups/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_attach_policy" {
  role       = aws_iam_role.ec2_s3_backup_role.name
  policy_arn = aws_iam_policy.s3_backup_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-s3-backup-profile"
  role = aws_iam_role.ec2_s3_backup_role.name
}

