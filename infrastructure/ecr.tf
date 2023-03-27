// can import containers through terraform cli https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository
// terraform import aws_ecr_repository.service test-service
resource "aws_ecr_repository" "main" {
  name                 = "groenbek-ecr-repository"
  image_tag_mutability = "MUTABLE"
  force_delete         = true //denotes if it should be deleted if it contains images, i suspect might clash with terraform destroy if not set to true

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repo_id" {
  value = aws_ecr_repository.main.registry_id
}

