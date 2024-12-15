
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
  docker network rm asa-network

  echo "Todos os contêineres foram parados e removidos."
}

show_menu() {
  echo "Escolha uma opção:"
  echo "1) Iniciar contêineres"
  echo "2) Parar contêineres"
  echo "3) Sair"
}


while true; do
  show_menu
  read -p "Opção: " choice

  case $choice in
    1)
      start_containers
      ;;
    2)
      stop_containers
      ;;
    3)
      echo "Saindo..."
      exit 0
      ;;
    *)
      echo "Opção inválida. Tente novamente."
      ;;
  esac

done
