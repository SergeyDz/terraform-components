provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = format("%s-%s-%s-%s", var.instance, var.stage, var.tenant, basename(path.cwd))
  path   = format("%s/%s-%s-%s-%s", var.region, var.instance, var.stage, var.tenant, basename(path.cwd))
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Owner  = "SergeyDz"
    GithubRepo = "https://github.com/SergeyDz/terraform-components"
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

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}

