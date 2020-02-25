resource "aws_iam_instance_profile" "profile" {
  name = "test_profile"
  role = aws_iam_role.s05-node.name
}

resource "aws_iam_role" "s05-node" {
  name = "terraform-eks-s05-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "s05-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.s05-node.name
}

resource "aws_iam_role_policy_attachment" "s05-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.s05-node.name
}
