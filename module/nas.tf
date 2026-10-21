resource "aws_efs_file_system" "nas" {
  creation_token = "homework-nas"

  encrypted = true

  tags = {
    Name = "homework-nas"
  }
}

resource "aws_security_group" "nas" {
  name        = "homework-nas-sg"
  description = "Allow NFS from web instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "NFS from EC2"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [var.web_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_efs_mount_target" "private" {
  count = 2

  file_system_id  = aws_efs_file_system.nas.id
  subnet_id       = aws_subnet.private[count.index].id
  security_groups = [aws_security_group.nas.id]
}