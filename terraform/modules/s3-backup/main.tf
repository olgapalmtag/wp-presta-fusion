#################################################################
# S3 bucket that stores SQL dumps created by the GitHub Action. #
#################################################################

resource "aws_s3_bucket" "backup" {
  bucket        = var.bucket_name          # e.g. wp-presta-backups
  force_destroy = true                     # allow terraform destroy
  tags = {
    Name    = var.bucket_name
    Project = "wp-presta-fusion"
  }
}

#########################################
# Lifecycle rule – delete after 7 days. #
#########################################

resource "aws_s3_bucket_lifecycle_configuration" "delete_old_backups" {
  bucket = aws_s3_bucket.backup.id

  rule {
    id     = "delete-db-backups-after-7-days"
    status = "Enabled"

    filter { prefix = "db-backups/" }      # only our SQL dumps

    expiration {
      days = 7                             # ← retention period
    }
  }
}

#################
# Versioning -- #
#################

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.backup.id
  versioning_configuration { status = "Enabled" }
}

