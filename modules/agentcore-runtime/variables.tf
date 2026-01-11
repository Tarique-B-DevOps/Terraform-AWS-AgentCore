variable "agent_runtime_name" {
  description = "Name of the Bedrock Agent Runtime"
  type        = string
}

variable "description" {
  description = "Description of the Bedrock Agent Runtime"
  type        = string
}

variable "create_execution_role" {
  description = "Whether to create a new IAM execution role. If false, execution_role_arn must be provided."
  type        = bool
  default     = true
}

variable "execution_role_arn" {
  description = "ARN of an existing IAM role to use for the agent runtime. Required when create_execution_role is false."
  type        = string
  default     = ""
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

variable "server_protocol" {
  description = "Protocol for the server"
  type        = string
  validation {
    condition     = contains(["HTTP", "MCP", "A2A"], var.server_protocol)
    error_message = "Server protocol must be either HTTP, MCP, or A2A."
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

variable "managed_policy_names" {
  description = "List of AWS managed IAM policy names to attach to the execution role. ARNs will be constructed as 'arn:aws:iam::aws:policy/{name}'. Only used when create_execution_role is true."
  type        = list(string)
  default     = ["ReadOnlyAccess"]
}