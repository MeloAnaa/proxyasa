FROM ubuntu:latest

# Atualizar repositórios e instalar BIND9 e DNS utils
RUN apt update -y && apt install bind9 dnsutils -y

# Copiar arquivos de configuração
COPY named.conf.local /etc/bind/named.conf.local
COPY db.asa.br /etc/bind/db.asa.br

# Expor as portas do DNS
EXPOSE 53/tcp
EXPOSE 53/udp

# Comando para iniciar o BIND em primeiro plano
CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]
