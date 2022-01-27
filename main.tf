provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "acloud_guru"
}

resource "aws_key_pair" "keypair" {
  key_name   = "teste"
  public_key = var.public_key
}

resource "aws_instance" "ec2_apache" {
  ami           = var.ami
  instance_type = var.instance_type
  availability_zone = var.az
  associate_public_ip_address = true
  key_name                    = aws_key_pair.keypair.id
  user_data = file("install_apache.sh")
  tags = {
    Name = "${var.env_prefix}-apache-server"
  }

}

output "ec2_ip" {
  value = "Este é o IP da EC2, verifique se o apache esta instalado IP: '${aws_instance.ec2_apache.public_ip}'"
}