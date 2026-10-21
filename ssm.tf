
resource "aws_iam_role" "ssm_default_host" {
  name = "AWSSystemsManagerDefaultEC2InstanceManagementRole"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ssm.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_default_policy" {
  role       = aws_iam_role.ssm_default_host.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}

resource "aws_ssm_service_setting" "default_host_management" {
  setting_id = "/ssm/managed-instance/default-ec2-instance-management-role"

  setting_value = "service-role/${aws_iam_role.ssm_default_host.name}"

  depends_on = [
    aws_iam_role_policy_attachment.ssm_default_policy
  ]
}
