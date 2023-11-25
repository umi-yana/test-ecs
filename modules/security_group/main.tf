resource "aws_security_group" "ecs_access_security_group" {
  name   = "${var.default_name}_aws_security_group"
  vpc_id = var.vpc_id
}

# インバウンドルール
resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_access_security_group.id
}

# アウトバウンドルール
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_access_security_group.id
}


