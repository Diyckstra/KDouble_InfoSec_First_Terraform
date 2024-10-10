output "VMs" {
  value = [ for idx, name in aws_instance.vms:
    {
      "VM" = name.tags.Name
      "IP" = aws_eip.Creating_EIPs[idx].public_ip
      "Login" = local.username
      "Password" = "Use SSH key pair, you should have specified the public key in the variable admin.Administrator_SSH_Pub_key"
    }
  ]
}