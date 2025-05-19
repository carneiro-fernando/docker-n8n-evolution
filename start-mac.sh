#!/bin/bash

# --------------------------------------------
# Inicialização do ambiente Docker no Mac/Linux
# --------------------------------------------

# 1. Verifica se o Docker está em execução
if ! docker info > /dev/null 2>&1; then
    echo "❌ O Docker não está em execução. Por favor, inicie o Docker Desktop e tente novamente."
    exit 1
fi

# 2. Verifica se a rede Docker personalizada existe, senão cria
REDE="rede_geral"
if ! docker network ls --filter "name=$REDE" --format "{{.Name}}" | grep -q "^${REDE}$"; then
    echo "🔧 Rede '$REDE' não encontrada. Criando..."
    if ! docker network create "$REDE"; then
        echo "❌ Erro ao criar a rede '$REDE'."
        exit 1
    fi
else
    echo "✅ Rede '$REDE' já existe."
fi

# 3. Verifica se o volume do Postgres existe e alerta sobre compatibilidade
VOLUME="postgres_data"
if docker volume ls --filter "name=$VOLUME" --format "{{.Name}}" | grep -q "^${VOLUME}$"; then
    echo "⚠️ Volume '$VOLUME' já existe. Se foi usado com uma versão anterior do PostgreSQL, pode haver problemas de compatibilidade."
    read -p "Deseja remover o volume '$VOLUME' para reinicializar o banco de dados? (s/N) " resposta
    if [[ "$resposta" =~ ^[sS] ]]; then
        echo "🗑️ Removendo volume '$VOLUME'..."
        if ! docker volume rm "$VOLUME"; then
            echo "❌ Erro ao remover o volume '$VOLUME'. Verifique manualmente."
            exit 1
        fi
    else
        echo "➡️ Continuando sem remover o volume. Pode haver falha se houver incompatibilidade."
    fi
fi

# 4. Solicita valores sensíveis ao usuário
read -p "Digite a nova senha do Postgres: " POSTGRES_PASSWORD
read -p "Digite o e-mail padrão do pgAdmin: " PGADMIN_DEFAULT_EMAIL
read -p "Digite a senha do Redis usado pelo n8n: " N8N_REDIS_PASSWORD

# Exporta as variáveis de ambiente para uso no Docker Compose
export POSTGRES_PASSWORD
export PGADMIN_DEFAULT_EMAIL
export N8N_REDIS_PASSWORD

# 5. Inicia os containers com Docker Compose
echo "🚀 Iniciando containers com Docker Compose..."
if ! docker-compose up -d; then
    echo "⚠️ Erro ao iniciar os containers. Tentando iniciar containers existentes..."
    if ! docker-compose start; then
        echo "❌ Falha ao iniciar containers. Verifique o status manualmente."
        exit 1
    fi
fi

# Aguarda alguns segundos para os serviços subirem
echo "⏳ Aguardando inicialização dos serviços..."
sleep 10

# 6. Exibe informações úteis
echo "-------------------------------------------"
echo "✅ Serviços iniciados com sucesso!"
echo ""
echo "🌐 Evolution API: http://localhost:8080"
echo "🔑 A chave da Evolution API foi omitida por segurança."
echo ""
echo "🌐 n8n: http://localhost:5678"
echo ""
echo "🧠 Redis usado pelo n8n:"
echo "    Host: host.docker.internal"
echo "    Porta: 6380"
echo "    Usuário: default"
echo "    Senha: $N8N_REDIS_PASSWORD"
echo "-------------------------------------------"
