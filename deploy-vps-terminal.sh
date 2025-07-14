#!/bin/bash

# 🚀 Script de Deploy para VPS Hostinger - Terminal do Navegador
# Autor: Dev Chacha
# Versão: 1.0

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Função para imprimir mensagens
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Vortex Chacha - Deploy VPS${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_header

# Verificar se está rodando como root
if [ "$EUID" -ne 0 ]; then
    print_error "Execute: sudo su"
    exit 1
fi

# Configurações
PROJECT_NAME="vortex-chacha"
PROJECT_DIR="/var/www/$PROJECT_NAME"
GIT_REPO="https://github.com/DevChaCha-2/vortex-chacha.git"
PORT=3000

# Solicitar informações
echo -e "${YELLOW}Configuração do Deploy:${NC}"
read -p "Digite seu domínio (ex: meusite.com): " DOMAIN
read -p "Digite sua chave JWT_SECRET: " JWT_SECRET
read -p "Digite sua string MongoDB: " MONGODB_URI
read -p "Digite sua OpenAI API Key: " OPENAI_API_KEY

print_message "Iniciando deploy do Vortex Chacha..."

# 1. Atualizar sistema
print_message "Atualizando sistema..."
apt update && apt upgrade -y

# 2. Instalar Node.js
print_message "Instalando Node.js..."
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
else
    print_message "Node.js já está instalado"
fi

# 3. Instalar PM2
print_message "Instalando PM2..."
if ! command -v pm2 &> /dev/null; then
    npm install -g pm2
else
    print_message "PM2 já está instalado"
fi

# 4. Instalar Nginx
print_message "Instalando Nginx..."
if ! command -v nginx &> /dev/null; then
    apt install nginx -y
else
    print_message "Nginx já está instalado"
fi

# 5. Criar diretório do projeto
print_message "Criando diretório do projeto..."
mkdir -p $PROJECT_DIR
cd $PROJECT_DIR

# 6. Clonar repositório
print_message "Clonando repositório..."
if [ -d ".git" ]; then
    git pull origin main
else
    git clone $GIT_REPO .
fi

# 7. Instalar dependências
print_message "Instalando dependências..."
npm install --production

# 8. Configurar arquivo .env
print_message "Configurando variáveis de ambiente..."
cat > .env << EOF
PORT=$PORT
JWT_SECRET=$JWT_SECRET
MONGODB_URI=$MONGODB_URI
OPENAI_API_KEY=$OPENAI_API_KEY
NODE_ENV=production
EOF

# 9. Configurar Nginx
print_message "Configurando Nginx..."
cat > /etc/nginx/sites-available/$PROJECT_NAME << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    location / {
        proxy_pass http://localhost:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }

    # Configurações de segurança
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
}
EOF

# Ativar site
ln -sf /etc/nginx/sites-available/$PROJECT_NAME /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Testar configuração do Nginx
nginx -t

# 10. Configurar firewall
print_message "Configurando firewall..."
ufw --force enable
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 'Nginx Full'

# 11. Iniciar aplicação com PM2
print_message "Iniciando aplicação com PM2..."
cd $PROJECT_DIR

# Parar aplicação se já estiver rodando
pm2 delete $PROJECT_NAME 2>/dev/null || true

# Iniciar aplicação
pm2 start server.js --name $PROJECT_NAME

# Configurar PM2 para iniciar com o sistema
pm2 startup
pm2 save

# 12. Reiniciar Nginx
print_message "Reiniciando Nginx..."
systemctl restart nginx
systemctl enable nginx

# 13. Configurar SSL (opcional)
echo ""
read -p "Deseja configurar SSL/HTTPS? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_message "Instalando Certbot..."
    apt install certbot python3-certbot-nginx -y
    
    print_message "Obtendo certificado SSL..."
    certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN
fi

# 14. Verificar status
print_message "Verificando status dos serviços..."
echo ""
echo -e "${BLUE}Status dos Serviços:${NC}"
echo "Nginx: $(systemctl is-active nginx)"
echo "PM2: $(pm2 list | grep $PROJECT_NAME | awk '{print $10}')"
echo ""
echo -e "${BLUE}Informações do Deploy:${NC}"
echo "Domínio: $DOMAIN"
echo "Porta: $PORT"
echo "Diretório: $PROJECT_DIR"
echo ""
echo -e "${GREEN}Deploy concluído com sucesso!${NC}"
echo ""
echo -e "${YELLOW}Próximos passos:${NC}"
echo "1. Acesse: http://$DOMAIN"
echo "2. Teste o chat"
echo "3. Configure backup se necessário"
echo ""
echo -e "${BLUE}Comandos úteis:${NC}"
echo "Ver logs: pm2 logs $PROJECT_NAME"
echo "Reiniciar: pm2 restart $PROJECT_NAME"
echo "Status: pm2 status"
echo "Nginx logs: tail -f /var/log/nginx/error.log" 