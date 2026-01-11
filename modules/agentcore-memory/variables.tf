variable "memory_name" {
  description = "Name of the Bedrock AgentCore memory"
  type        = string
  default     = "ComprehensiveAgentMemory"
}

variable "memory_description" {
  description = "Description of the Bedrock AgentCore memory"
  type        = string
  default     = "Full-featured memory with all built-in strategies"
}

variable "event_expiry_duration" {
  description = "Event expiry duration in days"
  type        = number
  default     = 30
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