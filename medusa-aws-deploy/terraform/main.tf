provider "aws" {                             # Use AWS provider and set the region from a variable
  region = var.aws_region                   # Defines which AWS region Terraform will manage :contentReference[oaicite:1]{index=1}
}

resource "aws_vpc" "main" {                  # Creates a new Virtual Private Cloud
  cidr_block = "10.0.0.0/16"                 # Reserves 65,536 IP addresses for the VPC :contentReference[oaicite:2]{index=2}
}

resource "aws_subnet" "public" {             # Defines two public subnets inside the VPC
  count                  = 2                # Creates 2 subnet resources :contentReference[oaicite:3]{index=3}
  vpc_id                 = aws_vpc.main.id  # Associates subnets with the VPC
  cidr_block             = "10.0.${count.index}.0/24"  # Assigns unique /24 CIDR blocks like 10.0.0.0/24 and 10.0.1.0/24
  map_public_ip_on_launch = true            # Automatically assigns public IPs to instances launched here :contentReference[oaicite:4]{index=4}
}

resource "aws_internet_gateway" "gw" {       # Attaches an Internet Gateway to the VPC
  vpc_id = aws_vpc.main.id                  # Enables internet connectivity for public subnets :contentReference[oaicite:5]{index=5}
}
