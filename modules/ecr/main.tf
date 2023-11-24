resource "aws_ecr_repository" "test_repository" {
  name = "${var.default_name}_test_repository"
}

resource "aws_ecr_lifecycle_policy" "test_ecr_lifecycle_policy" {
  repository = aws_ecr_repository.test_repository.name
  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "selection": {
          "tagStatus": "tagged",
          "tagPrefixList": ["test"],
          "countType": "imageCountMoreThan",
          "countNumber": 10
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
EOF
}