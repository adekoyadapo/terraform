# terraform {
#  backend "s3" {
#    bucket         = "<BUCKET_NAME>" # update with the output of the bucket name
#    key            = "backend/terraform.tfstate" 
#    region         = "ca-central-1" 
# #    encrypt        = true
# #    kms_key_id     = "alias/terraform-bucket-key"
#  }
# }