variable "agent_runtime_name" {
  description = "Name of the Bedrock Agent Runtime"
  type        = string
}

variable "description" {
  description = "Description of the Bedrock Agent Runtime"
  type        = string
}

variable "network_mode" {
  description = "Network mode for the runtime (PUBLIC or VPC)"
  type        = string
  default     = "PUBLIC"
  validation {
    condition     = contains(["PUBLIC", "VPC"], var.network_mode)
    error_message = "Network mode must be either PUBLIC or VPC."
  }
}

variable "vpc_security_groups" {
  description = "Security groups associated with the VPC configuration. Required when network_mode is VPC."
  type        = list(string)
  default     = []
}

variable "vpc_subnets" {
  description = "Subnets associated with the VPC configuration. Required when network_mode is VPC."
  type        = list(string)
  default     = []
}

variable "environment_variables" {
  description = "Environment variables for the runtime"
  type        = map(string)
  default = {
    "LOG_LEVEL" = "INFO"
  }
}

variable "agent_ecr_image_uri" {
  description = "URI of the ECR image for the agent"
  type        = string
}