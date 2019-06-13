module "omni_lab_alpha" {
  source = "./modules/omni_box"

  lab_name        = "primary"
  ami             = "${var.ami}"
  instance_type   = "${var.instance_type}"
  node_count      = "${var.node_count}"
  public_key_path = "${var.public_key_path}"
}
