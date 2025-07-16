resource "aws_lb" "medusa_alb" {
  name               = "medusa-alb"              # name of the AWS load balancer
  load_balancer_type = "application"             # Specify this as an Application Load Balancer (Layer 7)
  subnets            = aws_subnet.public[*].id   # Attach LB to all public subnet IDs for high availability
}

resource "aws_lb_target_group" "medusa_tg" {
  name     = "medusa-tg"                        # name of the target group receiving traffic
  port     = 9000                               # port on which targets are listening (your app’s port)
  protocol = "HTTP"                             # protocol used between ALB and targets
  vpc_id   = aws_vpc.main.id                    # VPC in which the target group is created
}


#VPC (Virtual Private Cloud): a logically isolated virtual network within a public cloud where you can launch and manage AWS resources like in your own data center 
# ALB (Application Load Balancer): a Layer 7 AWS load balancer that routes HTTP/HTTPS traffic intelligently to multiple healthy targets based on content and rules 
#LB (Load Balancer): a service or device that distributes incoming network or application traffic across multiple servers to optimize performance, availability, and fault tolerance
