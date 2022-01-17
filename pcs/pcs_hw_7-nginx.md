
Решил использовать стандартную страничку nginx для демонстрации.  
Для начала сократил конфиг убрав лишние строчки с комментариями:  
`vagrant@devnet01:~$ grep -v \# /etc/nginx/sites-available/default | sudo tee /etc/nginx/sites-available/default`

Скопировал ранее полученные сертификаты в новые расположения:  
```bash
vagrant@devnet01:~$ sudo cp ~vagrant/nginx.lab.local.pem /etc/ssl/certs/
vagrant@devnet01:~$ sudo cp ~vagrant/nginx.lab.local.key /etc/ssl/private/
```

Привёл конфиг nginx к виду:  
```bash
vagrant@devnet01:~$ cat /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    server_name nginx.lab.local;
    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    location / {
        try_files $uri $uri/ =404;
    }
    ssl_certificate /etc/ssl/certs/nginx.lab.local.pem;
    ssl_certificate_key /etc/ssl/private/nginx.lab.local.key;
    ssl_session_timeout 1d;
    ssl_session_cache shared:MozSSL:10m;  # about 40000 sessions
    ssl_session_tickets off;

    # curl https://ssl-config.mozilla.org/ffdhe2048.txt > /path/to/dhparam
    ssl_dhparam /etc/nginx/dhparam.pem;

    # intermediate configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;

    # HSTS (ngx_http_headers_module is required) (63072000 seconds)
    add_header Strict-Transport-Security "max-age=63072000" always;

    # OCSP stapling
    ssl_stapling on;
    ssl_stapling_verify on;

    # verify chain of trust of OCSP response using Root CA and Intermediate certs
    # ssl_trusted_certificate /path/to/root_CA_cert_plus_intermediates;

    # replace with the IP address of your resolver
    resolver 127.0.0.1;
}
```

Воспользовался помощью сервиса:  
[https://ssl-config.mozilla.org/](https://ssl-config.mozilla.org/)
