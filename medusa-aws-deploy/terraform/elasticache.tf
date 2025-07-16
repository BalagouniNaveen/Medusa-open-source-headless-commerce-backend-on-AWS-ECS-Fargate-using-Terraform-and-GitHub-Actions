resource "aws_db_instance" "postgres" {     # Define an RDS PostgreSQL instance
  allocated_storage    = 20                # Allocate 20 GB of storage for the database :contentReference[oaicite:1]{index=1}
  engine               = "postgres"        # Use PostgreSQL as the database engine :contentReference[oaicite:2]{index=2}
  instance_class       = "db.t3.micro"     # Choose a small instance type (1 vCPU, ~1 GB RAM)
  name                 = "medusadb"        # Set the initial database name to "medusadb"
  username             = "admin"           # Configure the master username for DB access
  password             = var.db_password   # Use a Terraform variable for the DB password
  skip_final_snapshot  = true              # Skip snapshot on delete to allow immediate destroy :contentReference[oaicite:3]{index=3}
}

resource "aws_elasticache_cluster" "redis" {  # Define an ElastiCache cluster for Redis
  cluster_id           = "medusa-redis"      # Assign a unique identifier for the Redis cluster :contentReference[oaicite:4]{index=4}
  engine               = "redis"             # Choose Redis as the caching engine :contentReference[oaicite:5]{index=5}
  node_type            = "cache.t3.micro"    # Select a t3.micro node type for Redis :contentReference[oaicite:6]{index=6}
  num_cache_nodes      = 1                   # Deploy a single cache node (non‑cluster mode) :contentReference[oaicite:7]{index=7}
}
