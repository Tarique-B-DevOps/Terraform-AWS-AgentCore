data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_bedrockagentcore_agent_runtime" "agent_runtime" {
  agent_runtime_name = var.agent_runtime_name
  description        = var.description
  role_arn           = var.create_execution_role ? aws_iam_role.agent_runtime_role[0].arn : var.execution_role_arn

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
    precondition {
      condition     = var.create_execution_role || (var.execution_role_arn != "")
      error_message = "When create_execution_role is false, execution_role_arn must be provided."
    }
  }

  protocol_configuration {
    server_protocol = var.server_protocol
  }

}

resource "aws_iam_role" "agent_runtime_role" {
  count = var.create_execution_role ? 1 : 0
  name  = "Bedrock_AgentCore_Runtime_Role_${var.agent_runtime_name}"
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

resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each   = var.create_execution_role ? toset(var.managed_policy_names) : toset([])
  role       = aws_iam_role.agent_runtime_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
}

resource "aws_iam_role_policy" "agent_runtime_policy" {
  count = var.create_execution_role ? 1 : 0
  name  = "Bedrock_AgentCore_Runtime_Policy"
  role  = aws_iam_role.agent_runtime_role[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ECRImageAccess"
        Effect = "Allow"
        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = [
          "arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogStreams",
          "logs:CreateLogGroup"
        ]
        Resource = [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/bedrock-agentcore/runtimes/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups"
        ]
        Resource = [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/bedrock-agentcore/runtimes/*:log-stream:*"
        ]
      },
      {
        Sid    = "ECRTokenAccess"
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets"
        ]
        Resource = ["*"]
      },
      {
        Effect   = "Allow"
        Resource = "*"
        Action   = "cloudwatch:PutMetricData"
        Condition = {
          StringEquals = {
            "cloudwatch:namespace" = "bedrock-agentcore"
          }
        }
      },
      {
        Sid    = "GetAgentAccessToken"
        Effect = "Allow"
        Action = [
          "bedrock-agentcore:GetWorkloadAccessToken",
          "bedrock-agentcore:GetWorkloadAccessTokenForJWT",
          "bedrock-agentcore:GetWorkloadAccessTokenForUserId"
        ]
        Resource = [
          "arn:aws:bedrock-agentcore:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:workload-identity-directory/default",
          "arn:aws:bedrock-agentcore:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:workload-identity-directory/default/workload-identity/${var.agent_runtime_name}-*"
        ]
      },
      {
        Sid    = "BedrockModelInvocation"
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Resource = [
          "arn:aws:bedrock:*::foundation-model/*",
          "arn:aws:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
        ]
      }
    ]
  })
}
