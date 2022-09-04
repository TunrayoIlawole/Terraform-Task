variable "ami" {
  type    = string
  default = "ami-02d1e544b84bf7502"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "aws_access_key" {
  type    = string
  default = "*******************"
}

variable "aws_secret_key" {
  type    = string
  default = "**************************************"
}

variable "aws_region" {
  type    = string
  default = "us-east-2"
}