resource "aws_security_group" "s05-node" {
  name        = "terraform-eks-s05-node"
  description = "Security group de tous les nodes de mon cluster"
  vpc_id      = aws_vpc.s05_principal.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"  = "terraform-eks-demo-node"
    "kubernetes.io/cluster/${var.s05_ntambiye}" = "owned"
  }
}

resource "aws_security_group_rule" "s05-node-ingress-self" {
  description              = "Allow node to communicate with each other/ tous les nodes communiquent"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.s05-node.id
  source_security_group_id = aws_security_group.s05-node.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "s05-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.s05-node.id
  source_security_group_id = aws_security_group.s05-cluster.id
  to_port                  = 65535
  type                     = "ingress"
 }

resource "aws_security_group_rule" "s05-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.s05-cluster.id
  source_security_group_id = aws_security_group.s05-node.id
  to_port                  = 443
  type                     = "ingress"
}
