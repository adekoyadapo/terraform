variable "url" {
  type        = string
  description = "github url"
}
variable "credentials_file" {
  type           = string
  description    = "credentials file location" 
}
variable "region" {
  type           = string
  description    = "Project location" 
}
variable "zone" {
  type           = string
  description    = "Project location" 
}
variable "project_name" {
  type           = string
  description    = "Project name"
  default        = ""
}
variable "bucket_name" {
  type           = string
  description    = "GCS bucket for artifacts name"
  default        = ""
}

variable "org_id" {
  type           = string
  description    = "org/folder id"
  default        = ""
}
variable "cidr" {
  type        = string
  description = "subnet block"
}
variable "tags" {
  type        = list
  description = "Instance template network tags"
  default = ["http"]
}
variable "labels" {
  type = map(string)
  default = {
    env      = "POC"
    function = "build-agent"
  }
}
variable "machine_type" {
  type        = string
  description = "Machine sizes"
  default     = "f1-micro"
}
variable "network" {
  type = string
  description = "VPC to use"
  default = "default"
}
variable "subnetwork" {
  type = string
  description = "Subnet to use"
  default     = "default"
}
variable "bucket_id" {
  type = string
  description = "Storage for startup script"
  default = ""
}
variable "image_family" {
  type = string
  description = "GCE image family"
}
variable "image_project" {
  type = string
  description = "GCE image project"
}
variable "rolesList" {
  type = list
  description = "List of roles required by the build agent"
  default = ["roles/storage.objectViewer"]
}
