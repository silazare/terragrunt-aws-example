locals {
  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  env        = local.environment_vars.locals.environment
  account_id = local.environment_vars.locals.aws_account_id
  aws_region = local.region_vars.locals.aws_region
}

# Generate an AWS provider block
generate "provider" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  version = "~> 3.0"
  region  = "${local.aws_region}"

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend      = "s3"
  disable_init = tobool(get_env("TERRAGRUNT_DISABLE_INIT", "false"))

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    encrypt        = true
    region         = "eu-west-1"
    key            = format("%s/terraform.tfstate", path_relative_to_include())
    bucket         = format("tf-state-%s", local.account_id)
    dynamodb_table = format("tf-state-%s", local.account_id)

    skip_metadata_api_check     = true
    skip_credentials_validation = true
    skip_bucket_ssencryption    = false
    skip_bucket_root_access     = true

    s3_bucket_tags = {
      Name        = format("tf-state-%s", local.account_id)
      Environment = "${local.env}"
      Terragrunt  = "true"
    }
  }
}
