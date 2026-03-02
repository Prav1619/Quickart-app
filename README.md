# Quickart-app
This project demonstrates how to design, build, and operate a production-grade microservices platform on AWS using industry-standard DevOps tools and practices.
Even though the underlying application is simple (three Java APIs that return text responses), the DevOps architecture built around it is equivalent to what real companies use to deploy and manage their applications in production.
The focus of this project is not on the application logic, but on proving real-world capabilities in:

Cloud infrastructure provisioning
Containerization
Kubernetes orchestration
CI/CD automation
Rolling deployments and rollbacks
Managing configurations and secrets
Networking, ingress, and routing
Automated, repeatable infrastructure and deployment pipelines

This project is intentionally designed to showcase end-to-end DevOps ownership — from provisioning AWS infrastructure using Terraform, to deploying microservices onto Amazon EKS, to running automated CI/CD pipelines in Jenkins.

Why This Project Matters:
Modern organizations rely heavily on microservice architectures, Kubernetes, container registries, and cloud-native ecosystems.

A DevOps engineer is responsible for:
Building the cloud infrastructure
Deploying microservices consistently and safely
Automating every build, deploy, and update
Ensuring zero-downtime during releases
Handling identity, scaling, networking, and observability
This project demonstrates all of those responsibilities.
By working through this system end-to-end, I am showcasing my ability to think and operate like a real DevOps engineer in a production environment — not just run local scripts or build a Dockerfile.

What This Project Demonstrates
1. Real Cloud Infrastructure (Infrastructure-as-Code)

All cloud resources are created through Terraform, including:
A dedicated, production-style VPC
Private subnets for worker nodes
Public subnets for load balancers
Amazon EKS cluster
Auto-scaling node groups
IAM roles and security integrations (IRSA)
AWS Load Balancer Controller installation
Everything is version-controlled, reproducible, and fully automated.
This eliminates manual AWS configuration and demonstrates IaC best practices.

2. Containerized Microservices

Each of the three services — User, Product, and Order — is packaged as a Docker image and stored in Docker Hub.
The CI/CD pipeline automatically tags each build using the Jenkins $BUILD_NUMBER, ensuring:
Every release is uniquely identifiable
Full traceability across environments
Simple and reliable rollback options
This mimics real container lifecycle management in companies.

3. Kubernetes Deployment on EKS

The services are deployed into an Amazon EKS cluster using well-structured Kubernetes manifests.
This includes:
Deployments with rolling updates
ClusterIP services
Namespace isolation
Liveness & readiness probes
ConfigMaps
Secrets
AWS ALB Ingress for routing
These configurations show a deep understanding of Kubernetes fundamentals and production-grade resource handling.

4. Zero-Downtime Releases (Rolling Updates)
The deployment strategy ensures:
No service downtime
Old pods remain active until new pods become healthy
Automated rollback using:
kubectl rollout undo deployment/<service>
This demonstrates safe, controlled deployments — a core responsibility of DevOps teams.

5. CI/CD Pipeline That Automates Everything
The Jenkins pipeline performs the entire workflow automatically:
Checkout latest code
Build Java services
Build Docker images
Push images to Docker Hub
Run Terraform plan & apply
Patch Kubernetes deployments with the new image tag
Verify rollout
This pipeline represents a complete production deployment system.
It ensures consistency, repeatability, and reliability for each release.

6. Clean Separation of Concerns
Terraform handles infrastructure
Kubernetes manifests handle application deployment
Shell scripts handle automation
Jenkins controls workflow orchestration
This structure matches real DevOps environments in modern engineering teams.

7. No Database Required (Intentional)
The application intentionally does not use a database to keep the focus on:
Infrastructure design
Deployment mechanics
CI/CD automation
Resource management
This avoids unnecessary complexity and lets the project highlight what DevOps engineers actually do.

What This Project Proves About My Skills

By completing this project, I demonstrate the ability to:
Architect cloud systems from scratch
Build & push container images following best practices
Configure Kubernetes deployments with zero-downtime releases

Automate infrastructure using Terraform

Build CI/CD pipelines for consistent deployments

Integrate cloud services such as AWS ALB, IAM, EKS, VPC

Debug, test, and verify production operations
