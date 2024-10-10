# Define the SSH key pair for each VM
resource "tls_private_key" "ssh_key_pair" {
  count = var.vms_count
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Configue cloud-init config from template
data "template_file" "init" {
  count = var.vms_count
  template = "${file("cloudconfig.tftpl")}"
  vars = {
    username = local.username
    ansible_ssh_key = tls_private_key.ssh_key_pair[count.index].public_key_openssh  
    admin_ssh_key = var.admin.Administrator_SSH_Pub_key
  }
}

#####################################################################################################
# Создание виртуалки
resource "aws_instance" "vms" {
    depends_on = [ tls_private_key.ssh_key_pair ]

    # Количество создаваемых виртуальных машин берём из переменной vms_count
    count = var.vms_count

    # ID образа для создания экземпляра ВМ — из переменной vm_template
    ami = var.vm_template

    # Наименование типа экземпляра создаваемой ВМ — из переменной vm_instance_type
    instance_type = var.vm_instance_type

    # Назначаем экземпляру внутренний IP-адрес из созданной ранее подсети в VPC
    subnet_id = var.vm_subnet

    # Подключаем к создаваемому экземпляру внутреннюю группу безопасности
    vpc_security_group_ids = [var.vm_securitygroup]

    # Не выделяем и не присваиваем экземпляру внешний Elastic IP
    associate_public_ip_address = false

    # Не активируем мониторинг экземпляра
    monitoring = false

    # Передача настроек для инициализации через cloud-init
    user_data_base64 = base64encode(data.template_file.init[count.index].rendered)

  tags = {
    Name = "${var.vm_name_prefix} ${count.index}"
  }

  # Создаём диск, подключаемый к экземпляру
  ebs_block_device {
    # Говорим удалять диск вместе с экземпляром
    delete_on_termination = true
    # Задаём имя устройства вида "disk<N>",
    device_name = "disk1"
    # его тип
    volume_type = var.vm_volume_type
    # и размер
    volume_size = var.vm_volume_size

    tags = {
      Name = "Disk for ${var.vm_name_prefix} ${count.index}"
    }
  }
}

##################################################################################################### EIP
# Выделение Elastic и присвоение виртуалке
resource "aws_eip" "Creating_EIPs" {
  depends_on  = [ aws_instance.vms ]
  count       = length(aws_instance.vms)
  instance    = aws_instance.vms[count.index].id
  vpc         = true
  tags = {
    Name = aws_instance.vms[count.index].tags.Name
  }
}

resource "local_file" "private_keys" {
  depends_on  = [ aws_instance.vms, aws_eip.Creating_EIPs ]
  count       = length(data.template_file.init)
  content     = tls_private_key.ssh_key_pair[count.index].private_key_openssh
  filename    = "../Ansible/${local.modified_names[count.index]}.private"
  file_permission = "0600"
}

# Creating inventory for Ansible in .yml
resource "local_file" "hosts_yaml" {
  depends_on = [ aws_instance.vms, aws_eip.Creating_EIPs ]
  content = templatefile("inventory_yml.tftpl",
    {
      username    = local.username
      name        = local.modified_names
      ip          = [ for idx, obj in aws_eip.Creating_EIPs: obj.public_ip ]
    })
  filename = "../Ansible/inventory.yml"
}
