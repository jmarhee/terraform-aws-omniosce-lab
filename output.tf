output "instances" {
  description = "AWS Instances created in lab"
  value       = "\n\t\n\tssh root@${join("\n\t\n\tssh root@", aws_instance.omni_box.*.public_dns)}"
}
