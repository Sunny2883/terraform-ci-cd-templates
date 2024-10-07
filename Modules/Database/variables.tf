variable "allocated_storage" {
  description = "The allocated storage size for the RDS instance in GB."
  type        = number
  default     = 20  # You can change the default value
}

variable "engine" {
  description = "The database engine to use."
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "The version of the database engine."
  type        = string
  default     = "13.3"
}

variable "username" {
  description = "Master username for the database."
  type        = string
}



variable "db_name" {
  description = "Name of the database to create."
  type        = string
  default     = "mydatabase"
}


variable "vpc_security_group_ids" {
  description = "A list of VPC security group IDs to assign to the RDS instance."
  type        = list(string)
}

variable "instance_class" {
  type = string
}
variable "identifier" {
  type = string
}

variable "is_public" {
  description = "Set to true if the database should be created in the public subnet"
  type        = bool
  default     = false
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "private_internet_subnet_ids" {
  description = "List of private subnet IDs with internet access"
  type        = list(string)
}

variable "use_private_internet_access" {
  description = "Set to true to use private subnet with internet access if is_public is false"
  type        = bool
  default     = false
}


