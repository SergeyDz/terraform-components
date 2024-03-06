variable "name" {
    default = "eks"
    description = "The name of the EKS cluster"
    type = string
}

variable "eks_version" {
  description = "The version of the EKS cluster"
  type = string
  default = "1.25"
}