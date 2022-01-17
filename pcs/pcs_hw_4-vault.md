# Cоздайте ЦС и выпустите сертификат

Перед началом выполнения в файле hosts хостовой машины добавил запись vault.lab.local и nginx.lab.local ведущую на IP-адрес лабораторной виртуальной машины.

```bash
vagrant@devnet01:~$ sudo systemctl enable vault --now
vagrant@devnet01:~$ sudo nano /etc/vault.d/vault.hcl
```
Правки в `vault.hcl`:
```bash
listener "tcp" {
  address = "127.0.0.1:8201"
  tls_disable = 1
}
```
Далее продолжаем в терминале:
```bash
vagrant@devnet01:~$ sudo systemctl restart vault
vagrant@devnet01:~$ echo VAULT_ADDR=http://127.0.0.1:8201 | sudo tee -a /etc/environment
vagrant@devnet01:~$ source /etc/environment
vagrant@devnet01:~$ vault status
Key                Value
---                -----
Seal Type          shamir
Initialized        false
Sealed             true
Total Shares       0
Threshold          0
Unseal Progress    0/0
Unseal Nonce       n/a
Version            1.9.2
Storage Type       file
HA Enabled         false
vagrant@devnet01:~$ vault operator init
```
Создадим скрипт распечатывания сервера (для автоматизации перезапуска):
```bash
vagrant@devnet01:~$ mkdir -p /opt/vault
vagrant@devnet01:~$ sudo nano /opt/vault/unseal.sh
```
```bash
#!/usr/bin/env bash
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

sleep 35
vault operator unseal utlry8sIuJi6UpVpcP1ppOKOpEz9DmEMUJ6K1SaOzuaf
vault operator unseal cgUO3JIInnE9KX7PomNE64hXvH3UVTsTRzFkb24MS6zr
vault operator unseal qWLSiuZ9Z8B9Mu+1ct3Sb1LVi66LHSa4L5B3euds6bap
#vault operator unseal Rp6plRAiqXU0B3QgDg+DzVcnK28s2CDxOP0j284ac8YZ
#vault operator unseal mG9odQ0qU6P5Q3/dycJhCOw1QwDctEbibwU5Ej4Tb76W
```
```bash
vagrant@devnet01:~$ sudo chown -R vault:vault /opt/vault
vagrant@devnet01:~$ sudo chmod 550 /opt/vault/unseal.sh
```
и сервис для его автостарта `/etc/systemd/system/vault-unseal.service`:
```bash
[Unit]
Description=Vault Auto Unseal Service
After=network.target
After=vault.service

[Service]
Environment="VAULT_ADDR=http://127.0.0.1:8201"
User=vault
ExecStart=/opt/vault/unseal.sh
Type=oneshot
RemainAfterExit=no

[Install]
WantedBy=multi-user.target
```
```bash
vagrant@devnet01:~$ sudo systemctl daemon-reload
vagrant@devnet01:~$ sudo systemctl enable vault-unseal
```
Тестовая перезагрузка (пришлось в скрипте автораспечатки добавить sleep, так как не успевал стартануть vault).  
И проверка работы с ранее созданным токеном:
```bash
vagrant@devnet01:~$ vault login
Token (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                s.wbjg59bpgKv5H4yno87E5blV
token_accessor       CxRLcUQAUzfoO0C6Af4Lzprw
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
# Активируем PKI для корневого CA
vagrant@devnet01:~$ vault secrets enable -path=pki_root_ca -description="lab.local Root CA" -max-lease-ttl="87600h" pki
# Выгружаем сертификат для корневого CA (понадобиться для добавления в доверенные на хостовой машине)
vagrant@devnet01:~$ vault write -format=json pki_root_ca/root/generate/internal common_name="lab.local" country="RU" locality="Moscow" organization="Home Lab Inc." ou="IT" ttl="87600h" | jq -r .data.certificate > lab.local_rootCA.pem
# Команду ниже так и не реализовал в рамках курсовой работы. Настраивает публикацию списков отзыва
vagrant@devnet01:~$ vault write pki_root_ca/config/urls issuing_certificates="http://vault.lab.local:8201/v1/pki_root_ca/ca" crl_distribution_points="http://vault.lab.local:8201/v1/pki_root_ca/crl"
# Активируем PKI для удостоверяющего CA
vagrant@devnet01:~$ vault secrets enable -path=pki_int_ca -description="lab.local Intermediate CA" -max-lease-ttl="87600h" pki
# Генерируем запрос на серт для удостоверяющего CA
vagrant@devnet01:~$ vault write -format=json pki_int_ca/intermediate/generate/internal common_name="vault.lab.local" country="RU" locality="Moscow" organization="Home Lab Inc." ou="IT" ttl="87600h" | jq -r '.data.csr' > lab.local_intCA.csr
# Отправляем запрос в root CA и получаем в ответ сертификат int CA
vagrant@devnet01:~$ vault write -format=json pki_root_ca/root/sign-intermediate csr=@lab.local_intCA.csr country="RU" locality="Moscow" organization="Home Lab Inc." ou="IT" ttl="87600h" format=pem_bundle | jq -r '.data.certificate' > lab.local_intCA.pem
# Публикуем подписанный сертификат 
vagrant@devnet01:~$ vault write pki_int_ca/intermediate/set-signed certificate=@lab.local_intCA.pem
# Публикуем URL’ы со списками отзыва
vagrant@devnet01:~$ vault write pki_int_ca/config/urls issuing_certificates="http://vault.lab.local:8201/v1/pki_int_ca/ca" crl_distribution_points="http://vault.lab.local:8201/v1/pki_int_ca/crl"
# Создаём роль для выдачи сертификатов серверов
vagrant@devnet01:~$ vault write pki_int_ca/roles/lab-dot-local-server country="RU" locality="Moscow" organization="Home Lab Inc." ou="IT" allowed_domains="lab.local" allow_subdomains=true max_ttl="43800h" key_bits="2048" key_type="rsa" allow_any_name=false allow_bare_domains=false allow_glob_domain=false allow_ip_sans=true allow_localhost=false client_flag=false server_flag=true enforce_hostnames=true key_usage="DigitalSignature,KeyEncipherment" ext_key_usage="ServerAuth" require_cn=true
# Создаем сертификат для веб-сервера на 1 месяц
vagrant@devnet01:~$ vault write -format=json pki_int_ca/issue/lab-dot-local-server common_name="nginx.lab.local" alt_names="nginx.lab.local" ttl="720h" > nginx.lab.local.crt
# Сохраняем в base64 формате
vagrant@devnet01:~$ cat nginx.lab.local.crt | jq -r .data.certificate > nginx.lab.local.pem
vagrant@devnet01:~$ cat nginx.lab.local.crt | jq -r .data.issuing_ca >> nginx.lab.local.pem
vagrant@devnet01:~$ cat lab.local_rootCA.pem >> nginx.lab.local.pem
vagrant@devnet01:~$ cat nginx.lab.local.crt | jq -r .data.private_key > nginx.lab.local.key
```