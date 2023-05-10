variable "project" {
  description = "The project name in the Project-Service-Layer architecture"
  nullable    = false
  default     = false
}

variable "domain_name" {
  description = "The project registered domain name"
  nullable    = false
  default     = false
}

variable "terraform_organization" {
  description = "The organization name on terraform cloud"
  nullable    = false
  default     = false
}

variable "organization_email" {
  description = "The organization admin email"
  nullable    = false
  default     = false
}

variable "organization_iam_deployer_aws_access_key_id" {
  description = "The terraform organization workspace iam deployer access key id"
  nullable    = false
  default     = false
  sensitive   = true
}

variable "organization_iam_deployer_aws_secret_access_key" {
  description = "The terraform organization workspace iam deployer secret access key"
  nullable    = false
  default     = false
  sensitive   = true
}

variable "organization_variables" {
  type = map(object({
    hcl         = bool
    sensitive   = bool
    value       = string
    description = string
  }))
  default = {}
}