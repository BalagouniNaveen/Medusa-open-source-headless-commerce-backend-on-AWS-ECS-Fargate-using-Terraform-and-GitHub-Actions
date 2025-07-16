resource "aws_ecs_cluster" "medusa" {                  # Define an ECS cluster named "medusa"
  name = "${var.project_name}-cluster"                 # Set cluster name using the project_name variable
}

resource "aws_ecs_task_definition" "medusa_server" {   # Define a Fargate task definition for medusa_server
  family                   = "medusa-server"           # Family name to group related task definitions
  requires_compatibilities = ["FARGATE"]               # Specify that this task runs on Fargate
  network_mode             = "awsvpc"                  # Use VPC networking for each task (required by Fargate)
  cpu                      = "512"                     # Allocate 0.5 vCPU for the task
  memory                   = "1024"                    # Allocate 1 GB memory for the task

  container_definitions = jsonencode([                 # Define container settings in JSON format
    {
      name      = "medusa-server"                      # Name of the container
      image     = "<ECR_IMAGE_URL>"                    # URL of the container image in ECR
      essential = true                                 # Mark this container as essential for task success
      portMappings = [{ containerPort = 9000 }]        # Expose container port 9000 to the host

      environment = [                                  # Define environment variables for the container
        { name = "MEDUSA_WORKER_MODE", value = "server" },        # Run in server mode
        { name = "DISABLE_MEDUSA_ADMIN", value = "false" },       # Admin panel is enabled
        { name = "DATABASE_URL", value = "<RDS_URL>" },           # Connection string for PostgreSQL (RDS)
        { name = "REDIS_URL", value = "<REDIS_URL>" },            # Redis connection string
        { name = "JWT_SECRET", value = var.jwt_secret },          # JWT secret for authentication
        { name = "COOKIE_SECRET", value = var.cookie_secret }     # Secret for signing cookies
      ]
    }
  ])
}
