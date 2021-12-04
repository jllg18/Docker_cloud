provider "aws" {
  region = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_vpc" "VotingAPP" {
    cidr_block = "172.1.0.0/16"
  tags = {
    Name = "Docker VPC"
  }
}

resource "aws_security_group" "VotingRGAPP" {
  name = "Docker-votting-RG"
  vpc_id = aws_vpc.VotingAPP.id
  ingress {
    from_port = 0
    protocol  = "All"
    to_port   = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#resource "aws_security_group_rule" "VotingSRGApp1" {
#     description = "Security Group Docker votting 1"
#     from_port = 80
#     protocol = "tcp"
#     security_group_id = aws_security_group.VotingRGAPP.id
#     to_port = 80
#     type = "ingress"
#     cidr_blocks = ["172.1.0.0/16"]
#   }

# resource "aws_security_group_rule" "VotingSRGApp2" {
#   description = "Security Group Docker votting 2"
#   from_port = 22
#   protocol = "tcp"
#   security_group_id = aws_security_group.VotingRGAPP.id
#   to_port = 22
#   type = "ingress"
#   cidr_blocks = ["172.1.0.0/16"]
# }

resource "aws_subnet" "DockerApp" {
    cidr_block = "172.1.0.0/24"
    vpc_id     = aws_vpc.VotingAPP.id
}

resource "tls_private_key" "Dockervot1" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "dockervot" {
  key_name = var.key_name #AWS password to login Ec2
  public_key = tls_private_key.Dockervot1.public_key_openssh
  provisioner "local-exec" {
    command = "echo '${tls_private_key.Dockervot1.private_key_pem}' > ./dockervot.pem"
  }
}

resource "aws_internet_gateway" "DockerVotApp" {
  vpc_id = aws_vpc.VotingAPP.id
  tags = {
    Name = "IG_DockerVotApp"
  }
}

resource "aws_route_table" "route-table-DockerApp" {
  vpc_id = aws_vpc.VotingAPP.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.DockerVotApp.id}"
  }
  tags = {
    Name = "RT-DockerApp"
  }
}

resource "aws_route_table_association" "Subnet-association" {
  subnet_id = "${aws_subnet.DockerApp.id}"
  route_table_id = "${aws_route_table.route-table-DockerApp.id}"
}

resource "aws_instance" "docker-voting" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  security_groups = ["${aws_security_group.VotingRGAPP.id}"]
  subnet_id = aws_subnet.DockerApp.id
  associate_public_ip_address = "true"
  user_data = <<-docker
            #!/bin/bash
            sudo systemctl start docker
            sudo docker swarm init
            sudo docker network create -d overlay frontend
            sudo docker network create -d overlay backend
            sudo docker service create --name vote -p 80:80 --network frontend --replicas 2 jllg18/dockerjllg18/vottingapp
  docker
tags = {
    name = "${var.nameapp1}"
    Env = "${var.Env}"
  }
}
