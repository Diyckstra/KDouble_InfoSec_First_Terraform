locals {
    EC2_ACCESS_KEY = "${var.admin.C2_PROJECT}:${var.admin.BASE_ACCESS_KEY}"
    username = split("@", var.admin.BASE_ACCESS_KEY)[0]
    modified_names = [ for idx, obj in aws_instance.vms: "${replace(replace(replace(replace(var.vm_name_prefix, "[", ""), "] ", "_" ), "@", "_"), ".", "_")}_${idx}" ]
}