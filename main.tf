terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "AQAAAAAAfme_AATuwafKjSa8nkNHmi-PMEBeVXA"
  cloud_id  = "b1go55i0ebp2f8n7n676"
  folder_id = "b1g1eochf9mlo4eva70l"
  zone      = "ru-central1-b"
}