terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "sss"
    region     = "ru-central1"
    key        = "network/terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
