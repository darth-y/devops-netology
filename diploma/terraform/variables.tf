# Переменные
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  description = "ID облака"
  default     = "b1gl034dees3m3m0be0f"
}
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  description = "ID папки проекта в облаке"
  default     = "b1gm319lmj82njp4qfkd"
}
variable "domain" {
  description = "Имя домена"
  default     = "amabam.ru"
}
locals {
  env = {
    stage = {
      db_count    = 2
      subnet_addr = "192.168.201"
      yandex_zone = "ru-central1-b"
      # https://letsencrypt.org/docs/staging-environment/
      letsencrypt_staging = "true"
    }
    prod = {
      subnet_addr         = "192.168.101"
      yandex_zone         = "ru-central1-a"
      letsencrypt_staging = "false"
    }
  }
  # Выбрать stage, если не выбран нужный workspace
  env_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "stage"
  # Дополнить недостающие значения из stage
  workspace = merge(local.env["stage"], local.env[local.env_vars])
}

data "yandex_compute_image" "boot_image" {
  family = "ubuntu-2004-lts"
}

#❯ yc compute image list --folder-id standard-images | grep ubuntu-20-04-lts-v202206
#| fd87tirk5i8vitv9uuo1 | ubuntu-20-04-lts-v20220606  | ubuntu-2004-lts   | f2e8tnsqjeor74blquqc | READY  |
#variable "image_ubuntu" {
#  description = "ID диска-образа"
#  default     = "fd87tirk5i8vitv9uuo1"
#}