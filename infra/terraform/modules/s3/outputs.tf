output "app_bucket" {
  value = aws_s3_bucket.app.bucket
}

output "backup_bucket" {
  value = aws_s3_bucket.backups.bucket
}
