output "runtime_endpoint_arn" {
  description = "ARN of the Bedrock Agent Runtime Endpoint"
  value       = aws_bedrockagentcore_agent_runtime_endpoint.runtime_endpoint.agent_runtime_arn
}

output "runtime_endpoint_name" {
  description = "Name of the Bedrock Agent Runtime Endpoint"
  value       = aws_bedrockagentcore_agent_runtime_endpoint.runtime_endpoint.name
}