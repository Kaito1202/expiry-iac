output "cluster_name" {
  description = "EKSクラスタ名"
  value       = module.eks.cluster_name
}

output "kubeconfig" {
  description = "kubectl用の設定コマンド"
  value       = "aws eks --region ${var.aws_region} update-kubeconfig --name ${module.eks.cluster_name}"
}
