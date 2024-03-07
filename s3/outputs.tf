output "bucket_name" {
  value = local.bucket_name
}

output "bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}