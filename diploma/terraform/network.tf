# Network
resource "yandex_vpc_network" "network" {
  name = "net-${terraform.workspace}"
}

resource "yandex_vpc_subnet" "subnetwork" {
  name           = "subnet-${terraform.workspace}"
  zone           = local.workspace["yandex_zone"]
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["${local.workspace["subnet_addr"]}.0/24"]
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

# Маршрут для машин, не имеющих белого IP
resource "yandex_vpc_route_table" "nat-instance-route" {
  network_id = yandex_vpc_network.network.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "${local.workspace["subnet_addr"]}.10"
  }
}
