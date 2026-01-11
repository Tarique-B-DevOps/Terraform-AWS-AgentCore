# Terraform AWS Bedrock AgentCore Modules

[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=flat&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Bedrock](https://img.shields.io/badge/AWS%20Bedrock-AgentCore-orange)](https://aws.amazon.com/bedrock/)

Production-ready Terraform modules for deploying and managing **AWS Bedrock AgentCore** infrastructure. This repository provides reusable Infrastructure as Code (IaC) modules for creating AgentCore runtime environments, endpoints, and memory systems with configurable strategies.

## 🚀 Overview

Deploy AWS Bedrock AgentCore resources using Terraform modules. These modules simplify the provisioning of:
- **AgentCore Runtime** - Containerized agent runtime with IAM roles and network configuration
- **AgentCore Runtime Endpoint** - API endpoints for agent runtime access
- **AgentCore Memory** - Long-term memory systems with semantic, summarization, and user preference strategies

## ✨ Features

- **Modular Architecture**: Separate modules for runtime, endpoints, and memory
- **Infrastructure as Code**: Version-controlled, repeatable deployments
- **Flexible Configuration**: Customize memory strategies, network modes, and environment variables
- **Targeted Deployments**: Apply, plan, or destroy specific modules independently
- **Production Ready**: Includes IAM roles, security configurations, and best practices

## 📋 Prerequisites

- **Terraform** >= 1.0.0
- **AWS CLI** configured with appropriate credentials
- **AWS Provider** >= 6.27.0
- **AWS Account** with Bedrock AgentCore service access

## 🏗️ Modules

### agentcore-runtime
Bedrock AgentCore runtime module that provisions:
- Containerized agent runtime environment
- IAM roles and policies for runtime execution
- Network configuration (PUBLIC or VPC mode)
- Environment variable management

### agentcore-runtime-endpoint
Runtime endpoint module that creates:
- API endpoints for agent runtime access
- Endpoint configuration and management

### agentcore-memory
Memory module with configurable strategies:
- Semantic memory for fact extraction
- Summarization for session context
- User preference tracking
- Custom namespace configuration

## 🛠️ Usage

### Apply All Modules
Deploy the complete AgentCore infrastructure:
```bash
terraform apply
```

### Apply Specific Modules

**Deploy only AgentCore runtime:**
```bash
terraform apply -target=module.agentcore_runtime
```

**Deploy only runtime endpoint:**
```bash
terraform apply -target=module.agentcore_runtime_endpoint
```

**Deploy only memory system:**
```bash
terraform apply -target=module.agentcore_memory
```

**Deploy runtime and endpoint together:**
```bash
terraform apply -target=module.agentcore_runtime -target=module.agentcore_runtime_endpoint
```

**Deploy runtime and memory together:**
```bash
terraform apply -target=module.agentcore_runtime -target=module.agentcore_memory
```

### Plan Specific Modules

**Plan all resources:**
```bash
terraform plan
```

**Plan specific module:**
```bash
terraform plan -target=module.agentcore_runtime
terraform plan -target=module.agentcore_runtime_endpoint
terraform plan -target=module.agentcore_memory
```

### Destroy Commands

**Destroy all resources:**
```bash
terraform destroy
```

**Destroy specific module:**
```bash
terraform destroy -target=module.agentcore_runtime
terraform destroy -target=module.agentcore_runtime_endpoint
terraform destroy -target=module.agentcore_memory
```

## 📚 Related Resources

- [AWS Bedrock Documentation](https://docs.aws.amazon.com/bedrock/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Documentation](https://www.terraform.io/docs)