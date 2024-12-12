FROM ubuntu:latest

RUN apt-get update && apt-get install -y dnsutils bind9

#copiar arq pra dentro da img
COPY named.conf.local /etc/bind

COPY db.asa.br /etc/bind

#CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf"]
EXPOSE 53/tcp 
EXPOSE 53/udp
#63:63

#TODO CONTAINER DOCKER PRECISA DE UM PONTO DE ENTRADA/EXECUCAO PARA MANTER O CONTAINER 
#EM FUNCIONAMENTO
CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]
