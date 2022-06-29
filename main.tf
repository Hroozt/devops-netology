provider "yandex" {
  token     = "$(YC_TOKEN)"
  cloud_id  = "b1go55i0ebp2f8n7n676"
  folder_id = "b1g1eochf9mlo4eva70l"
  zone      = "ru-central1-b"
}

resource "yandex_compute_instance" "vm-1" {
  name = "testoform"

  resources {
    cores = 1
    memory = 1
  }

  boot_disk{
    initialize_params{
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
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}