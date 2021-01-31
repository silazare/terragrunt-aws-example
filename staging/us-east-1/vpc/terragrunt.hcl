locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git?ref=v2.64.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name = "${local.env}-vpc"
  cidr = "10.11.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.11.10.0/24", "10.11.11.0/24", "10.11.12.0/24"]
  public_subnets  = ["10.11.20.0/24", "10.11.21.0/24", "10.11.22.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Name        = "${local.env}-vpc"
    Environment = "${local.env}"
    Terragrunt  = "true"
  }
}
