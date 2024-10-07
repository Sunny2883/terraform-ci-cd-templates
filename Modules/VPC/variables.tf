variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "create_public_subnet" {
  description = "Set to true to create public subnets"
  type        = bool
  default     = true
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"] # Add more CIDR blocks as needed
}

variable "availability_zones" {
  description = "List of availability zones for public subnets"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"] # Adjust according to your region
}

variable "create_private_subnet" {
  description = "Set to true to create private subnets"
  type        = bool
  default     = true
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"] # Add more CIDR blocks as needed
}

variable "create_private_with_internet_access" {
  description = "Set to true to create private subnets with internet access (NAT Gateway)"
  type        = bool
  default     = false
}