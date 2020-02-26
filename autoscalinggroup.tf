# Chercher un aws_ami

data "aws_ami" "eks-worker" {
   filter {
     name   = "name"
     values = ["amazon-eks-node-${aws_eks_cluster.s05_ntambiye_eks.version}-v*"]
   }

   most_recent = true
   owners      = ["602401143452"] 
 }

# Etre sûr de la region ou on n'est 
data "aws_region" "current" {
}

#Configuration local

locals {
  s05-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.s05_ntambiye_eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.s05_ntambiye_eks.certificate_authority[0].data}' '${var.s05_ntambiye}'
USERDATA

}

resource "aws_launch_configuration" "s05_launch_config" {
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.profile.name
  image_id = data.aws_ami.eks-worker.id
  instance_type = "t2.micro"
  name_prefix  = "terraform-eks-s05_ntambiye"
  security_groups = [aws_security_group.s05-node.id]
  user_data_base64 = base64encode(local.s05-node-userdata)
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "s05_autoscaling_group" {
  desired_capacity     = 0
  launch_configuration = aws_launch_configuration.s05_launch_config.id
  max_size             = 4
  min_size             = 0
  name                 = "terraform-eks-s05_ntambiye"
  vpc_zone_identifier = [aws_subnet.s05_subnet[0].id,aws_subnet.s05_subnet[1].id]

  tag {
    key                 = "Name"
    value               = "terraform-eks-s05_ntambiye"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.s05_ntambiye}"
    value               = "owned"
    propagate_at_launch = true
  }
}
