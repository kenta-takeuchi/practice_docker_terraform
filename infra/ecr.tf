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

resource "aws_ecr_repository" "client" {
  name = "client"
}

resource "aws_ecr_lifecycle_policy" "client" {
  repository = aws_ecr_repository.client.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Keep last 10 release tagged images",
        "selection": {
          "tagStatus": "tagged",
          "tagPrefixList": ["client"],
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

resource "aws_ecr_repository" "api" {
  name = "api"
}

resource "aws_ecr_lifecycle_policy" "api" {
  repository = aws_ecr_repository.api.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Keep last 10 release tagged images",
        "selection": {
          "tagStatus": "tagged",
          "tagPrefixList": ["api"],
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

