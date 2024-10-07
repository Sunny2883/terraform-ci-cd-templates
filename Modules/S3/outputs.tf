output "bucket_name_output" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.terraformtemplatebucket.bucket_domain_name
}