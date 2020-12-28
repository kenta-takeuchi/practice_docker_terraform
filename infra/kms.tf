resource "aws_kms_key" "practice" {
  description = "Practice Key"
  enable_key_rotation = true
  is_enabled = true
  deletion_window_in_days = 30
}