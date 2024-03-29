variable "name" {
    default = "vpc"
    description = "The name of the VPC"
    type = string
}

variable "cidr" {
    description = "The CIDR block for the VPC"
    type = string
    
    validation {
        condition = length(var.cidr) > 0
        error_message = "The CIDR block must not be empty"
    }
}

variable "enable_nat_gateway" {
    description = "Should be true if you want to provision NAT Gateways for each of your private networks"
    type = string
    default     = true
}

variable "single_nat_gateway" {
    description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
    type = bool
    default  = false
}

variable "max_subnet_count" {
    description = "The maximum number of subnets to create"
    type = string
    default     = 3
  
}