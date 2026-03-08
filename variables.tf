variable "aws_region" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "security_group_name" {
  type = string
}

variable "ingress_rules" {
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr      = string
  }))
}