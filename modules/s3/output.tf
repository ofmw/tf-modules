output "s3-domain-name" {
  value = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
}

output "s3-id" {
  value = aws_s3_bucket.s3_bucket.id
}
