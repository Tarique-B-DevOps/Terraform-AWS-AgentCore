module "agentcore_runtime" {
  source                = "./modules/agentcore-runtime"
  agent_runtime_name    = "${var.agent_name}_${var.agent_env}"
  description           = var.agent_description
  network_mode          = var.network_mode
  vpc_security_groups   = var.vpc_security_groups
  vpc_subnets           = var.vpc_subnets
  environment_variables = var.environment_variables
  agent_ecr_image_uri   = var.agent_ecr_image_uri
}

module "agentcore_runtime_endpoint" {
  source           = "./modules/agentcore-runtime-endpoint"
  name             = "${var.agent_name}_${var.agent_env}"
  description      = var.agent_description
  agent_runtime_id = module.agentcore_runtime.agent_runtime_id
}

module "agentcore_memory" {
  source             = "./modules/agentcore-memory"
  memory_name        = "${var.agent_name}_${var.agent_env}_LongTermMemory"
  memory_description = var.agent_description
  memory_strategies  = var.memory_strategies
}