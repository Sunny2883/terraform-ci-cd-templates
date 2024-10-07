variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "use_fargate" {
  type = bool
}
 variable "vpc_id" {
   type = string
 }