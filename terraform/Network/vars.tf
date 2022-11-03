variable "Network_CIDR" {
    type = string 
}

variable "N_Subnets" {
    type = number
}

variable "Name" {
    type = string
}

/*
 * It is not needed. Passed within default tag from provider
 
variable "Tags" {
    type = map
}
*/
