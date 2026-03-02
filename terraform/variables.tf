variable "region" {
  description = "AWS region to deploy EKS"
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  default     = "quickart-eks"
}
