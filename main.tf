provider "yandex" {
  token = "token"
  zone      = "ru-central1-b"
}

locals {
  web_instance_count_map = {
  stage = 1
  prod = 2
  }
  web_instance_type_map = {
  stage = "standart-v1"
  prod = "standart-v2"
  }
  web_instance_fe_map ={
  stage = ["1"]
  prod = ["1", "2"]
  }
}


resource "yandex_compute_instance" "vm-1" {
  count=local.web_instance_count_map[terraform.workspace]
  name = "VM ${local.web_instance_type_map[terraform.workspace]} ${terraform.workspace} ${count.index}"
  platform_id=local.web_instance_type_map[terraform.workspace]
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd81hgrcv6lsnkremf32"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
  lifecycle {create_before_destroy = true}

}

resource "yandex_compute_instance" "for_each" {
  for_each = toset (local.web_instance_fe_map[terraform.workspace])
  name = "VM_fe ${local.web_instance_count_map[terraform.workspace]} ${terraform.workspace} ${each.key}"
  platform_id=local.web_instance_type_map[terraform.workspace]
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd81hgrcv6lsnkremf32"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.*.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.*.network_interface.0.nat_ip_address
}
