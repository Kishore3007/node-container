provider "aws" {
  region = "ap-south-1"  
}

resource "aws_instance" "node_app_instance" {
  ami           = "ami-0327f51db613d7bd2"  
  instance_type = "t2.micro"                
  key_name      = "docker"                  

  security_groups = ["allow_http", "allow_ssh"]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y docker
              sudo service docker start
              sudo usermod -aG docker ec2-user
              sudo systemctl enable docker
              echo "dckr_pat_XKpHc1rGymzRMlq5jkNLwoWPJEc" | docker login --username kishore307 --password-stdin
              docker pull kishore307/node-app
              docker run -d -p 3000:3000 kishore307/node-app
              EOF

  tags = {
    Name = "NodeDockerApp"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  
  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  
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
