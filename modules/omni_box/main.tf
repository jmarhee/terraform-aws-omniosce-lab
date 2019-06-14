variable "lab_name" {}
variable "ami" {}
variable "instance_type" {}
variable "node_count" {}
variable "public_key_path" {}

resource "aws_key_pair" "lab" {
  key_name   = "lab-key"
  public_key = "${file("${var.public_key_path}")}"
}

resource "aws_instance" "omni_box" {
  ami           = "${var.ami}"
  key_name      = "${aws_key_pair.lab.key_name}"
  instance_type = "${var.instance_type}"
  count         = "${var.node_count}"
  tags = {
    Name = "${format("omni-${var.lab_name}-%02d", count.index)}"
  }
}

output "instances" {
  description = "AWS Instances created in lab"
  value       = "${join("\t\n", aws_instance.omni_box.*.public_dns)}"
}
