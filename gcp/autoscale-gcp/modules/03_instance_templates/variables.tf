variable "project_name" {
  type        = string
  description = "Project name"
}
variable "tags" {
  type        = list(any)
  description = "Instance template network tags"
  default     = ["http"]
}
variable "machine_type" {
  type        = string
  description = "Machine sizes"
  default     = "f1-micro"
}
variable "image" {
  type        = string
  description = "template Image"
  default     = "debian-cloud/debian-9"
}
variable "network" {
  type        = string
  description = "VPC to use"
}
variable "subnetwork" {
  type        = string
  description = "Subnet to use"
}
variable "labels" {
  type = map(string)
  default = {
    env      = "POC"
    function = "build-agent"
  }
}
variable "image_family" {
  type        = string
  description = "GCE image family"
}
variable "image_project" {
  type        = string
  description = "GCE image project"
}
variable "bucket_id" {
  type        = string
  description = "Storage for startup script"
}
variable "rolesList" {
  type        = list(any)
  description = "List of roles required by the build agent"
  default     = ["roles/storage.objectViewer"]
}
variable "zone" {
  type        = string
  description = "Project location"
}