provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = format("%s-%s-%s-%s", var.instance, var.stage, var.tenant, var.name)
  path   = format("%s/%s-%s-%s-%s", var.region, var.instance, var.stage, var.tenant, var.name)
  azs      = slice(data.aws_availability_zones.available.names, 0,  try(tonumber(var.max_subnet_count), 3))

  tags = {
    Owner  = "SergeyDz"
    GithubRepo = "https://github.com/SergeyDz/terraform-components"
    TF = local.name
    Instance = var.instance
    Stage = var.stage
    Tenant = var.tenant
    CreatedBy = "Terraform"
    CreatedeAt = timestamp()
  }
}

################################################################################
# Main Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = var.cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(var.cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k + 48)]

  enable_nat_gateway = var.enable_nat_gateway == "true" ? true : false 

  single_nat_gateway = var.single_nat_gateway

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}

