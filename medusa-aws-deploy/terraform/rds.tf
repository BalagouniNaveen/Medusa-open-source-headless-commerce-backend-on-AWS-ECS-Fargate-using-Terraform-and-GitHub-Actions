resource "aws_db_instance" "postgres" {      # Define an RDS PostgreSQL instance resource
  allocated_storage    = 20                 # Allocate 20 GB storage for the DB :contentReference[oaicite:1]{index=1}
  engine               = "postgres"         # Use PostgreSQL as the database engine :contentReference[oaicite:2]{index=2}
  instance_class       = "db.t3.micro"      # Select a low-tier instance class (1 vCPU, ~1 GB RAM) :contentReference[oaicite:3]{index=3}
  name                 = "medusadb"         # Create the initial database schema named “medusadb”
  username             = "admin"            # Set the master username for database access
  password             = var.db_password    # Use a variable for the DB password securely
  skip_final_snapshot  = true               # Skip creating a final snapshot when destroying :contentReference[oaicite:4]{index=4}
}

resource "aws_elasticache_cluster" "redis" { # Define a Redis cache cluster using ElastiCache
  cluster_id           = "medusa-redis"     # Unique identifier for the Redis cluster
  engine               = "redis"            # Specify Redis as the cache engine :contentReference[oaicite:5]{index=5}
  node_type            = "cache.t3.micro"   # Choose a small cache node type (t3 micro) :contentReference[oaicite:6]{index=6}
  num_cache_nodes      = 1                  # Provision a single Redis node (non‑cluster mode) :contentReference[oaicite:7]{index=7}
}
