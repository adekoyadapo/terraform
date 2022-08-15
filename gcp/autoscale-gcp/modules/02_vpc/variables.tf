variable "cidr" {
  type        = string
  description = "subnet block"
}

variable "region" {
  type        = string
  description = "Project location"
}
variable "tags" {
  type        = list(any)
  description = "Instance template network tags"
  default     = ["http"]
}