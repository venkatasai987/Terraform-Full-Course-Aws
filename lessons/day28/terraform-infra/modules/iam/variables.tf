variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "secrets_arns" {
  description = "List of Secrets Manager ARNs that EC2 instances can access"
  type        = list(string)
  default     = ["*"]
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
variable "account_id" {
  type        = string
  default     = "476114123896"
  description = "AWS Account ID for constructing ARNs"
}
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region for constructing ARNs"
}
