locals {
  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.s05_ntambiye_eks.endpoint}
    certificate-authority-data: ${aws_eks_cluster.s05_ntambiye_eks.certificate_authority.0.data}
  name: s05_ntambiye
contexts:
- context:
    cluster: s05_ntambiye
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.s05_ntambiye}"
KUBECONFIG
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}

# CONFIGURATION POUR POUVOIR JOINDRE LES NODES 

locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-ntambiye
  namespace: default
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.s05-node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

}

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

locals {
  eks-node-private-userdata = <<USERDATA
#!/bin/bash -xe
sudo /etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.s05_ntambiye_eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.s05_ntambiye_eks.certificate_authority.0.data}' '${var.s05_ntambiye}'
USERDATA
}

