resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "unitdb-subnet"
  subnet_ids = module.vpc.private_subnets 

  tags = {
    Name = "unitdb-subnet"
  }
}

resource "aws_db_instance" "mydb" {
  engine            = "postgres" 
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = "unitdb"
  username          = var.rds_db_username
  password          = var.rds_db_password
  skip_final_snapshot = true 

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  multi_az              = false
  publicly_accessible   = false

  tags = {
    Name = "unitdb-instance"
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id = module.vpc.vpc_id
  name   = "rds_sg"

  ingress {
    from_port   = 5432 
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "rds_endpoint" {
  value = aws_db_instance.mydb.endpoint
}
