variable "ec2_key_pair" {
  type        = string
}

variable "debug" {
  type        = bool
  default     = false
}

variable "region" {
  type        = string
  default     = "ap-southeast-2"
}