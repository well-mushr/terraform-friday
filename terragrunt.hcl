locals {
  tg_account = read_terragrunt_config(find_in_parent_folders("account.hcl", "${get_terragrunt_dir()}/account.hcl"))
  tg_region = read_terragrunt_config(find_in_parent_folders("region.hcl", "${get_terragrunt_dir()}/region.hcl"))

  account_name = local.tg_account.locals.account_name
  role_arn = local.tg_account.locals.role_arn
  aws_region = local.tg_region.locals.aws_region
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  assume_role {
    role_arn     = "${local.role_arn}"
  }
}
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    encrypt        = true
    bucket         = "asdf-terraform-state-${local.account_name}"
    dynamodb_table = "asdf-terraform-state-${local.account_name}"
    region         = "eu-central-1"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    role_arn       = "${local.role_arn}"
  }
}