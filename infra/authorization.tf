resource "aws_iam_role" "versionn-app-role" {
  name = "${var.app_prefix}-awslogs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Effect = "Allow"
    Statement = [
      {
        Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams"
        ]
        Resource = [
          "arn:aws:logs:*:*:*"
        ]
      },
    ]
  })
}