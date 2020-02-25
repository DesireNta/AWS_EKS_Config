variable "s05_ntambiye" {
  default = "s05_ntambiye"
  type    = string
}

resource "aws_eks_cluster" "s05_ntambiye_eks" {
  name            = var.s05_ntambiye
  role_arn        = aws_iam_role.s05-node.arn

  vpc_config {
    security_group_ids = [aws_security_group.s05-cluster.id]
    subnet_ids         = [aws_subnet.s05_subnet[0].id, aws_subnet.s05_subnet[1].id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.s05-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.s05-cluster-AmazonEKSServicePolicy,
  ]
}
