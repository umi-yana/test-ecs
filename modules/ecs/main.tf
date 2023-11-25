# 実行ロール
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "example" {
  name = "/ecs/example"
}


resource "aws_ecs_cluster" "cluster" {
  name = "${var.default_name}-ecs-cluster"
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.default_name
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  container_definitions    = <<JSON
  [
    {
      "name": "${var.default_name}",
      "image": "${var.ecr_image}",
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp",
          "appProtocol": "http"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.example.name}",
          "awslogs-region": "ap-northeast-1",
          "awslogs-stream-prefix": "${var.default_name}"
        }
      }
    }
  ]
  JSON
}


resource "aws_ecs_service" "test_ecs_service" {
  name            = "${var.default_name}-ecs-service"
  cluster         = aws_ecs_cluster.cluster.arn
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  # health_check_grace_period_seconds = 60
  network_configuration {
    subnets         = [var.subnet_id]
    security_groups = [var.security_group_id]
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}
