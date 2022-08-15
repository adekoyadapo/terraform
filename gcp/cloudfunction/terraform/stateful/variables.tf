variable "region" {
}

variable "project_id" {
}

variable "credentials_file" {
}

variable "function_name" {
  default = "helloHttp"
}

variable "cost_centre" {
  type = map(string)

  default = {
    uat        = "developers"
    staging    = "developers"
    production = "operations"
  }
}
variable "environment_name" {
  description = "'staging' or 'production'"
  default     = "staging"
}
