#!/bin/bash

# 🚀 Script de Deploy para Hostinger VPS - Vortex Chacha
# Autor: Dev Chacha
# Versão: 1.0

set -e  # Para o script se houver erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
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
    echo -e "${BLUE}  Vortex Chacha - Deploy Hostinger${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Verificar se está rodando como root
if [ "$EUID" -ne 0 ]; then
    print_error "Este script deve ser executado como root (sudo)"
    exit 1
fi

print_header

# Variáveis de configuração
PROJECT_NAME="vortex-chacha"
PROJECT_DIR="/var/www/$PROJECT_NAME"
DOMAIN=""
GIT_REPO=""

# Solicitar informações do usuário
echo -e "${YELLOW}Configuração do Deploy:${NC}"
read -p "Digite o domínio (ex: meusite.com): " DOMAIN
read -p "Digite o repositório Git (ex: https://github.com/usuario/vortex-chacha.git): " GIT_REPO
read -p "Digite a porta da aplicação (padrão: 3000): " PORT
PORT=${PORT:-3000}

print_message "Iniciando deploy do Vortex Chacha..."

# 1. Atualizar sistema
print_message "Atualizando sistema..."
apt update && apt upgrade -y

# 2. Instalar dependências
print_message "Instalando dependências..."

# Node.js
if ! command -v node &> /dev/null; then
    print_message "Instalando Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
else
    print_message "Node.js já está instalado"
fi

# PM2
if ! command -v pm2 &> /dev/null; then
    print_message "Instalando PM2..."
    npm install -g pm2
else
    print_message "PM2 já está instalado"
fi

# Nginx
if ! command -v nginx &> /dev/null; then
    print_message "Instalando Nginx..."
    apt install nginx -y
else
    print_message "Nginx já está instalado"
fi

# 3. Criar diretório do projeto
print_message "Criando diretório do projeto..."
mkdir -p $PROJECT_DIR
cd $PROJECT_DIR

# 4. Clonar ou atualizar repositório
if [ -d ".git" ]; then
    print_message "Atualizando repositório existente..."
    git pull origin main
else
    print_message "Clonando repositório..."
    git clone $GIT_REPO .
fi

# 5. Instalar dependências do projeto
print_message "Instalando dependências do projeto..."
npm install --production

# 6. Configurar arquivo .env
print_message "Configurando variáveis de ambiente..."
if [ ! -f ".env" ]; then
    cp .env.example .env
    print_warning "Arquivo .env criado. Configure as variáveis de ambiente manualmente:"
    print_warning "nano $PROJECT_DIR/.env"
    print_warning "Variáveis necessárias:"
    print_warning "- JWT_SECRET"
    print_warning "- MONGODB_URI"
    print_warning "- OPENAI_API_KEY"
    print_warning "- NODE_ENV=production"
    print_warning "- PORT=$PORT"
else
    print_message "Arquivo .env já existe"
fi

# 7. Configurar Nginx
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

# 8. Configurar firewall
print_message "Configurando firewall..."
ufw --force enable
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 'Nginx Full'

# 9. Iniciar aplicação com PM2
print_message "Iniciando aplicação com PM2..."
cd $PROJECT_DIR

# Parar aplicação se já estiver rodando
pm2 delete $PROJECT_NAME 2>/dev/null || true

# Iniciar aplicação
pm2 start server.js --name $PROJECT_NAME

# Configurar PM2 para iniciar com o sistema
pm2 startup
pm2 save

# 10. Reiniciar Nginx
print_message "Reiniciando Nginx..."
systemctl restart nginx
systemctl enable nginx

# 11. Configurar SSL (opcional)
read -p "Deseja configurar SSL/HTTPS? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_message "Instalando Certbot..."
    apt install certbot python3-certbot-nginx -y
    
    print_message "Obtendo certificado SSL..."
    certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN
fi

# 12. Verificar status
print_message "Verificando status dos serviços..."
echo ""
echo -e "${BLUE}Status dos Serviços:${NC}"
echo "PM2 Status:"
pm2 status
echo ""
echo "Nginx Status:"
systemctl status nginx --no-pager -l
echo ""

# 13. Informações finais
print_message "Deploy concluído com sucesso! 🎉"
echo ""
echo -e "${BLUE}Informações Importantes:${NC}"
echo "• URL da aplicação: http://$DOMAIN"
echo "• Diretório do projeto: $PROJECT_DIR"
echo "• Logs da aplicação: pm2 logs $PROJECT_NAME"
echo "• Logs do Nginx: tail -f /var/log/nginx/error.log"
echo "• Reiniciar aplicação: pm2 restart $PROJECT_NAME"
echo "• Reiniciar Nginx: systemctl restart nginx"
echo ""
echo -e "${YELLOW}Próximos passos:${NC}"
echo "1. Configure as variáveis de ambiente em $PROJECT_DIR/.env"
echo "2. Teste a aplicação acessando http://$DOMAIN"
echo "3. Configure backups automáticos"
echo "4. Monitore o desempenho"
echo ""
echo -e "${GREEN}Para suporte técnico, chame o Dev Chacha! 💻${NC}"

# 14. Criar script de manutenção
cat > /usr/local/bin/vortex-maintenance << 'EOF'
#!/bin/bash
# Script de manutenção do Vortex Chacha

case "$1" in
    restart)
        pm2 restart vortex-chacha
        systemctl restart nginx
        echo "Serviços reiniciados"
        ;;
    logs)
        pm2 logs vortex-chacha --lines 50
        ;;
    status)
        pm2 status
        systemctl status nginx --no-pager -l
        ;;
    update)
        cd /var/www/vortex-chacha
        git pull origin main
        npm install --production
        pm2 restart vortex-chacha
        echo "Aplicação atualizada"
        ;;
    *)
        echo "Uso: vortex-maintenance {restart|logs|status|update}"
        exit 1
        ;;
esac
EOF

chmod +x /usr/local/bin/vortex-maintenance

print_message "Script de manutenção criado: vortex-maintenance"
print_message "Uso: vortex-maintenance {restart|logs|status|update}"

echo ""
echo -e "${GREEN}Deploy finalizado! O Vortex Chacha está rodando na Hostinger! 🚀${NC}" 