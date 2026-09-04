variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-01a00762f46d584a1"
}

variable "instance_type" {
  description = "The instance type to use for the EC2 instance"
  type        = string
  default     = "t3.micro"
}
variable "key_name" {
  description = "The name of the key pair to use for the EC2 instance"
  type        = string
  default     = "med-erp-key"
}

variable "volume_size" {
  description = "The size of the root volume in GB"
  type        = number
  default     = 8
}
variable "volume_type" {
  description = "The type of the root volume"
  type        = string
  default     = "gp2"
}