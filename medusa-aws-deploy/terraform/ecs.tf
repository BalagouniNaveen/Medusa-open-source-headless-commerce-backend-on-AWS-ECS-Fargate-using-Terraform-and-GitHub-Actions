resource "aws_ecs_cluster" "medusa" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "medusa_server" {
  family                   = "medusa-server"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"

  container_definitions = jsonencode([
    {
      name      = "medusa-server"
      image     = "<ECR_IMAGE_URL>"
      essential = true
      portMappings = [{ containerPort = 9000 }]
      environment = [
        { name = "MEDUSA_WORKER_MODE", value = "server" },
        { name = "DISABLE_MEDUSA_ADMIN", value = "false" },
        { name = "DATABASE_URL", value = "<RDS_URL>" },
        { name = "REDIS_URL", value = "<REDIS_URL>" },
        { name = "JWT_SECRET", value = var.jwt_secret },
        { name = "COOKIE_SECRET", value = var.cookie_secret }
      ]
    }
  ])
}

# Repeat for medusa_worker with MEDUSA_WORKER_MODE=worker and DISABLE_MEDUSA_ADMIN=true
