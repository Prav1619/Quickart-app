resource "kubernetes_service_account" "lb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "aws-load-balancer-controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.lb_controller.arn
    }
  }
}

resource "kubernetes_deployment" "lb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "aws-load-balancer-controller"
      }
    }

    replicas = 1

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "aws-load-balancer-controller"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.lb_controller.metadata[0].name

        container {
          name  = "controller"
          image = "public.ecr.aws/eks/aws-load-balancer-controller:v2.7.0"

          args = [
            "--cluster-name=${var.cluster_name}",
            "--region=${var.region}",
            "--ingress-class=alb"
          ]
        }
      }
    }
  }
}
