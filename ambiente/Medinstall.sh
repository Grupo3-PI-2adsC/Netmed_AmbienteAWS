#!/bin/bash

clear

echo -e " $(tput setaf 6)" "
____ ____ ____ _ ____ ___ ____ _  _ ___ ____
|__| [__  [__  | [__   |  |___ |\ |  |  |___
|  | ___] ___] | ___]  |  |___ | \|  |  |___
"

echo -e "
███╗   ██╗███████╗████████╗███╗   ███╗███████╗██████╗
████╗  ██║██╔════╝╚══██╔══╝████╗ ████║██╔════╝██╔══██╗
██╔██╗ ██║█████╗     ██║   ██╔████╔██║█████╗  ██║  ██║
██║╚██╗██║██╔══╝     ██║   ██║╚██╔╝██║██╔══╝  ██║  ██║
██║ ╚████║███████╗   ██║   ██║ ╚═╝ ██║███████╗██████╔╝
╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝     ╚═╝╚══════╝╚═════╝
"

echo ""
echo ""
sleep 1
# Função para verificar e instalar pacotes necessários
verificar_e_instalar_pacotes() {
    # Verifica se o pacote whiptail está instalado
    if ! dpkg -s whiptail &> /dev/null; then
        echo "$(tput setaf 6)[MedBot]$(tput setaf 7): Aguarde um momento... atualizando pacotes"
        sudo apt update -y &> /dev/null
        sudo apt upgrade -y &> /dev/null
	echo "$(tpput setaf 6)[MedBot]$(tput setaf 7): instalando o visualizador da barra de progresso"
        sudo apt install whiptail -y &> /dev/null
    fi

    # Verifica se o pacote pv está instalado
    if ! dpkg -s pv &> /dev/null; then
        echo "$(tput setaf 6)[MedBot]$(tput setaf 7): Só mais um pouquinho..."
        sudo apt install pv -y &> /dev/null
    fi
}

# Função para exibir a barra de progresso
progress_bar() {
    local duration=$1
    local elapsed=0
    local total_blocks=30  # Total de blocos para completar a barra
    local percent=0

    echo -n "["
    while [ $elapsed -le $duration ]; do
        percent=$(( (elapsed * 100) / duration ))
        local filled_blocks=$(( (elapsed * total_blocks) / duration ))

        # Criar a barra de progresso preenchida
        local progress_bar=$(printf "%0.s_̲̅" $(seq 1 $filled_blocks))

        # Criar a barra de progresso vazia
        local empty_blocks=$((total_blocks - filled_blocks))
        local empty_bar=$(printf "%0.s " $(seq 1 $empty_blocks))

        # Exibir a barra de progresso com a porcentagem ao final
        echo -ne "${progress_bar}${empty_bar}] ${percent}%\r"

        elapsed=$((elapsed + 1))
        sleep 1
    done

    # Garantir que a barra termina em 100%
    local final_bar=$(printf "%0.s_̲̅" $(seq 1 $total_blocks))
    echo -ne "${final_bar}] 100%\n"
}

# Função para verificar se o Java está instalado
check_java() {
    if type -p java > /dev/null 2>&1; then
        echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Java está instalado."
        return 0
    else
        echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Java não está instalado. Vamos instalá-lo."
        return 1
    fi
}

# Função para verificar se o Docker está instalado
check_docker(){
    if type -p docker > /dev/null 2>&1; then
        echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Docker está instalado."
        return 0
    else
        echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Docker não está instalado, vamos instalá-lo"
        return 1
    fi
}

# Função para verificar se o Docker Compose está instalado
check_compose(){
    if type -p docker-compose > /dev/null 2>&1; then
        echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Compose está instalado"
        return 0
    else
        echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Compose não instalado, começando instalação"
        return 1
    fi
}

# Função para instalar o Java
install_java() {
    echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Instalando Java, aguarde ^.^"
    progress_bar 5
    sudo apt install openjdk-17-jre -y &> /dev/null
    echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Java instalado com sucesso."
}

# Função para instalar o Docker
install_docker() {
    echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Instalando Docker, aguarde ^.^"
    progress_bar 25
    sudo apt install docker.io -y &> /dev/null
    echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Docker instalado com sucesso."
}

# Função para instalar o Docker Compose
install_docker_compose() {
    echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Instalando Docker Compose, aguarde ^.^"
    progress_bar 25
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &> /dev/null
    sudo chmod +x /usr/local/bin/docker-compose
    echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Docker Compose instalado com sucesso."
}

# Função para dar "up" no Docker Compose
start_docker_compose() {
    echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Iniciando os serviços com Docker Compose, aguarde ^.^"
    progress_bar 10
    sudo docker build -t login-interativo . &> /dev/null 
    sudo docker-compose run login-interativo
    sudo docker run -it --rm login-interativo
    echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Serviços iniciados."
}
echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) verificando e instalando pacotes aguarde..."

verificar_e_instalar_pacotes &> /dev/null

echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Verificando se o Java está instalado..."
check_java || install_java

echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Preparando para instalar o Docker..."
check_docker || install_docker

echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Preparando para instalar o Docker Compose..."
check_compose || install_docker_compose

echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Iniciando os serviços com Docker Compose..."
start_docker_compose

echo "$(tput setaf 5)[MedBot]:$(tput setaf 7) Instalação concluída! Obrigado por usar o MedBot! ^.^"
