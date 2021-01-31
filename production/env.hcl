locals {
  aws_account_id = get_env("TERRAGRUNT_AWS_ACCOUNT_ID", "")
  aws_profile    = "default"
  environment    = "production"
}
