output "alb_dns_name" {                      # Exposes the DNS name of the Application Load Balancer
  value = aws_lb.medusa_alb.dns_name
}

output "rds_endpoint" {                      # Outputs the connection endpoint (hostname) for the RDS instance
  value = aws_db_instance.postgres.endpoint
}

output "redis_endpoint" {                    # Provides the Redis cluster’s node address for use in applications
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}
