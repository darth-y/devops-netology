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
variable "yandex_zone" {
  description = "Используемая зона доступности обл.провайдера"
  default     = "ru-central1-c"
}

locals {
  env = {
    default = {
      vm_count    = 1
      subnet_addr = "192.168.11"
    }
    stage = {
      subnet_addr = "192.168.201"
    }
    prod = {
      vm_count    = 2
      subnet_addr = "192.168.101"
    }
  }
  # Выбрать default, если не выбран нужный workspace
  env_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  # Дополнить недостающие значения из default
  workspace = merge(local.env["default"], local.env[local.env_vars])
}
#❯ yc compute image list --folder-id standard-images | grep ubuntu-20-04-lts-v202206
#| fd87tirk5i8vitv9uuo1 | ubuntu-20-04-lts-v20220606  | ubuntu-2004-lts   | f2e8tnsqjeor74blquqc | READY  |
variable "image_ubuntu-20-04-lts-v20220606" {
  description = "ID диска-образа"
  default     = "fd87tirk5i8vitv9uuo1"
}
