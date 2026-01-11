output "agent_runtime_id" {
  description = "ID of the Bedrock Agent Runtime"
  value       = aws_bedrockagentcore_agent_runtime.agent_runtime.agent_runtime_id
}

output "agent_runtime_arn" {
  description = "ARN of the Bedrock Agent Runtime"
  value       = aws_bedrockagentcore_agent_runtime.agent_runtime.agent_runtime_arn
}

output "agent_runtime_name" {
  description = "Name of the Bedrock Agent Runtime"
  value       = aws_bedrockagentcore_agent_runtime.agent_runtime.agent_runtime_name
}

output "role_arn" {
  description = "ARN of the IAM role for the Agent Runtime"
  value       = var.create_execution_role ? aws_iam_role.agent_runtime_role[0].arn : var.execution_role_arn
}

output "role_created" {
  description = "Whether the IAM role was created by this module"
  value       = var.create_execution_role
}

