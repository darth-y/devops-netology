# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "b1gl034dees3m3m0be0f"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "b1gm319lmj82njp4qfkd"
}

# Зона доступности по умолчанию
variable "yandex_zone" {
  default = "ru-central1-c"
}

# Image ID
#❯ yc compute image list --folder-id standard-images | grep ubuntu-20-04-lts-v202206
#| fd87tirk5i8vitv9uuo1 | ubuntu-20-04-lts-v20220606                                     | ubuntu-2004-lts                                 | f2e8tnsqjeor74blquqc           | READY  |
variable "image_ubuntu-20-04-lts-v20220606" {
  default = "fd87tirk5i8vitv9uuo1"
}

# Count of VMs
variable "vm_count" {
  default = 1
}

# Subnet address
variable "subnet_addr" {
  default = "192.168.101"
}