variable "aws_region" {     # Defines a variable named aws_region
  default = "us-east-1"     # Uses "us‑east‑1" if no other region is specified :contentReference[oaicite:1]{index=1}
}

variable "project_name" {   # Defines a variable named project_name
  default = "medusa-app"    # Defaults to "medusa-app" when not overridden :contentReference[oaicite:2]{index=2}
}

variable "db_password" {    # Defines a variable named db_password
  default = "MedusaDB123!" # Sets a default database password (can be overridden) :contentReference[oaicite:3]{index=3}
}

variable "cookie_secret" {  # Defines a variable named cookie_secret
  default = "supersecretcookie" # Defaults to this cookie signing secret :contentReference[oaicite:4]{index=4}
}

variable "jwt_secret" {     # Defines a variable named jwt_secret
  default = "supersecretjwt" # Provides a default JWT authentication secret :contentReference[oaicite:5]{index=5}
}
