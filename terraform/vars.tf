variable "aws_region" {
    type = string
    default = "eu-west-2"
}

variable "Network_CIDR" {
    type = string 
}

variable "N_Subnets" {
    type = number
}

variable "Name" {
    type = string
}

variable "Tags" {
    type = map
}