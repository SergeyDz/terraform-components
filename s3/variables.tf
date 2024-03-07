variable "name" {
    default = "s3"
    description = "The name of the VPC"
    type = string
}

variable "bucket_name_prefix" {
    description = "The prefix of the S3 bucket"
    type = string
    default = "dzyuban"
}

variable "acl" {
    description = "The canned ACL to apply"
    type = string
    default = "private"
  
}