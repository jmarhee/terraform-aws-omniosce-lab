output "agent-ip" {
  value = "${join(",", aws_instance.omni_box.*.public_ip)}"
}
