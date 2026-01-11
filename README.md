# Terraform AWS Bedrock AgentCore Modules

[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=flat&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Bedrock](https://img.shields.io/badge/AWS%20Bedrock-AgentCore-orange)](https://aws.amazon.com/bedrock/)

Production-ready Terraform modules for deploying and managing **AWS Bedrock AgentCore** infrastructure. This repository provides reusable Infrastructure as Code (IaC) modules for creating AgentCore runtime environments, endpoints, and memory systems with configurable strategies.

## 🚀 Overview

Deploy AWS Bedrock AgentCore resources using Terraform modules. These modules simplify the provisioning of:
- **AgentCore Runtime** - Containerized agent runtime with IAM roles, network configuration, and protocol support
- **AgentCore Runtime Endpoint** - API endpoints for agent runtime access
- **AgentCore Memory** - Long-term memory systems with semantic, summarization, and user preference strategies

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| **Modular Architecture** | Separate modules for runtime, endpoints, and memory for flexible deployments |
| **Infrastructure as Code** | Version-controlled, repeatable deployments with Terraform |
| **Flexible IAM Management** | Create new IAM roles or use existing ones with managed policy attachments |
| **Network Flexibility** | Support for both PUBLIC and VPC network modes with security groups and subnets |
| **Protocol Support** | HTTP, MCP, and A2A protocol configurations |
| **Memory Strategies** | Configurable memory strategies (SEMANTIC, SUMMARIZATION, USER_PREFERENCE) |
| **Least Privilege IAM** | Fine-grained IAM policies with separate SIDs for each permission set |
| **Targeted Deployments** | Apply, plan, or destroy specific modules independently |
| **Production Ready** | Includes security configurations, validations, and best practices |

## 📋 Prerequisites

- **Terraform** >= 1.0.0
- **AWS CLI** configured with appropriate credentials
- **AWS Provider** >= 6.27.0
- **AWS Account** with Bedrock AgentCore service access
- **ECR Repository** with containerized agent image (for runtime module)

## 🏗️ Module Architecture

### agentcore-runtime Module

The runtime module provisions a complete Bedrock AgentCore runtime environment with containerized agents, IAM roles, and network configuration.

#### Features

| Feature | Details |
|---------|---------|
| **Container Runtime** | Deploys agent containers from ECR repositories |
| **IAM Role Management** | Creates execution roles with least-privilege policies or uses existing roles |
| **Network Modes** | Supports PUBLIC and VPC network configurations |
| **VPC Integration** | Configurable security groups and subnets for VPC mode |
| **Protocol Support** | HTTP, MCP (Model Context Protocol), and A2A (Agent-to-Agent) protocols |
| **Environment Variables** | Customizable environment variables for runtime configuration |
| **Managed Policies** | Attach AWS managed IAM policies to execution roles |
| **Comprehensive IAM** | Includes permissions for ECR, CloudWatch Logs, X-Ray, Bedrock, and AgentCore |

#### Runtime Module Variables

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `agent_runtime_name` | `string` | Yes | - | Name of the Bedrock Agent Runtime |
| `description` | `string` | Yes | - | Description of the Bedrock Agent Runtime |
| `agent_ecr_image_uri` | `string` | Yes | - | URI of the ECR image for the agent (e.g., `123456789012.dkr.ecr.us-east-1.amazonaws.com/repo:tag`) |
| `server_protocol` | `string` | Yes | - | Protocol for the server. Valid values: `HTTP`, `MCP`, `A2A` |
| `create_execution_role` | `bool` | No | `true` | Whether to create a new IAM execution role |
| `execution_role_arn` | `string` | No | `""` | ARN of existing IAM role (required when `create_execution_role = false`) |
| `managed_policy_names` | `list(string)` | No | `["ReadOnlyAccess"]` | List of AWS managed IAM policy names (e.g., `["ReadOnlyAccess", "CloudWatchReadOnlyAccess"]`) |
| `network_mode` | `string` | No | `"PUBLIC"` | Network mode. Valid values: `PUBLIC`, `VPC` |
| `vpc_security_groups` | `list(string)` | No | `[]` | Security groups for VPC mode (required when `network_mode = "VPC"`) |
| `vpc_subnets` | `list(string)` | No | `[]` | Subnets for VPC mode (required when `network_mode = "VPC"`) |
| `environment_variables` | `map(string)` | No | `{"LOG_LEVEL" = "INFO"}` | Environment variables for the runtime |

#### Runtime Module IAM Permissions

The module creates an IAM role with the following permission sets:

| Permission Set | Actions | Resources |
|----------------|--------|-----------|
| **ECRImageAccess** | `ecr:BatchGetImage`, `ecr:GetDownloadUrlForLayer` | ECR repositories in account |
| **ECRTokenAccess** | `ecr:GetAuthorizationToken` | `*` |
| **CloudWatch Logs** | `logs:DescribeLogStreams`, `logs:CreateLogGroup`, `logs:DescribeLogGroups`, `logs:CreateLogStream`, `logs:PutLogEvents` | Bedrock AgentCore log groups |
| **X-Ray Tracing** | `xray:PutTraceSegments`, `xray:PutTelemetryRecords`, `xray:GetSamplingRules`, `xray:GetSamplingTargets` | `*` |
| **CloudWatch Metrics** | `cloudwatch:PutMetricData` | `*` (with namespace condition) |
| **GetAgentAccessToken** | `bedrock-agentcore:GetWorkloadAccessToken`, `bedrock-agentcore:GetWorkloadAccessTokenForJWT`, `bedrock-agentcore:GetWorkloadAccessTokenForUserId` | Workload identity directories |
| **AgentCoreMemoryAccess** | `bedrock-agentcore:CreateEvent`, `bedrock-agentcore:GetEvent`, `bedrock-agentcore:ListEvents`, `bedrock-agentcore:DeleteEvent`, `bedrock-agentcore:PutEvent`, `bedrock-agentcore:QueryMemory` | All memories in account (`memory/*`) |
| **BedrockModelInvocation** | `bedrock:InvokeModel`, `bedrock:InvokeModelWithResponseStream` | Foundation models and account resources |

#### Runtime Module Outputs

| Output | Description |
|--------|-------------|
| `agent_runtime_id` | ID of the Bedrock Agent Runtime |
| `agent_runtime_arn` | ARN of the Bedrock Agent Runtime |
| `agent_runtime_name` | Name of the Bedrock Agent Runtime |
| `role_arn` | ARN of the IAM role (created or provided) |
| `role_created` | Boolean indicating if the role was created by the module |

### agentcore-memory Module

The memory module creates long-term memory systems for agents with configurable strategies for semantic understanding, summarization, and user preferences.

#### Features

| Feature | Details |
|---------|---------|
| **Memory Strategies** | Configurable memory strategies using `for_each` for dynamic creation |
| **Strategy Types** | SEMANTIC, SUMMARIZATION, USER_PREFERENCE |
| **Namespace Configuration** | Custom namespace patterns for organizing memory data |
| **Event Expiry** | Configurable event expiry duration in days |
| **Dynamic Creation** | Create multiple strategies with a single configuration |

#### Memory Module Variables

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `memory_name` | `string` | No | `"ComprehensiveAgentMemory"` | Name of the Bedrock AgentCore memory |
| `memory_description` | `string` | No | `"Full-featured memory with all built-in strategies"` | Description of the memory |
| `event_expiry_duration` | `number` | No | `30` | Event expiry duration in days |
| `memory_strategies` | `map(object)` | No | `{}` | Map of memory strategies. See structure below |

#### Memory Strategy Structure

Each strategy in `memory_strategies` must have the following structure:

```hcl
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
```

| Strategy Type | Description | Common Use Cases |
|---------------|-------------|------------------|
| **SEMANTIC** | Extracts and stores factual information and entities | Long-term fact storage, entity recognition |
| **SUMMARIZATION** | Generates and stores conversation summaries | Session context, conversation history |
| **USER_PREFERENCE** | Learns and stores user preferences | Personalization, user-specific settings |

#### Memory Module Outputs

| Output | Description |
|--------|-------------|
| `memory_id` | ID of the Bedrock AgentCore memory |
| `memory_arn` | ARN of the Bedrock AgentCore memory |
| `memory_name` | Name of the Bedrock AgentCore memory |

### agentcore-runtime-endpoint Module

Creates API endpoints for accessing the agent runtime.

| Feature | Details |
|---------|---------|
| **Endpoint Creation** | Creates runtime endpoints for agent access |
| **Runtime Integration** | Links endpoints to agent runtime resources |

## 🛠️ Usage Examples

### Basic Configuration

```hcl
module "agentcore_runtime" {
  source                = "./modules/agentcore-runtime"
  agent_runtime_name    = "my-agent-dev"
  description           = "My Agent Runtime"
  agent_ecr_image_uri   = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-agent:latest"
  server_protocol       = "HTTP"
  network_mode          = "PUBLIC"
  create_execution_role = true
  managed_policy_names  = ["ReadOnlyAccess"]
}

module "agentcore_memory" {
  source             = "./modules/agentcore-memory"
  memory_name         = "my-agent-memory"
  memory_description  = "Agent memory system"
  memory_strategies   = {
    semantic = {
      name        = "FactExtractor"
      type        = "SEMANTIC"
      description = "Semantic understanding"
      namespaces  = ["/facts/{actorId}"]
    }
  }
}
```

### VPC Configuration

```hcl
module "agentcore_runtime" {
  source              = "./modules/agentcore-runtime"
  agent_runtime_name  = "my-agent-prod"
  description         = "Production Agent Runtime"
  agent_ecr_image_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-agent:v1.0.0"
  server_protocol     = "HTTP"
  network_mode        = "VPC"
  vpc_security_groups = ["sg-12345678", "sg-87654321"]
  vpc_subnets         = ["subnet-12345678", "subnet-87654321"]
  create_execution_role = true
  managed_policy_names  = ["ReadOnlyAccess", "CloudWatchReadOnlyAccess"]
}
```

### Using Existing IAM Role

```hcl
module "agentcore_runtime" {
  source              = "./modules/agentcore-runtime"
  agent_runtime_name  = "my-agent"
  description         = "Agent with existing role"
  agent_ecr_image_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-agent:latest"
  server_protocol     = "HTTP"
  create_execution_role = false
  execution_role_arn    = "arn:aws:iam::123456789012:role/MyExistingRole"
}
```

### Complete Memory Configuration

```hcl
module "agentcore_memory" {
  source             = "./modules/agentcore-memory"
  memory_name         = "comprehensive-memory"
  memory_description  = "Full memory system"
  event_expiry_duration = 60
  memory_strategies   = {
    semantic = {
      name        = "FactExtractor"
      type        = "SEMANTIC"
      description = "Captures factual information and entities"
      namespaces  = ["/facts/{actorId}", "/entities/{actorId}"]
    }
    summary = {
      name        = "SessionSummarizer"
      type        = "SUMMARIZATION"
      description = "Generates conversation summaries"
      namespaces  = ["/summaries/{actorId}/{sessionId}"]
    }
    user_pref = {
      name        = "PreferenceLearner"
      type        = "USER_PREFERENCE"
      description = "Learns user preferences"
      namespaces  = ["/preferences/{actorId}"]
    }
  }
}
```

## 🎯 Terraform Commands

### Apply All Modules
```bash
terraform apply
```

### Apply Specific Modules

| Command | Description |
|---------|-------------|
| `terraform apply -target=module.agentcore_runtime` | Deploy only runtime |
| `terraform apply -target=module.agentcore_runtime_endpoint` | Deploy only endpoint |
| `terraform apply -target=module.agentcore_memory` | Deploy only memory |
| `terraform apply -target=module.agentcore_runtime -target=module.agentcore_runtime_endpoint` | Deploy runtime and endpoint |
| `terraform apply -target=module.agentcore_runtime -target=module.agentcore_memory` | Deploy runtime and memory |

### Plan Commands

| Command | Description |
|---------|-------------|
| `terraform plan` | Plan all resources |
| `terraform plan -target=module.agentcore_runtime` | Plan runtime module |
| `terraform plan -target=module.agentcore_memory` | Plan memory module |

### Destroy Commands

| Command | Description |
|---------|-------------|
| `terraform destroy` | Destroy all resources |
| `terraform destroy -target=module.agentcore_runtime` | Destroy runtime only |
| `terraform destroy -target=module.agentcore_memory` | Destroy memory only |

## 📊 Root Module Variables

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `agent_name` | `string` | Yes | - | Name of the agent |
| `agent_env` | `string` | Yes | - | Environment (e.g., dev, staging, prod) |
| `agent_version` | `string` | Yes | - | Version of the agent |
| `agent_description` | `string` | No | `""` | Description of the Bedrock Agent Runtime |
| `agent_ecr_image_uri` | `string` | No | `""` | URI of the ECR image for the agent |
| `server_protocol` | `string` | Yes | - | Protocol (HTTP, MCP, or A2A) |
| `create_execution_role` | `bool` | No | `true` | Create new IAM role |
| `execution_role_arn` | `string` | No | `""` | Existing IAM role ARN |
| `managed_policy_names` | `list(string)` | No | `[]` | AWS managed policy names |
| `network_mode` | `string` | No | `"PUBLIC"` | Network mode (PUBLIC or VPC) |
| `vpc_security_groups` | `list(string)` | No | `[]` | VPC security groups |
| `vpc_subnets` | `list(string)` | No | `[]` | VPC subnets |
| `environment_variables` | `map(string)` | No | `{}` | Runtime environment variables |
| `memory_strategies` | `map(object)` | No | `{}` | Memory strategies configuration |
| `region` | `string` | No | `"us-east-1"` | AWS region |
| `tags` | `map(string)` | No | `{}` | Default tags for resources |

## 🔒 Security Features

| Feature | Implementation |
|---------|----------------|
| **Least Privilege IAM** | Fine-grained permissions with separate SIDs for each permission set |
| **VPC Support** | Deploy agents in private VPCs with security groups and subnets |
| **IAM Role Flexibility** | Use existing roles or create new ones with managed policies |
| **Resource Scoping** | All IAM permissions scoped to specific resources and conditions |
| **Validation** | Preconditions ensure required variables are provided |

## 📚 Related Resources

- [AWS Bedrock Documentation](https://docs.aws.amazon.com/bedrock/)
- [AWS Bedrock AgentCore](https://aws.amazon.com/bedrock/agentcore/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS IAM Managed Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html)