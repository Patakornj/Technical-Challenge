variable "vpc_name" {
  type    = string
  default = "unit-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnets" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "tags" {
  type = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "s3_service_name" {
  type    = string
  default = "com.amazonaws.us-east-1.s3"
}

variable "ec2_service_name" {
  type    = string
  default = "com.amazonaws.us-east-1.ec2"
}

variable "cluster_name" {
  type    = string
  default = "unit-eks-cluster"
}

variable "endpoints_sg_name" {
  type    = string
  default = "interface-endpoints-sg"

}

variable "s3_bucket_name" {
  type    = string
  default = "unit-s3-bucket"

}

variable "rds_db_username" {
  type        = string
  sensitive = true 
}

variable "rds_db_password" {
  type        = string
  sensitive = true 
}