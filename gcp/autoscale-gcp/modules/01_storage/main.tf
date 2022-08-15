resource "random_id" "id" {
  byte_length = 1
  prefix      = "${var.project}-"
}

resource "google_storage_bucket" "bucket" {
  name                        = random_id.id.hex
  location                    = var.region
  uniform_bucket_level_access = true
  storage_class               = var.storage_class
  force_destroy               = true
}