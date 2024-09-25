output "VMs" {
  value = aws_instance.vms[*].id
}