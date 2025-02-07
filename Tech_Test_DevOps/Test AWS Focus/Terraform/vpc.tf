module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  tags               = var.tags
}


resource "aws_security_group" "interface_endpoints_sg" {
  vpc_id = module.vpc.vpc_id
  name   = var.endpoints_sg_name

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = module.vpc.vpc_id
  service_name      = var.ec2_service_name # EC2 endpoint
  vpc_endpoint_type = "Interface"

  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.interface_endpoints_sg.id]

  tags = {
    Name = "ec2-endpoint"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = module.vpc.vpc_id
  service_name    = var.s3_service_name # S3 endpoint
  route_table_ids = module.vpc.private_route_table_ids
  tags = {
    Name = "s3-endpoint"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
