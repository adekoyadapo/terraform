terraform {
 backend "gcs" {
   bucket  = "dummy-admin-proj"
   prefix  = "terraform-proj/state/admin_tfstate"
 }
}