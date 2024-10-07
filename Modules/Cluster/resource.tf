resource "aws_ecs_cluster" "cluster_assignment" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "task_def" {
  family                = var.family_name
  network_mode          = var.use_fargate ? "awsvpc" : "bridge"
  execution_role_arn    = var.execution_role_arn
  task_role_arn         = var.task_role_arn
  memory                = var.use_fargate ? "512" : "512"
  cpu                   = var.use_fargate ? "256" : "256"

  container_definitions = jsonencode([{
    name          = var.container_name
    image         = var.image_url
    cpu           = tonumber(var.cpu)
    memory        = tonumber(var.memory)
    essential     = true
    portMappings  = var.use_fargate ? [{
      containerPort = 80  # Specify only container port for Fargate
    }] : [{
      containerPort = 80
      hostPort      = 80  # Specify host port for EC2
    }]




    

   
  }])
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  count = var.use_fargate ? 0 : 1

  name = "my-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.auto_scaling_group_arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 100
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_capacity_providers" {
  cluster_name       = aws_ecs_cluster.cluster_assignment.name
  capacity_providers = var.use_fargate ? [] : [aws_ecs_capacity_provider.ecs_capacity_provider[0].name]
}