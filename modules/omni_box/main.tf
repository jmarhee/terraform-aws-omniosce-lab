variable "lab_name" {}
variable "ami" {}
variable "instance_type" {}
variable "node_count" {}
variable "public_key_path" {}

resource "aws_key_pair" "lab" {
  key_name   = "lab-key"
  public_key = "${file("${var.public_key_path}")}"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "omni_box" {
  ami             = "${var.ami}"
  key_name        = "${aws_key_pair.lab.key_name}"
  instance_type   = "${var.instance_type}"
  count           = "${var.node_count}"
  security_groups = ["${aws_security_group.allow_ssh.name}"]
  tags = {
    Name = "${format("omni-${var.lab_name}-%02d", count.index)}"
  }
}


