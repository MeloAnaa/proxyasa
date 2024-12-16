#!/bin/bash
start_containers() {
  echo "Iniciando os contêineres manualmente..."

  echo "Iniciando o contêiner DNS..."
  docker build -t dns ./dns
  docker run -d --name dns -p 53:53/udp -p 53:53/tcp dns

  echo "Iniciando o contêiner ASA Server 1..."
  docker build -t asa-server ./asa-server
  docker network create asa-network || true
  docker run -d --name asa-server --network asa-network asa-server

  echo "Iniciando o contêiner ASA Server 2..."
  docker run -d --name asa-server2 --network asa-network asa-server

  echo "Iniciando o contêiner Proxy..."
  docker build -t nginx-proxy ./proxy
  docker run -d --name nginx-proxy --network asa-network -p 80:80 nginx-proxy

  echo "Todos os contêineres foram iniciados."
}


stop_containers() {
  echo "Parando os contêineres manualmente..."

  docker stop nginx-proxy asa-server2 asa-server dns
  docker rm nginx-proxy asa-server2 asa-server dns
  docker network rm asa-network || true

  echo "Todos os contêineres foram parados e removidos."
}

remove_all() {
  echo "Excluindo contêineres, imagens e volumes..."

  # Parar e remover contêineres se ainda estiverem ativos
  docker stop nginx-proxy asa-server2 asa-server dns 2>/dev/null || true
  docker rm nginx-proxy asa-server2 asa-server dns 2>/dev/null || true

  docker network rm asa-network 2>/dev/null || true

  # Remover imagens
  docker rmi dns asa-server nginx-proxy 2>/dev/null || true

  # Limpar volumes órfãos
  docker volume prune -f

  echo "Todos os contêineres, imagens e volumes foram removidos."
}

show_menu() {
  echo "Escolha uma opção:"
  echo "1) Iniciar contêineres"
  echo "2) Parar contêineres"
  echo "3) Remover tudo (contêineres, imagens e volumes)"
  echo "4) Sair"
}

# Loop principal
while true; do
  show_menu
  read -p "Opção: " escolha

  case $escolha in
    1)
      start_containers
      ;;
    2)
      stop_containers
      ;;
    3)
      remove_all
      ;;
    4)
      echo "Saindo..."
      exit 0
      ;;
    *)
      echo "Opção inválida. Tente novamente."
      ;;
  esac
done

