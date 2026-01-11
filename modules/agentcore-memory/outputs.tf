output "memory_id" {
  description = "ID of the Bedrock AgentCore memory"
  value       = aws_bedrockagentcore_memory.memory.id
}

output "memory_arn" {
  description = "ARN of the Bedrock AgentCore memory"
  value       = aws_bedrockagentcore_memory.memory.arn
}

output "memory_name" {
  description = "Name of the Bedrock AgentCore memory"
  value       = aws_bedrockagentcore_memory.memory.name
}
