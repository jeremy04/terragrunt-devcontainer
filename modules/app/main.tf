
module "app_alb" {
  source          = "terraform-aws-modules/alb/aws"
  name            = "app-alb"
  subnets         = var.public_subnets
  security_groups = [var.alb_sg]
  vpc_id          = var.vpc_id
}

module "ecs_app" {
  source = "terraform-aws-modules/ecs/aws"

  name          = "rails-api"
  launch_type   = "FARGATE"
  desired_count = 2

  container_definitions = jsonencode([
    {
      name         = "nginx"
      image        = "nginx:latest"
      portMappings = [{ containerPort = 443 }]
    },
    {
      name         = "rails"
      image        = "myorg/rails-api:latest"
      portMappings = [{ containerPort = 3000 }]
    }
  ])
}

module "ecs_sidekiq" {
  source = "terraform-aws-modules/ecs/aws"

  name          = "sidekiq"
  launch_type   = "FARGATE"
  desired_count = 1

  container_definitions = jsonencode([
    {
      name    = "sidekiq"
      image   = "myorg/rails-api:latest"
      command = ["bundle", "exec", "sidekiq"]
    }
  ])
}
