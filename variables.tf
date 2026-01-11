variable "region" {
  description = "Region to deploy the resources"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "agent_name" {
  description = "Name of the agent"
  type        = string
}

variable "agent_env" {
  description = "Environment of the agent (e.g., dev, staging, prod)"
  type        = string
}

variable "agent_version" {
  description = "Version of the agent"
  type        = string
}

variable "agent_description" {
  description = "Description of the Bedrock Agent Runtime"
  type        = string
  default     = ""
}

variable "agent_ecr_image_uri" {
  description = "URI of the ECR image for the agent"
  type        = string
  default     = ""
}

variable "network_mode" {
  description = "Network mode for the runtime (PUBLIC or VPC)"
  type        = string
  default     = "PUBLIC"
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

variable "server_protocol" {
  description = "Protocol for the server"
  type        = string
}

variable "create_execution_role" {
  description = "Whether to create a new IAM execution role. If false, execution_role_arn must be provided."
  type        = bool
}

variable "execution_role_arn" {
  description = "ARN of an existing IAM role to use for the agent runtime. Required when create_execution_role is false."
  type        = string
}

variable "managed_policy_names" {
  description = "List of AWS managed IAM policy names to attach to the execution role. ARNs will be constructed as 'arn:aws:iam::aws:policy/{name}'. Only used when create_execution_role is true."
  type        = list(string)
  default     = []
}

variable "environment_variables" {
  description = "Environment variables for the runtime"
  type        = map(string)
  default     = {}
}

variable "memory_strategies" {
  description = "Map of memory strategies to create. Each strategy should have: name, type, description, and namespaces"
  type = map(object({
    name        = string
    type        = string
    description = string
    namespaces  = list(string)
  }))
  default = {}
}
