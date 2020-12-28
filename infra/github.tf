provider "github" {
  token = var.GITHUB_TOKEN
  organization = "kenta-takeuchi"
}

resource "github_repository_webhook" "practice" {
  events = ["push"]
  repository = "practice_docker_terraform"

  configuration {
    url = aws_codepipeline_webhook.practice.url
    secret = "LSxTb6h63BDX97YMiyDeDANT2"
    content_type = "json"
    insecure_ssl = false
  }
}