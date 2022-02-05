resource "null_resource" "git_clone_to_gcs" {
  depends_on = [
    google_storage_bucket.bucket
  ]
  provisioner "local-exec" { 
    interpreter   = ["/bin/bash" ,"-c"]
    command       = <<-EOT
                  git clone $url repo
                  ls -al repo
                  gsutil cp -r repo/* gs://$bucket
                  EOT
                  environment = {
                  url         = var.url
                  bucket      = google_storage_bucket.bucket.name
    }
  } 
}

resource "null_resource" "remove_artifacts" {
  provisioner "local-exec" {
    when         = destroy 
    interpreter  = ["/bin/bash" ,"-c"]
    command      = <<-EOT
                 rm -rf repo
                 EOT
  } 
}
