terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "sss"
    region     = "ru-central1"
    key        = "network/terraform.tfstate"
    access_key = "YCAJEcsagetXsSJH7rHYldT8C"
    secret_key = "YCP83O_Nj10_NHzZ4sahVjBbt7uoRcJGD6Jd_D-1"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
