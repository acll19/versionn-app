resource "aws_iam_role" "versionn-app-role" {
  name = "${var.app_prefix}-awslogs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "versionn-app-policy" {
  name = "${var.app_prefix}-awslogs"
  role = aws_iam_role.versionn-app-role.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams"
        ]
        Resource = "*"
      },
    ]
  })
}
