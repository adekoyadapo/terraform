variable "cidr" {
  type        = string
  description = "subnet block"
}

variable "region" {
  type        = string
  description = "Project location"
}

variable "credentials_file" {
  type        = string
  description = "credentials file location"
}

variable "zone" {
  type        = string
  description = "Project location"
}
variable "project_id" {
  type        = string
  description = "Project id"
  default     = ""
}
variable "labels" {
  type = map(string)
  default = {
    env      = "poc"
    function = "build-agent"
  }
}