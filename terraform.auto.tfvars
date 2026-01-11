# agent info
agent_name        = "CloudOps_Agent"
agent_description = "Strands Agent Powered by AWS Bedrock AgentCore"
agent_env         = "Dev"
agent_version     = "1.0.0"

# Default tags
tags = {
  "Agent"       = "CloudOps_Agent",
  "Framework"   = "Strands",
  "Environment" = "Dev"
  "Version"     = "1.0.0"
  "Terraform"   = "True"
}


# Agentcore runtime configuration
network_mode = "PUBLIC"
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

