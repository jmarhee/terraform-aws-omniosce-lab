OmniOS Lab on AWS
===

Terraform project to spin up pod of OmniOS boxes.

Setup
---

Set the path to your SSH public key in the `public_key_path` variable. This will be used to create a new keypair in AWS.

Usage
---

To define a pod, in `1-instance-pools.tf`, create a new instance of the `omni_box` module:

```
module "omni_lab_beta" {
  source = "./modules/omni_box"

  lab_name        = "secondary"
  ami             = "${var.region_ami["${var.region}"]}"
  instance_type   = "${var.instance_type}"
  node_count      = "${var.node_count}"
  public_key_path = "${var.public_key_path}"
}
```

You can, optionally, use the `node_count` variable to specify the size of your standard pool of nodes in this lab. 

Set your preferred region in your tfvars, this will automatically select the region-specific AMI. Once defined, target the new module:

```
terraform apply -target=module.omni_lab_beta
```

this will apply `count` number of nodes, a new security group, an SSH key in the selected region.
