provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Mainsub1"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "routemain"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.r.id
}

resource "aws_security_group" "SGsub1" {
  vpc_id = aws_vpc.main.id
  name   = "SGsub1"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "nec" {
  subnet_id       = aws_subnet.sub1.id
  private_ips     = ["10.0.0.50"]
  security_groups = [aws_security_group.SGsub1.id]
}

resource "aws_eip" "eip_sub2" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.nec.id
  associate_with_private_ip = "10.0.0.50"

  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name = "eipsub2"
  }
}

resource "aws_instance" "ec2" {
  ami               = "ami-0885b1f6bd170450c"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.nec.id
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apache2
              sudo systemctl start apache2
              sudo systemctl enable apache2
              echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
            EOF

  tags = {
    Name = "web-server"
  }
}
