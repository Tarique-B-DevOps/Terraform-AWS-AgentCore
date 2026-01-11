output "agent_runtime_id" {
  description = "ID of the Bedrock Agent Runtime"
  value       = module.agentcore_runtime.agent_runtime_id
}

output "agent_runtime_arn" {
  description = "ARN of the Bedrock Agent Runtime"
  value       = module.agentcore_runtime.agent_runtime_arn
}

output "agent_runtime_name" {
  description = "Name of the Bedrock Agent Runtime"
  value       = module.agentcore_runtime.agent_runtime_name
}

output "memory_id" {
  description = "ID of the Bedrock AgentCore memory"
  value       = module.agentcore_memory.memory_id
}

output "memory_arn" {
  description = "ARN of the Bedrock AgentCore memory"
  value       = module.agentcore_memory.memory_arn
}