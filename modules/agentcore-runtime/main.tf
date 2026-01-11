resource "aws_iam_role" "agent_runtime_role" {
  name = "bedrock_agent_runtime_role_${var.agent_runtime_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "bedrock-agentcore.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "agent_runtime_policy" {
  name = "bedrock_agent_runtime_policy"
  role = aws_iam_role.agent_runtime_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_bedrockagentcore_agent_runtime" "agent_runtime" {
  agent_runtime_name = var.agent_runtime_name
  description        = var.description
  role_arn           = aws_iam_role.agent_runtime_role.arn

  agent_runtime_artifact {
    container_configuration {
      container_uri = var.agent_ecr_image_uri
    }
  }

  network_configuration {
    network_mode = var.network_mode
    dynamic "network_mode_config" {
      for_each = var.network_mode == "VPC" ? [1] : []
      content {
        security_groups = var.vpc_security_groups
        subnets         = var.vpc_subnets
      }
    }
  }

  environment_variables = var.environment_variables

  lifecycle {
    precondition {
      condition     = var.network_mode != "VPC" || (length(var.vpc_security_groups) > 0 && length(var.vpc_subnets) > 0)
      error_message = "When network_mode is VPC, both vpc_security_groups and vpc_subnets must be provided and non-empty."
    }
  }
}

