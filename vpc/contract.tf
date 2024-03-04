################################################################################
# Contract
################################################################################

variable "instance" {
    description = "Kyriba instance name"
    type = string
}

variable "stage" {
    description = "The stage of the deployment"
    type = string
    default     = "dev"
}

variable "region" {
    description = "The AWS region to deploy into"
    type = string
    default     = "us-west-2"
}

variable "tenant" {
    description = "The tenant name"
    type = string
    default     = "kip1"
}