 resource "random_id" "bucket_id" {
  byte_length = 1
  prefix      = "${var.project_name}-"
  }

resource "google_storage_bucket" "bucket" {
  name          = random_id.bucket_id.hex
  location      = var.region
  uniform_bucket_level_access = true
  storage_class = var.storage_class
  force_destroy = true
}
resource "null_resource" "copy_to_bucket" {
  depends_on = [
    google_storage_bucket.bucket
  ]
  provisioner "local-exec" { 
    interpreter   = ["/bin/bash" ,"-c"]
    command       = <<-EOT
                  gsutil cp buildkite.sh gs://$bucket
                  EOT
                  environment = {
                  bucket      = google_storage_bucket.bucket.name
    }
  } 
}

resource "null_resource" "remove_artifacts" {
  provisioner "local-exec" {
    when         = destroy 
    interpreter  = ["/bin/bash" ,"-c"]
    command      = <<-EOT
                 rm -rf buildkite.sh
                 EOT
  } 
}