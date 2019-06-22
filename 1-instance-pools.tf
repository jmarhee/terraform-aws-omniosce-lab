module "omni_lab_alpha" {
  source = "./modules/omni_box"

  lab_name      = "${var.lab_name}"
  ami           = "${var.region_ami["${var.region}"]}"
  instance_type = "${var.instance_type}"
  node_count    = "${var.node_count}"
  key_pair_path = "${var.key_pair_path}"
}
