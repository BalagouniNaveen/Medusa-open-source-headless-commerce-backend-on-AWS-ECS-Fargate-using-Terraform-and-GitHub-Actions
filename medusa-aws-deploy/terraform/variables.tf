variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "medusa-app"
}

variable "db_password" {
  default = "MedusaDB123!"
}

variable "cookie_secret" {
  default = "supersecretcookie"
}

variable "jwt_secret" {
  default = "supersecretjwt"
}
