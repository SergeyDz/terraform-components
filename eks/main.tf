provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

data "aws_vpcs" "vpc" {
  tags = {
    TF = format("%s-%s-%s-%s", var.instance, var.stage, var.tenant, "vpc")
  }
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [length(data.aws_vpcs.vpc.ids) > 0 ? data.aws_vpcs.vpc.ids[0] : null]
  }
}

data "aws_subnet" "eks_subnets" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id       = each.value
}

locals {
  name   = format("%s-%s-%s-%s", var.instance, var.stage, var.tenant, var.name)
  path   = format("%s/%s-%s-%s-%s", var.region, var.instance, var.stage, var.tenant, var.name)
  vpc_id = length(data.aws_vpcs.vpc.ids) > 0 ? data.aws_vpcs.vpc.ids[0] : null

  cluster_version = var.eks_version

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
# Cluster
################################################################################

#tfsec:ignore:aws-eks-enable-control-plane-logging
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.9"

  cluster_name                   = local.name
  cluster_version                = local.cluster_version
  cluster_endpoint_public_access = true

  vpc_id     = local.vpc_id
  subnet_ids = data.aws_subnets.subnets.ids

  eks_managed_node_groups = {
    initial = {
      instance_types = ["m5.large"]

      min_size     = 1
      max_size     = 1
      desired_size = 1
    }
  }
}
