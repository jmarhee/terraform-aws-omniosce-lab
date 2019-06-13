variable "lab_name" {}
variable "ami" {}
variable "instance_type" {}
variable "node_count" {}

resource "aws_instance" "omni_box" {
	ami = "${var.ami}"
	instance_type = "${var.instance_type}"
	count = "${var.node_count}"
	tags = {
		Name = "${format("omni-${var.lab_name}-%02d", count.index)}"
	}
}
