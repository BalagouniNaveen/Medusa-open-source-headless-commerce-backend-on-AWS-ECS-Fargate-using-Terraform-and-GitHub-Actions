resource "aws_ecr_repository" "medusa" {     # Declare an AWS ECR repository resource named "medusa"
  name = "${var.project_name}-repo"           # Set the repository’s name dynamically using the project_name variable
}
