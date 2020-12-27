resource "aws_cloudwatch_log_group" "for_ecs" {
  name = "/ecs/practice"
  retention_in_days = 30
}