# agent info
agent_name        = "StrandsAgent"
agent_description = "Strands Agent Powered by AWS Bedrock AgentCore"
agent_env         = "Dev"
agent_version     = "1.0.0"

# Default tags
tags = {
  "Agent"       = "StrandsAgent",
  "Framework"   = "Strands",
  "Environment" = "Dev"
  "Version"     = "1.0.0"
  "Terraform"   = "True"
}


# Agentcore runtime configuration
agent_ecr_image_uri = "your-ecr-image-uri"
network_mode        = "VPC"
vpc_security_groups = ["your-vpc-security-group-id"]
vpc_subnets         = ["your-vpc-subnet-id"]
environment_variables = {
  "LOG_LEVEL" = "INFO"
}

# Agentcore memory configuration
memory_strategies = {
  semantic = {
    name        = "FactExtractor"
    type        = "SEMANTIC"
    description = "Semantic understanding strategy"
    namespaces  = ["/facts/{actorId}"]
  }
  summary = {
    name        = "SessionSummarizer"
    type        = "SUMMARIZATION"
    description = "Text summarization strategy"
    namespaces  = ["/summaries/{actorId}/{sessionId}"]
  }
  user_pref = {
    name        = "PreferenceLearner"
    type        = "USER_PREFERENCE"
    description = "User preference tracking strategy"
    namespaces  = ["/preferences/{actorId}"]
  }
}

