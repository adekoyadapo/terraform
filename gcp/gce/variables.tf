variable "cidr" {
  type        = string
  description = "subnet block"
}

variable "region" {
  type           = string
  description    = "Project location" 
}

variable "credentials_file" {
  type           = string
  description    = "credentials file location" 
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
variable "image_family" {
  type = string
  description = "GCE image family"
}
variable "image_project" {
  type = string
  description = "GCE image project"
}

variable "machine_type" {
  type        = string
  description = "Machine sizes"
  default     = "f1-micro"
}
variable "rolesList" {
  type = list
  description = "List of roles required by the build agent"
  default = ["roles/storage.objectViewer"]
}
variable "storage_class" {
  default = "STANDARD"
}
