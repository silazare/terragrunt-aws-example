locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
}

terraform {
  source = "git@github.com:silazare/terraform-aws-example.git//modules/db-mysql?ref=v1.0.4"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

dependencies {
  paths = ["../vpc"]
}

inputs = {
  environment            = "${local.env}"
  db_prefix              = "${local.env}-db"
  db_engine              = "mysql"
  db_storage             = 5
  db_instance_class      = "db.t2.micro"
  db_name                = "${local.env}"
  db_port                = 3306
  db_user_name           = "admin"
  db_publicly_accessible = false

  subnet_ids = dependency.vpc.outputs.private_subnets

  tags = {
    Name        = "${local.env}-db"
    Environment = "${local.env}"
    Terragrunt  = "true"
  }
}
