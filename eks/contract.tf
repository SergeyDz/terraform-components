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
}

variable "region" {
    description = "The AWS region to deploy into"
    type = string
}

variable "tenant" {
    description = "The tenant name"
    type = string
}