provider "aws" {
  region = "us-east-1"
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "ebs_csi_driver_controller" {
  source = "../.."

  oidc_url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}