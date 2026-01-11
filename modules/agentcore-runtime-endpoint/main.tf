resource "aws_bedrockagentcore_agent_runtime_endpoint" "runtime_endpoint" {
  name             = var.name
  description      = var.description
  agent_runtime_id = var.agent_runtime_id

}

