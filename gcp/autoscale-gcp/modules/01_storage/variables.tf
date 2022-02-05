variable "url" {
  type        = string
  description = "github url"
}
variable "bucket_name" {
    type = string
    description = "bucket storage name"
}
variable "region" {
  type           = string
  description    = "Project location" 
}
variable "org_id" {
}
variable "storage_class" {
  default = "STANDARD"
}
variable "project" {
  type           = string
  description    = "Project name" 
}
