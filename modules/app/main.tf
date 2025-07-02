
module "app_alb" {
  count = var.use_localstack ? 0 : 1
  source          = "terraform-aws-modules/alb/aws"
  name            = "app-alb"
  subnets         = var.public_subnets
  security_groups = [var.alb_sg]
  vpc_id          = var.vpc_id
}

resource "aws_ecs_cluster" "main" {
  count = var.use_localstack ? 0 : 1
  name = "rails-api"
}

resource "aws_ecs_task_definition" "rails_app" {
  count = var.use_localstack ? 0 : 1
  family                   = "rails-api"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = 512
  memory                  = 1024
  execution_role_arn      = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name         = "nginx"
      image        = "nginx:latest"
      cpu          = 256
      memory       = 512
      portMappings = [{ containerPort = 443 }]
    },
    {
      name         = "rails"
      image        = "myorg/rails-api:latest"
      cpu          = 256
      memory       = 512
      portMappings = [{ containerPort = 3000 }]
    }
  ])
}

resource "aws_ecs_service" "rails_app" {
  count = var.use_localstack ? 0 : 1
  name            = "rails-api"
  cluster         = aws_ecs_cluster.main[0].id
  task_definition = aws_ecs_task_definition.rails_app[0].arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.public_subnets
    security_groups = [var.alb_sg]
  }
}

resource "aws_ecs_task_definition" "sidekiq" {
  count = var.use_localstack ? 0 : 1
  family                   = "sidekiq"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = 256
  memory                  = 512
  execution_role_arn      = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name    = "sidekiq"
      image   = "myorg/rails-api:latest"
      command = ["bundle", "exec", "sidekiq"]
      cpu     = 256
      memory  = 512
    }
  ])
}

resource "aws_ecs_service" "sidekiq" {
  count = var.use_localstack ? 0 : 1
  name            = "sidekiq"
  cluster         = aws_ecs_cluster.main[0].id
  task_definition = aws_ecs_task_definition.sidekiq[0].arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.public_subnets
    security_groups = [var.alb_sg]
  }
}

resource "aws_iam_role" "ecs_execution" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
