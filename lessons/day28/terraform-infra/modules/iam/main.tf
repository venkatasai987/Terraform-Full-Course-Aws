# IAM Role for EC2 Instances
resource "aws_iam_role" "ec2_role" {
  name = "${var.environment}-${var.project}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.project}-ec2-role"
    }
  )
}

# Attach AWS managed policy for SSM (Session Manager)
resource "aws_iam_role_policy_attachment" "ssm_managed" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach AWS managed policy for CloudWatch
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Custom policy for Secrets Manager access
resource "aws_iam_policy" "secrets_manager" {
  name        = "${var.environment}-${var.project}-secrets-manager-policy"
  description = "Allow EC2 instances to read secrets from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = var.secrets_arns
      }
    ]
  })

  tags = var.tags
}

# Attach custom Secrets Manager policy
resource "aws_iam_role_policy_attachment" "secrets_manager" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.secrets_manager.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.environment}-${var.project}-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.project}-ec2-instance-profile"
    }
  )
}
//ssm Attach custom policy for SSM Session Manager access
resource "aws_iam_policy" "bastion_ssm_start" {
  name = "${var.environment}-${var.project}-bastion-ssm-start"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:StartSession",
          "ssm:DescribeSessions",
          "ssm:GetConnectionStatus",
          "ssm:TerminateSession"
        ]
        Resource = [
  "arn:aws:ec2:${var.region}:${var.account_id}:instance/i-02eba0792e0b9caec",
  "arn:aws:ec2:${var.region}:${var.account_id}:instance/i-00d836ff39d108c3d",
   "arn:aws:ssm:${var.region}:${var.account_id}:document/SSM-SessionManagerRunShell"
]
      }
    ]
  })
}
// Attach custom policy for SSM Session Manager access
resource "aws_iam_role_policy_attachment" "bastion_ssm_start_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.bastion_ssm_start.arn
}