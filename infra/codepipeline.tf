variable "GITHUB_TOKEN" {}

resource "aws_codepipeline" "practice" {
  name = "practice"
  role_arn = module.codepipeline_role.iam_role_arn

  artifact_store {
    location = aws_s3_bucket.artifact.id
    type = "S3"
  }

  stage {
    name = "Source"
    action {
      name = "Source"
      category = "Source"
      owner = "ThirdParty"
      provider = "GitHub"
      version = 1
      output_artifacts = [
        "Source"]

      configuration = {
        OAuthToken = var.GITHUB_TOKEN
        Owner = "kenta-takeuchi"
        Repo = "practice_docker_terraform"
        Branch = "main"
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Build"
    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = 1
      input_artifacts = [
        "Source"]
      output_artifacts = [
        "Build"]

      configuration = {
        ProjectName = aws_codebuild_project.practice.id
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name = "Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "ECS"
      version = 1
      input_artifacts = [
        "Build"]

      configuration = {
        ClusterName = aws_ecs_cluster.practice.name
        ServiceName = aws_ecs_service.practice.name
        FileName    = "imagedefinitions.json"
      }
    }
  }
}

resource "aws_codepipeline_webhook" "practice" {
  authentication = "GITHUB_HMAC"
  name = "practice"
  target_action = "Source"
  target_pipeline = aws_codepipeline.practice.name

  authentication_configuration {
    secret_token = "LSxTb6h63BDX97YMiyDeDANT2"
  }

  filter {
    json_path = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }

}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    effect = "Allow"
    resources = [
      "*"]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService",
      "iam:PassRole",
    ]
  }
}

module "codepipeline_role" {
  source = "./iam_role"
  name = "codepipeline"
  identifier = "codepipeline.amazonaws.com"
  policy = data.aws_iam_policy_document.codepipeline.json
}