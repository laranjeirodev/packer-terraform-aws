variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "Network_CIDR" {
  type = string
}

variable "N_Subnets" {
  type = number

  validation {
    condition = (
      var.N_Subnets < 6 && var.N_Subnets > 2
    )
    error_message = "The N_Subnet value must be less or equal then 6 and more or equal than 2"
  }
}

variable "Name" {
  type = string
}

variable "Tags" {
  type = map(any)
}