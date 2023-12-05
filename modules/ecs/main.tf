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

resource "aws_ecs_service" "test_ecs_service" {
  name            = "${var.default_name}-ecs-service"
  cluster         = aws_ecs_cluster.cluster.arn
  task_definition = aws_ecs_task_definition.task_definition.arn
  # ecs-compose.ymlで実行する際に並行するタスクを決定するため、terraformでは０で指定する
  # ０にする背景: desired_count = 1の場合、terraform apply時にタスクが実行してしまうため、０に指定する
  desired_count = 0
  launch_type   = "FARGATE"
  network_configuration {
    subnets         = [var.subnet_id]
    security_groups = [var.security_group_id]
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}
