variable "Network" {
  type = map
}

variable "Image" {
    type = string
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