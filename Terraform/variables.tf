variable "admin" {
  type = object(
    {
        C2_PROJECT = string
        BASE_ACCESS_KEY = string
        EC2_SECRET_KEY = string
        Administrator_SSH_Pub_key = string
    })
  default = {
    C2_PROJECT      = "Network_Security"
    BASE_ACCESS_KEY = "YOUR MAIL @dit10.ru"
    EC2_SECRET_KEY  = "Super_Secret_Key_!@#$"
    Administrator_SSH_Pub_key = ""
  }
}

variable "az" {
  default     = "ru-msk-comp1p"
}

variable "vms_count" {
  default     = 0
}

variable "vm_name_prefix" {
  default = "example_vm"
}

variable "vm_template" {
  default     = "cmi-D01767A6"
}

variable "vm_instance_type" {
  default     = "m5.2small"
}

variable "vm_volume_type" {
  default     = "gp2"
}

variable "vm_volume_size" {
  # Размер по умолчанию и шаг наращивания указаны для типа дисков gp2
  # Для других типов дисков они могут быть иными — подробнее см. в документации на диски
  description = "Enter the volume size for VM disks (32 by default, in GiB, must be multiple of 32)"
  default     = 32
}

variable "vm_subnet" {
  default     = ""
}

variable "vm_securitygroup" {
  default     = ""
}