provider "aws" {
  region = var.region
}

locals {
  name   = format("%s-%s-%s-%s", var.instance, var.stage, var.tenant, var.name)
  path   = format("%s/%s-%s-%s-%s", var.region, var.instance, var.stage, var.tenant, var.name)

  bucket_name = format("%s-%s-%s-%s-%s", var.instance, var.stage, var.tenant, var.name, var.bucket_name)

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

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = var.acl

  tags = local.tags
}

