variable "cluster_name" {
  type = string
}

variable "family_name" {
  type = string
}

variable "container_name" {
  type = string
}

variable "memory" {
  type = string
}

variable "cpu" {
  type = string
}

variable "image_url" {
  type = string
}
variable "execution_role_arn" {
  type = string
}
variable "task_role_arn" {
  type = string
}


variable "auto_scaling_group_arn" {
  type = string
}

variable "use_fargate" {
  description = "Set to true to use Fargate launch type"
  type        = bool
  default     = false
}