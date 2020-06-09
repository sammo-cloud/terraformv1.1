# Deploy CP Geo Cluster for TGW cloudformation template
# https://sc1.checkpoint.com/documents/IaaS/WebAdminGuides/EN/CP_CloudGuard_for_AWS_Transit_Gateway_High_Availability/Content/Topics/Terms.htm?tocpath=_____4
resource "aws_cloudformation_stack" "checkpoint_gc_cloudformation_stack" {
  name = "${var.project_name}-Geocluster"

  parameters = {
    VPC                     = "${aws_vpc.vpc_gc.id}"
    License                 = "${var.cpversion}-BYOL"
    InstanceType            = "${var.geocluster_gateway_size}"
    KeyName                 = "${var.key_name}"
    PasswordHash            = "${var.password_hash}"
    Shell                   = "/bin/bash"
    NamePrefix	            = var.project_name
    PrivateSubnetA	    = aws_subnet.sn_gc_private_a.id
    PrivateSubnetB	    = aws_subnet.sn_gc_private_b.id
    PublicSubnetA	    = aws_subnet.sn_gc_public_a.id
    PublicSubnetB	    = aws_subnet.sn_gc_public_b.id
    TgwHASubnetA	    = aws_subnet.sn_gc_tgwha_a.id
    TgwHASubnetB	    = aws_subnet.sn_gc_tgwha_b.id
    SICKey	            = var.sickey
}

  template_url        = "https://s3.amazonaws.com/CloudFormationTemplate/checkpoint-tgw-ha.yaml"
  capabilities        = ["CAPABILITY_IAM"]
  disable_rollback    = true
  timeout_in_minutes  = 50
}

# Deploy CP Management cloudformation template - sk130372
resource "aws_cloudformation_stack" "checkpoint_Management_cloudformation_stack" {
  name = "${var.project_name}-Management"

  parameters = {
    VPC                     = "${aws_vpc.vpc_gc.id}"
    Subnet                  = "${aws_subnet.sn_gc_mgmt.id}" 
    Version                 = "${var.cpversion}-BYOL"
    InstanceType            = "${var.management_server_size}"
    Name                    = "${var.project_name}-Management" 
    KeyName                 = "${var.key_name}"
    PasswordHash            = "${var.password_hash}"
    Shell                   = "/bin/bash"
    Permissions             = "Create with read-write permissions"
}

  template_url        = "https://s3.amazonaws.com/CloudFormationTemplate/management.json"
  capabilities        = ["CAPABILITY_IAM"]
  disable_rollback    = true
  timeout_in_minutes  = 50
  depends_on = [
    aws_cloudformation_stack.checkpoint_gc_cloudformation_stack,
  ]
}

#resource "null_resource" "cluster" {
#  # Changes to any instance of the cluster requires re-provisioning
#  triggers = {
#    cluster_instance_ids = "${join(",", aws_instance.cluster.*.id)}"
#  }
#
#  # Bootstrap script can run on any instance of the cluster
#  # So we just choose the first in this case
#  connection {
#    host = "${element(aws_instance.cluster.*.public_ip, 0)}"
#  }
#
#  provisioner "remote-exec" {
#    # Bootstrap script called with private_ip of each node in the cluster
#    inline = [
#      "bootstrap-cluster.sh ${join(" ", aws_instance.cluster.*.private_ip)}",
#    ]
#  }
#}
