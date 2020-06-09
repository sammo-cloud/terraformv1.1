provider "aws" {
  region = "${var.ec2_region}"
}

resource "aws_key_pair" "key-TPOT" {
  key_name   = "TPOT Key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCvxxO1BotTtIhBBiuTbRGGrvwT/jSn3defnK+dqp0wwz92NjoFfXhmg7RgFkBmFlBY+SZRO6yrmgEulvX2FVi2/gUFTnITa7S0n4PfA0uVWV8ZuGcRGBmPtqiOtYg0MhVLRHAKcLuNiE9QCRXOad8jQTiYDMkSvG7ZkrEGknSfKfa0r/bRkiRvtoOhaINUfPecDpb0KA3n47lmSPznfMRKrCxOqjlfgQ8JIbCgYhMQ5zMtQbimNr28yERV8pvL2t9k8NK0haLEToj576Ppa6CIy3soNlyVSx0VPQsPl+XvVWiRa5PJxLY6rWMQx9cyNIXq2UbGdg6ZYPkHKRq//Z1zMu5681PyvVL9yEYxbGSrnX0gbbxsvamOO1N0AcP08WbYoSrLF40OC+Yahy7PekikqSLwuq4oofY6HMTBr1ouf0v47AI/QRfAgfxGGQB3Ty9XEvNReYcdsEgbpeFqgVTxR0NY0qeiDkPYDJHb8WmQwzm2R6FZ+LbbH5luDxrgPyJmmz2zZpkwOwV4wQsDPzNfk02Syp4+p38TCX46Wwj9jgJbd+nROUbY8OYLW5e/NyHm89x1L4dDxvRF78uzSk3SbNsInaOpBIs6xIC6yzxhteAnYOCHli2VPpabxhxijr0vBnHqq4IxAoYGu8EA5fIussCPK4y+T5BRKhQQ16lH7Q== your_email@example.com"
}

resource "aws_security_group" "tpot" {
  name        = "T-Pot"
  description = "T-Pot Honeypot"
  vpc_id      = "${aws_vpc.vpc-TPOT.id}"
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

resource "aws_instance" "tpot" {
  ami           = "${var.ec2_ami[var.ec2_region]}"
  instance_type = "${var.ec2_instance_type}"
  key_name      = "TPOT Key"
  subnet_id     = "${aws_subnet.pubsn-TPOT.id}"
  tags = {
    Name = "T-Pot Honeypot"
  }
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }
  user_data              = "${file("cloud-init.yaml")}    content: ${base64encode(file("tpot.conf"))}"
  vpc_security_group_ids = ["${aws_security_group.tpot.id}"]
  associate_public_ip_address = true
}
