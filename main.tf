provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "acloudguru"
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "${var.env_prefix}-vpc",
  }
}

resource "aws_subnet" "Public-subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_block1
  availability_zone = var.az
  tags = {
    Name : "${var.env_prefix}-Public-subnet-1"
  }
}

resource "aws_subnet" "Public-subnet-2" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block2
  availability_zone = var.az
  tags = {
    Name : "${var.env_prefix}-Public-subnet-2"
  }
}

resource "aws_instance" "ec2_apache" {
  ami           = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type

  subnet_id              = aws_subnet.Public-subnet-1.id
  vpc_security_group_ids = [aws_default_security_group.default-sg.id]
  availability_zone      = var.az

  associate_public_ip_address = true
  key_name                    = teste.pub

  user_data = file("install_apache.sh")
  tags = {
    Name = "${var.env_prefix}-apache-server"
  }

}

output "ec2_ip" {
  value = "Este é o IP da EC2, verifique se o apache esta instalado IP: '${aws_instance.ec2_apache.public_ip}'"
}