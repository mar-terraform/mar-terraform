variable "ec2_ami" {
  default = "ami-066784287e358dad1"
}

variable "ec2_type" {
  description = "ec2 vm type:"
}

variable "ec2_sg" {
  description = "ec2 sg:"
}

variable "ec2_subnet" {
    description = "ec2 subnet:"
}

resource "aws_instance" "mar_web" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_type
  subnet_id              = var.ec2_subnet
  vpc_security_group_ids = [var.ec2_sg]

  tags = {
    Name = "mar_web_${terraform.workspace}"
  }
}

output "ec2name" {
  value = aws_instance.mar_web.tags.Name
}

output "ec2private" {
  value = aws_instance.mar_web.private_ip
}

output "ec2public" {
  value = aws_instance.mar_web.public_ip
}