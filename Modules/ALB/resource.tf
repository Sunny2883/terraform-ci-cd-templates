# ALB Configuration
resource "aws_alb" "this" {
  internal                     = false
  load_balancer_type           = "application"
  subnets                      = var.subnets
  security_groups              = var.security_groups
  enable_deletion_protection    = false
}

resource "aws_lb_target_group" "ec2_target_group" {
  count    = var.use_fargate ? 0 : 1  # Only create if not using Fargate
  name     = "tg-ec2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

}
# HTTP Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_alb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_target_group[0].arn  # Replace with the appropriate target group ARN
  }
}


# Target Group for Fargate
resource "aws_lb_target_group" "fargate_target_group" {
  count    = var.use_fargate ? 1 : 0  # Only create if using Fargate
  name     = "tg-fargate"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"  # Use 'ip' for Fargate compatibility


}