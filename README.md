# Medusa-open-source-headless-commerce-backend-on-AWS-ECS-Fargate-using-Terraform-and-GitHub-Actions

https://github.com/medusajs/medusa/issues/485?utm_source=chatgpt.com
https://medium.com/%40akhandsinghofficial/deploying-medusa-js-on-aws-a-cost-efficient-guide-using-ecs-fargate-spot-and-terraform-50e221d71828
https://medusajs.com/blog/a-step-by-step-tutorial-on-how-to-deploy-a-medusa-server-on-aws/?utm_source=chatgpt.com


To deploy the Medusa open-source headless commerce backend on AWS ECS Fargate using Terraform and GitHub Actions (CI/CD), here's a complete step-by-step solution with code, architecture, and GitHub integration.
**
**Project Overview
VPC + Subnets + Security Groups
PostgreSQL (RDS)
Redis (ElastiCache)
ECS Cluster with Fargate tasks
Docker image pushed to ECR
Application Load Balancer
CI/CD using GitHub Actions****


**Step-by-Step Implementation**
**1. Repository Structure**

**medusa-aws-deploy/**
medusa-aws-deploy/
├── terraform/
│   ├── main.tf             ← AWS provider + VPC, subnets, IGW
│   ├── variables.tf        ← parameterize region, names, DB secrets, etc.
│   ├── outputs.tf          ← expose ALB DNS, DB/Redis endpoints
│   ├── ecr.tf              ← ECR repo for Docker images
│   ├── ecs.tf              ← ECS cluster, task definitions, services
│   ├── rds.tf              ← Managed PostgreSQL setup
│   ├── elasticache.tf      ← Redis cache configuration
│   ├── alb.tf              ← Application Load Balancer + listeners
├── .github/
│   └── workflows/deploy.yml ← CI/CD pipeline config
├── Dockerfile             ← Builds Medusa server/worker container
├── medusa-config.ts       ← Medusa config (DB, Redis, secrets, modules)
├── package.json           ← Dependencies and scripts
└── README.md
**

**Terraform Variables (variables.tf)**
variable "aws_region"     { default = "us-east-1" }
variable "project_name"   { default = "medusa-app" }
variable "db_password"    { default = "MedusaDB123!" }
variable "cookie_secret"  { default = "supersecretcookie" }
variable "jwt_secret"     { default = "supersecretjwt" }

**Networking (main.tf)**
**provider "aws" { region = var.aws_region }

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}**

VPC isolates your application network

Subnets (2 AZs for redundancy)

Internet Gateway enables outbound/inbound to the public internet

**Docker Image & ECR (ecr.tf)**
resource "aws_ecr_repository" "medusa" {
  name = "${var.project_name}-repo"
}
This creates a private Docker registry in AWS (ECR), where containers are stored.

**Database + Redis (rds.tf & elasticache.tf)**
resource "aws_db_instance" "postgres" {
  allocated_storage   = 20
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  name                = "medusadb"
  username            = "admin"
  password            = var.db_password
  skip_final_snapshot = true
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id      = "medusa-redis"
  engine          = "redis"
  node_type       = "cache.t3.micro"
  num_cache_nodes = 1
}
RDS for persistent storage

ElastiCache (Redis) for caching, session store, and event bus

**ECS + Fargate (ecs.tf)**
resource "aws_ecs_cluster" "medusa" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "medusa_server" {
  family                   = "medusa-server"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu        = "512"
  memory     = "1024"
  container_definitions    = jsonencode([{
    name      = "medusa-server"
    image     = "<ECR_IMAGE_URL>"
    portMappings = [{ containerPort = 9000 }]
    environment = [
      { name = "MEDUSA_WORKER_MODE", value = "server" },
      { name = "DATABASE_URL",        value = "<RDS_URL>" },
      { name = "REDIS_URL",           value = "<REDIS_URL>" },
      { name = "COOKIE_SECRET",       value = var.cookie_secret },
      { name = "JWT_SECRET",          value = var.jwt_secret }
    ]
  }])
}

Cluster groups Fargate tasks

TaskDefinition defines Docker containers, env vars, resources

A server task (API + admin UI)

A worker task for background jobs


**Application Load Balancer (ALB) (alb.tf**)
resource "aws_lb" "medusa_alb" {
  name               = "medusa-alb"
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
}

resource "aws_lb_target_group" "medusa_tg" {
  name   = "medusa-tg"
  port   = 9000
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
}

# Add listener and attach to ECS service in ecs.tf (not shown above)
ALB routes traffic to the server containers

Target Group defines which port/protocol to use

**CI/CD via GitHub Actions (.github/workflows/deploy.yml)**

name: Deploy to AWS

on: [push]  # on pushes to main

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_KEY }}
          aws-region: us-east-1

      - name: Login to ECR
        run: |
          aws ecr get-login-password \
            | docker login --username AWS \
            --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com

      - name: Build & push Docker image
        run: |
          docker build -t medusa .
          docker tag medusa:latest <ECR_URI>:latest
          docker push <ECR_URI>:latest

      - name: Deploy Terraform
        run: |
          cd terraform
          terraform init
          terraform apply -auto-approve
          
**Workflow breakdown:**

Checkout code
Configure AWS credentials using GitHub secrets
Docker login to ECR
Build & push Medusa container to ECR
Run Terraform to provision/update infrastructure and update ECS service

 **Dockerfile**
 FROM node:18-alpine
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --production

COPY . .
RUN npm run build

CMD ["sh", "-c", "npm run predeploy && medusa start"]

Installs dependencies

Copies your Medusa code

Builds the backend

On start, runs migrations and launches the server (or worker, based on env)


**Medusa Config (medusa-config.ts)**
import { loadEnv, defineConfig } from "@medusajs/framework/utils"
loadEnv()

export default defineConfig({
  projectConfig: {
    databaseUrl: process.env.DATABASE_URL,
    redisUrl: process.env.REDIS_URL,
    workerMode: process.env.MEDUSA_WORKER_MODE as "server" | "worker",
    http: {
      cookieSecret: process.env.COOKIE_SECRET,
      jwtSecret: process.env.JWT_SECRET,
      storeCors: process.env.STORE_CORS,
      adminCors: process.env.ADMIN_CORS
    },
  },
  admin: {
    disable: process.env.DISABLE_MEDUSA_ADMIN === "true",
    backendUrl: process.env.MEDUSA_BACKEND_URL
  },
  modules: [
    { resolve: "@medusajs/medusa/cache-redis", options: { redisUrl: process.env.REDIS_URL }},
    { resolve: "@medusajs/medusa/event-bus-redis", options: { redisUrl: process.env.REDIS_URL }},
    { resolve: "@medusajs/medusa/workflow-engine-redis", options: { redis: { url: process.env.REDIS_URL } }}
  ],
})


Loads environment variables

Enables Redis modules for caching, events, workflows

Enables/disables admin UI based on mode

**package.json**
{
  "name": "medusa-app",
  "version": "1.0.0",
  "scripts": {
    "dev": "medusa develop",
    "build": "medusa build",
    "predeploy": "medusa db:migrate",
    "start": "medusa start",
    "test": "jest"
  },
  "dependencies": {
    "@medusajs/medusa": "^2.6.0",
    "@medusajs/medusa/cache-redis": "^2.6.0",
    "@medusajs/medusa/event-bus-redis": "^2.6.0",
    "@medusajs/medusa/workflow-engine-redis": "^2.6.0",
    "pg": "^8.8.0",
    "ioredis": "^5.3.2",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {
    "typescript": "^5.3.3",
    "jest": "^29.7.0",
    "ts-jest": "^29.1.1"
  },
  "engines": { "node": ">=18.0.0" }
}




