# PayPay

## TODO

- Tratar processamento de recorrência quando não há lançamentos para usar como exemplo;
- Avaliar inclusão de recorrência na edição de um lançamento;
- Adicionar campo "installment" (parcela) aos lançamentos;
- Adicionar teste para geração automática de lançamentos pela recorrência;
- Adicionar "dashboard" na tela inicial;
- "Lembrar" tela de origem quando navegar para criação/edição de lançamento. Deve voltar para tela de origem após confirmar ou cancelar a criação/edição de lançamento;

## Notas de instalação

1. Instalar `RVM`

```
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

curl -sSL https://get.rvm.io | bash

rvm install ruby-3.1.3

usermod -a -G rvm $USER
```

2. Instalar `phusionpassenger` & `NGINX`

```
sudo apt-get install nginx

# Install our PGP key and add HTTPS support for APT
sudo apt-get install -y dirmngr gnupg apt-transport-https ca-certificates curl

curl https://oss-binaries.phusionpassenger.com/auto-software-signing-gpg-key.txt | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/phusion.gpg >/dev/null

# Add our APT repository
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger jammy main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update

# Install Passenger + Nginx module
sudo apt-get install -y libnginx-mod-http-passenger

# enable the Passenger Nginx module and restart Nginx
if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then sudo ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi

sudo ls /etc/nginx/conf.d/mod-http-passenger.conf

# restart nginx
sudo service nginx restart

# check installation
sudo /usr/bin/passenger-config validate-install

# enable nginx service
sudo systemctl nginx enable
```

Configure o passenger abrindo o arquivo `/etc/nginx/conf.d/mod-http-passenger.conf` e
alterando a linha com `passenger_ruby` para apontar para o executável do ruby 3.1.3 instalado com o `RVM`.

`sudo service nginx restart`

3. Preparar para a aplicação

Crie um arquivo `/etc/profile.d/rails.sh` com o conteúdo:

```
export RAILS_ENV="production"
export RAILS_MASTER_KEY="1234567890" # substitua pelo conteúdo de master.key
```

4. Bundle

`bundle config set --local deployment 'true'`
`bundle config set --local without 'development:test'`

5. Configurar NGINX

/etc/nginx/sites-available/default

```
server {
  listen 80;
  listen [::]:80;

  server_name _;
  root /var/www/paypay/public;

  passenger_enabled on;
  passenger_app_env production;
  passenger_preload_bundler on;

  location /cable {
    passenger_app_group_name myapp_websocket;
    passenger_force_max_concurrent_requests_per_process 0;
  }

  # Allow uploads up to 100MB in size
  client_max_body_size 100m;

  location ~ ^/(assets|packs) {
    expires max;
    gzip_static on;
  }
}
```

6. Instalar nodejs

7. `bundle exec bin/rails assets:precompile`

8. Abrir porta 443 (https)

```
iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT
netfilter-persistent save
```
