resource "aws_security_group" "s05-cluster" {
  name        = "terraform-eks-s05-cluster"
  description = "Communication avec les  nodes"
  vpc_id      = aws_vpc.s05_principal.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-s05"
  }
}
