# 🛠️ Projeto com N8N, PostgreSQL, Redis e Evolution API

Este projeto configura um ambiente de automação utilizando o N8N, Redis, PostgreSQL e a API Evolution, tudo via Docker.

## Requisitos

- Docker instalado e em execução
- Docker Compose (opcional)
- Windows, Mac ou Linux

## Como executar

### Windows

Abra o PowerShell nesta pasta e execute:

```
./start.ps1
```

### MacOS / Linux

```bash
chmod +x start-mac.sh
./start-mac.sh
```

Você será solicitado a fornecer:

- Senha do PostgreSQL
- E-mail do pgAdmin
- Senha do Redis (usado pelo n8n)

## Serviços disponíveis

| Serviço        | URL                     |
|----------------|--------------------------|
| Evolution API  | http://localhost:8080    |
| n8n            | http://localhost:5678    |

### Redis usado pelo n8n:
- Host: `host.docker.internal`
- Porta: `6380`
- Usuário: `default`
- Senha: conforme digitada no setup

## Segurança

- NUNCA envie seu `.env` real para o repositório.
- A chave da Evolution API está visível apenas nos scripts locais.

## Organização

| Arquivo         | Função                                 |
|-----------------|----------------------------------------|
| start.ps1       | Inicialização no Windows               |
| start-mac.sh    | Inicialização no Mac/Linux             |
| docker-compose.yaml | Orquestra os serviços Docker     |
| .env.example    | Modelo de variáveis de ambiente        |
| .gitignore      | Arquivos que não devem ser enviados    |

## Licença

MIT
