output "instances" {
  description = "AWS Instances created in lab"
  value       = "${join("\t\n", aws_instance.omni_box.*.public_dns)}"
}