locals {
  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env        = local.environment_vars.locals.environment
  aws_region = local.region_vars.locals.aws_region
}

terraform {
  source = "git@github.com:silazare/terraform-aws-example.git//modules/webserver?ref=v1.0.4"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "database" {
  config_path = "../database"
}

dependency "aws-data" {
  config_path = "../aws-data"
}

dependencies {
  paths = ["../vpc", "../database", "../aws-data"]
}

inputs = {
  cluster_name = "webserver"
  environment  = "${local.env}"
  server_text  = "${local.env} webserver at ${local.aws_region}"

  ami                = dependency.aws-data.outputs.ubuntu_ami_id
  instance_type      = "t3.micro"
  min_size           = 1
  max_size           = 1
  enable_autoscaling = false

  db_address = dependency.database.outputs.database_address
  db_port    = dependency.database.outputs.database_port

  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.public_subnets

  custom_tags = {
    Terragrunt  = "true"
    Environment = "${local.env}"
  }
}
