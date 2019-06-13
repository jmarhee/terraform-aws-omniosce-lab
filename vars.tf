variable "ami" {
  description = "Which OmniOS AMI"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Instance size"
}

variable "node_count" {
  default     = "1"
  description = "Number of nodes in a lab pool"
}
