resource "local_file" "hosts" {
  content         = <<-EOF
# Generated by Terraform.
# Host addresses
127.0.0.1  localhost
::1        localhost ip6-localhost ip6-loopback

${yandex_compute_instance.proxy.network_interface.0.ip_address}  nl-nginx nginx
${yandex_compute_instance.mysql[0].network_interface.0.ip_address}  ${yandex_compute_instance.mysql[0].hostname}
${yandex_compute_instance.mysql[1].network_interface.0.ip_address}  ${yandex_compute_instance.mysql[1].hostname}
${yandex_compute_instance.app.network_interface.0.ip_address}   ${yandex_compute_instance.app.hostname}
${yandex_compute_instance.gitlab.network_interface.0.ip_address}    ${yandex_compute_instance.gitlab.hostname}
${yandex_compute_instance.monitoring.network_interface.0.ip_address}    ${yandex_compute_instance.monitoring.hostname}

EOF
  filename        = "../ansible/files/hosts"
  file_permission = "0644"

  depends_on = [
    yandex_compute_instance.proxy,
    yandex_compute_instance.mysql,
    yandex_compute_instance.app,
    yandex_compute_instance.gitlab,
    yandex_compute_instance.monitoring
  ]
}