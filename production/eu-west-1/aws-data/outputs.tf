output "ubuntu_ami_id" {
  description = "AMI ID"
  value       = data.aws_ami.ubuntu.id
}
