resource "aws_ecr_repository" "practice" {
  name = "practice"
}

resource "aws_ecr_lifecycle_policy" "practice" {
  repository = aws_ecr_repository.practice.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Keep last 10 release tagged images",
        "selection": {
          "tagStatus": "tagged",
          "tagPrefixList": ["practice"],
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


