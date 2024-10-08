terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-2"
}



resource "aws_security_group" "sg_frontend" {


  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_instance" "frontend_a" {
  ami                    = var.frontend_a_ami
  instance_type          = var.frontend_a_instance_type
  key_name               = var.frontend_a_key_name
  subnet_id              = var.frontend_a_subnet_id
  user_data              = file("./frontend_install.sh")
  vpc_security_group_ids = [aws_security_group.sg_frontend.id]

  tags = {
    Name = "frontend_a"
  }
}

resource "aws_instance" "frontend_b" {
  ami                    = var.frontend_b_ami
  instance_type          = var.frontend_b_instance_type
  key_name               = var.frontend_b_key_name
  subnet_id              = var.frontend_b_subnet_id
  user_data              = file("./frontend_install.sh")
  vpc_security_group_ids = [aws_security_group.sg_frontend.id]

  tags = {
    Name = "frontend_b"
  }
}

resource "aws_security_group" "sg_backend" {


  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_instance" "backend_a" {
  ami                    = var.backend_a_ami
  instance_type          = var.backend_a_instance_type
  key_name               = var.backend_a_key_name
  subnet_id              = var.backend_a_subnet_id
  user_data              = file("./backend_install.sh")
  vpc_security_group_ids = [aws_security_group.sg_backend.id]

  tags = {
    Name = "backend_a"
  }
}

resource "aws_instance" "backend_b" {
  ami                    = var.backend_b_ami
  instance_type          = var.backend_b_instance_type
  key_name               = var.backend_b_key_name
  subnet_id              = var.backend_b_subnet_id
  user_data              = file("./backend_install.sh")
  vpc_security_group_ids = [aws_security_group.sg_backend.id]

  tags = {
    Name = "backend_b"
  }
}

resource "aws_security_group" "sg_database" {


  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "database_a" {
  ami                    = var.database_a_ami
  instance_type          = var.database_a_instance_type
  key_name               = var.database_a_key_name
  subnet_id              = var.database_a_subnet_id
  vpc_security_group_ids = [aws_security_group.sg_database.id]

  tags = {
    Name = "database_a"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [var.database_b_subnet_id, var.database_a_subnet_id] 

  tags = {
    Name = "my-db-subnet-group"
  }
}


resource "aws_db_instance" "database_b" {
  allocated_storage      = 10
  db_name                = "databaseb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "databaseb"
  password               = var.database_b_password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  availability_zone      = "eu-west-2b"
  vpc_security_group_ids = [aws_security_group.sg_database.id]

}

