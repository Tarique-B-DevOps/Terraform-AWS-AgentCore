resource "aws_bedrockagentcore_memory" "memory" {
  name                  = var.memory_name
  description           = var.memory_description
  event_expiry_duration = var.event_expiry_duration

}

resource "aws_bedrockagentcore_memory_strategy" "strategies" {
  for_each = var.memory_strategies

  name        = each.value.name
  memory_id   = aws_bedrockagentcore_memory.memory.id
  type        = each.value.type
  description = each.value.description
  namespaces  = each.value.namespaces
}