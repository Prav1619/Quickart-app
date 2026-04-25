provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../modules/vpc"

  cidr_block = "10.0.0.0/16"
  environment = var.environment

  azs             = ["ap-south-1a", "ap-south-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "eks" {
  source = "../../modules/eks"

  cluster_name = "dev-eks"
  subnet_ids   = module.vpc.private_subnet_ids
}

module "s3" {
  source = "../../modules/s3"

  bucket_name = "dev-app-bucket-unique-123"
}
