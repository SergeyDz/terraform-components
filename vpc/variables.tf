variable "cidr" {
    description = "The CIDR block for the VPC"
    type = string
    
    validation {
        condition = length(var.cidr) > 0
        error_message = "The CIDR block must not be empty"
    }
}