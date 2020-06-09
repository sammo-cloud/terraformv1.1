provider "aws" {
  region = "${var.ec2_region}"
}

resource "aws_key_pair" "key_TPOT" {
  key_name   = "TPOT Key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCvxxO1BotTtIhBBiuTbRGGrvwT/jSn3defnK+dqp0wwz92NjoFfXhmg7RgFkBmFlBY+SZRO6yrmgEulvX2FVi2/gUFTnITa7S0n4PfA0uVWV8ZuGcRGBmPtqiOtYg0MhVLRHAKcLuNiE9QCRXOad8jQTiYDMkSvG7ZkrEGknSfKfa0r/bRkiRvtoOhaINUfPecDpb0KA3n47lmSPznfMRKrCxOqjlfgQ8JIbCgYhMQ5zMtQbimNr28yERV8pvL2t9k8NK0haLEToj576Ppa6CIy3soNlyVSx0VPQsPl+XvVWiRa5PJxLY6rWMQx9cyNIXq2UbGdg6ZYPkHKRq//Z1zMu5681PyvVL9yEYxbGSrnX0gbbxsvamOO1N0AcP08WbYoSrLF40OC+Yahy7PekikqSLwuq4oofY6HMTBr1ouf0v47AI/QRfAgfxGGQB3Ty9XEvNReYcdsEgbpeFqgVTxR0NY0qeiDkPYDJHb8WmQwzm2R6FZ+LbbH5luDxrgPyJmmz2zZpkwOwV4wQsDPzNfk02Syp4+p38TCX46Wwj9jgJbd+nROUbY8OYLW5e/NyHm89x1L4dDxvRF78uzSk3SbNsInaOpBIs6xIC6yzxhteAnYOCHli2VPpabxhxijr0vBnHqq4IxAoYGu8EA5fIussCPK4y+T5BRKhQQ16lH7Q== your_email@example.com"
}

resource "aws_security_group" "sg_CPGW" {
  name        = "CPGW"
  description = "T-Pot CPGW" 
  vpc_id      = "${aws_vpc.vpc_TPOT.id}"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "CPGW"
  }
}

resource "aws_security_group" "sg_TPOT" {
  name        = "T-Pot"
  description = "T-Pot Honeypot"
  vpc_id      = "${aws_vpc.vpc_TPOT.id}"
  ingress {
    from_port   = 0
    to_port     = 64000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 64000
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 64294
    to_port     = 64294
    protocol    = "tcp"
    cidr_blocks = "${var.admin_ip}"
  }
  ingress {
    from_port   = 64295
    to_port     = 64295
    protocol    = "tcp"
    cidr_blocks = "${var.admin_ip}"
  }
  ingress {
    from_port   = 64297
    to_port     = 64297
    protocol    = "tcp"
    cidr_blocks = "${var.admin_ip}"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "T-Pot"
  }
}

resource "aws_network_interface" "eni_CPGW_public" {
  subnet_id       = "${aws_subnet.pubsn_CPGW.id}"
  security_groups = ["${aws_security_group.sg_CPGW.id}"]
  source_dest_check = false
  private_ips = ["${var.CPGW_eth0_primary_ip}","${var.CPGW_eth0_secondary_ip}"]

  #attachment {
  #  instance     = "${aws_instance.ins_CPGW.id}"
  #  device_index = 1
  #}
}

resource "aws_network_interface" "eni_CPGW_private" {
  subnet_id       = "${aws_subnet.prisn_CPGW.id}"
  security_groups = ["${aws_security_group.sg_CPGW.id}"]
  source_dest_check = false
  private_ips = ["${var.CPGW_eth1_ip}"]

  #attachment {
  #  instance     = "${aws_instance.ins_CPGW.id}"
  #  device_index = 1
  #}
}

resource "aws_eip" "eip_CPGW_public" {
  vpc                       = true
  network_interface         = "${aws_network_interface.eni_CPGW_public.id}"
  associate_with_private_ip = "${var.CPGW_eth0_primary_ip}"
}

resource "aws_eip" "eip_TPOT_public" {
  vpc                       = true
  network_interface         = "${aws_network_interface.eni_CPGW_public.id}"
  associate_with_private_ip = "${var.CPGW_eth0_secondary_ip}"
}

resource "aws_instance" "ins_CPGW" {
  ami           = "${var.r8040_standalone_ami[var.ec2_region]}"
  instance_type = "${var.cp_instance_type}"
  key_name      = "TPOT Key"
  #subnet_id     = "${aws_subnet.pubsn_CPGW.id}"
  tags = {
    Name = "T-Pot CPGW"
  }
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }
  #vpc_security_group_ids = ["${aws_security_group.sg_CPGW.id}"]
  #associate_public_ip_address = true
  #source_dest_check = false

  network_interface {
    network_interface_id = "${aws_network_interface.eni_CPGW_public.id}"
    device_index         = 0
  }

  network_interface {
    network_interface_id = "${aws_network_interface.eni_CPGW_private.id}"
    device_index         = 1
  }

  user_data = <<-EOF
    #! /bin/bash
    echo template_name: autoscale >> /etc/cloud-version
    echo template_version: 20200203 >> /etc/cloud-version
    echo "set admin password"
    clish -c "set user admin password-hash ${var.pwd_hash}" -s
    clish -c "set user admin shell /bin/bash" -s
    clish -c "set hostname cpgw" -s
    clish -c "set ntp server primary 169.254.169.123 version 4" -s 
    clish -c "set ntp server secondary 0.pool.ntp.org version 4" -s
    clish -c "set static-route ${var.tpot_subnet_cidr} nexthop gateway address 10.254.1.1 on" -s
    enable_cloudwatch=false
    /bin/config_system -s 'install_security_gw=true&mgmt_gui_clients_radio=any&install_security_managment=true&install_mgmt_primary=true&install_mgmt_secondary=false&mgmt_admin_radio=gaia_admin&ftw_sic_key=notused&download_info=true&upload_info=true'
    /sbin/shutdown -r 0
  EOF


  provisioner "local-exec" {
      command = "sleep 900"
  }

  provisioner "remote-exec" {

    connection {
      host        = "${self.public_dns}"
      user        = "admin"
      type        = "ssh"
      private_key = "${file("tpot.pem")}"
      timeout     = "10m"
    }

    inline = [
      "/bin/bash -c 'until mgmt_cli -r true discard ; do sleep 30; done'",
      "mgmt_cli -r true set simple-gateway name 'cpgw' application-control true url-filtering true ips true anti-bot true anti-virus true threat-emulation true interfaces.0.name 'eth0' interfaces.0.ipv4-address '10.254.0.10' interfaces.0.ipv4-mask-length '24' interfaces.0.topology 'EXTERNAL' interfaces.1.name 'eth1' interfaces.1.ipv4-address '10.254.11.10' interfaces.1.ipv4-mask-length '24' interfaces.1.topology 'INTERNAL';",
      "mgmt_cli -r true set access-layer name 'Network' applications-and-url-filtering true data-awareness true --format json;",
      "mgmt_cli -r true set access-rule layer Network rule-number 1 action 'Accept' track.accounting True track.type 'Log';",
      "mgmt_cli -r true add host name 'TPOT' ip-address '10.254.11.10' nat-settings.auto-rule true nat-settings.method 'static' nat-settings.ipv4-address '10.254.0.11' nat-settings.install-on 'All' --format json;",
      "mgmt_cli -r true --format json show generic-objects class-name com.checkpoint.management.access.objects.access.AppCtrlGeneralSettings | jq .objects[].uid | while read U; do mgmt_cli -r true --format json set generic-object uid $U urlfSslCnEnabled true ; done",
      "mgmt_cli -r true install-policy policy-package 'standard' access true threat-prevention false;",
      "mgmt_cli -r true install-policy policy-package 'standard' access true threat-prevention true;"
    ]
  }
}


resource "aws_instance" "ins_TPOT" {
  ami           = "${var.tpot_ami[var.ec2_region]}"
  instance_type = "${var.tpot_instance_type}"
  key_name      = "TPOT Key"
  subnet_id     = "${aws_subnet.prisn_TPOT.id}"
  tags = {
    Name = "T-Pot Honeypot"
  }
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }
  user_data              = "${file("cloud-init-tpot.yaml")}    content: ${base64encode(file("tpot.conf"))}"
  vpc_security_group_ids = ["${aws_security_group.sg_TPOT.id}"]
  associate_public_ip_address = false
  private_ip = "${var.TPOT_eth0_ip}"

  depends_on = [
    aws_instance.ins_CPGW,
  ]
}
