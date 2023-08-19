resource "random_string" "suffix" {
  length  = 8
  special = false
  lower   = true
  upper   = false
}

module "bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "~> 3.14.1"
  bucket        = "json-bucket-${random_string.suffix.result}"
  force_destroy = true
}

module "s3_object" {
  source        = "terraform-aws-modules/s3-bucket/aws//modules/object"
  version       = "~> 3.14.1"
  bucket        = module.bucket.s3_bucket_id
  key           = "json-bucket-${random_string.suffix.result}.json"
  content       = <<EOF
{
  "greeting": "I am the Foo"
}
EOF
  content_type  = "application/json"
  force_destroy = true
}


output "S3_BUCKET_NAME" {
  value       = module.bucket.s3_bucket_id
  description = "s3 bucket name"
}

output "S3_JSON_FILE_NAME" {
  value       = module.s3_object.s3_object_id
  description = "the file name and extension uploaded to s3"
}