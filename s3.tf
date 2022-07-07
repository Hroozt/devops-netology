terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "sss"
    region     = "ru-central1"
    key        = "network/terraform.tfstate"
    access_key = "<access_key>"
    secret_key = "<secret_key >"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
