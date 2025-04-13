variable "vpc_cidr_blocks" {
    description = "cidr blocks for VPC"
    type = string
    default = "10.100.0.0/16"
}

variable "subnet1_cidr_blocks" {
    description = "cidr blocks for subnet1"
    type = string
    default = "10.100.10.0/24"
}

variable "subnet2_cidr_blocks" {
    description = "cidr blocks for subnet2"
    type = string
    default = "10.100.20.0/24"
}

variable "subnet1_availbility_zone" {
    description = "AZ for subnet1"
    type = string
    default = "ap-south-1a"
  
}

variable "subnet2_availbility_zone" {
    description = "AZ for subnet2"
    type = string
    default = "ap-south-1b"
  
}

variable "engine" {
   description = "RDS engine mysql , postgresql "
   type = string
   default = "postgresql"
}

variable "engine_version" {
  description = "Database versions"
  type = string
}

variable "instance_class" {
    description = "RDS instance class like db.t3.micro"
    type = string
    default = "db.t3.micro"
}

variable "master_username" {
    description = "RDS Database master username"
    type = string
    default = "postgres"
  
}

variable "master_password" {
     description = "RDS Database master user password"
     type = string
     default = "Rdsmaster2025"
}

variable "parameter_group_name" {
    description = "RDS Database parameter group name"
    type = string
    default = "default"
}
