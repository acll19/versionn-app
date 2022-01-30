resource "aws_cloudwatch_log_group" "versionn-app-task-log-group" {
  name              = "${var.app_prefix}-task-log-group"
  retention_in_days = 3
}