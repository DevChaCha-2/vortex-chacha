#!/bin/bash

# 🚀 Script de Deploy para Hostinger Hospedagem Compartilhada - Vortex Chacha
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
    echo -e "${BLUE}  Vortex Chacha - Deploy Compartilhado${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_header

# Variáveis de configuração
PROJECT_NAME="vortex-chacha"
DOMAIN=""
GIT_REPO=""

# Solicitar informações do usuário
echo -e "${YELLOW}Configuração do Deploy:${NC}"
read -p "Digite o domínio (ex: meusite.com): " DOMAIN
read -p "Digite o repositório Git (ex: https://github.com/usuario/vortex-chacha.git): " GIT_REPO

print_message "Preparando arquivos para hospedagem compartilhada..."

# 1. Criar diretório temporário
TEMP_DIR="/tmp/$PROJECT_NAME-deploy"
mkdir -p $TEMP_DIR
cd $TEMP_DIR

# 2. Clonar repositório
print_message "Clonando repositório..."
git clone $GIT_REPO .

# 3. Instalar dependências localmente
print_message "Instalando dependências..."
npm install --production

# 4. Criar arquivo .env
print_message "Criando arquivo .env..."
cat > .env << EOF
# Configurações do Servidor
PORT=3000
NODE_ENV=production

# Segurança
JWT_SECRET=sua-chave-jwt-super-secreta-aqui

# Banco de Dados
MONGODB_URI=sua-string-de-conexao-mongodb

# OpenAI
OPENAI_API_KEY=sua-chave-api-openai

# Configurações Opcionais
CORS_ORIGIN=https://$DOMAIN
SESSION_SECRET=outra-chave-secreta-para-sessoes
EOF

# 5. Criar arquivo package.json otimizado
print_message "Otimizando package.json..."
cat > package.json << EOF
{
  "name": "vortex-chacha",
  "version": "1.0.0",
  "description": "Sistema de chat com IA especializado em tecnologia",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  },
  "dependencies": {
    "express": "^4.18.2",
    "mongoose": "^7.5.0",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.2",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1",
    "openai": "^4.0.0",
    "socket.io": "^4.7.2",
    "helmet": "^7.0.0",
    "express-rate-limit": "^6.10.0"
  },
  "keywords": ["chat", "ai", "openai", "nodejs", "express"],
  "author": "Dev Chacha",
  "license": "MIT"
}
EOF

# 6. Criar arquivo .htaccess para Apache
print_message "Criando arquivo .htaccess..."
cat > .htaccess << EOF
RewriteEngine On

# Redirecionar para HTTPS (se disponível)
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# Configurações de segurança
Header always set X-Frame-Options "SAMEORIGIN"
Header always set X-XSS-Protection "1; mode=block"
Header always set X-Content-Type-Options "nosniff"
Header always set Referrer-Policy "no-referrer-when-downgrade"

# Configurações de cache para arquivos estáticos
<FilesMatch "\.(css|js|png|jpg|jpeg|gif|ico|svg)$">
    ExpiresActive On
    ExpiresDefault "access plus 1 month"
    Header set Cache-Control "public, immutable"
</FilesMatch>

# Configurações de compressão
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
</IfModule>

# Configurações de segurança adicional
<IfModule mod_headers.c>
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
    Header always set Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'"
</IfModule>
EOF

# 7. Criar arquivo de configuração para Node.js
print_message "Criando configuração para Node.js..."
cat > node-config.json << EOF
{
  "app_name": "vortex-chacha",
  "app_url": "https://$DOMAIN",
  "app_port": 3000,
  "app_env": "production",
  "app_start": "node server.js"
}
EOF

# 8. Criar script de inicialização
print_message "Criando script de inicialização..."
cat > start.sh << 'EOF'
#!/bin/bash
# Script de inicialização para hospedagem compartilhada

echo "Iniciando Vortex Chacha..."
export NODE_ENV=production
export PORT=3000

# Verificar se o arquivo .env existe
if [ ! -f ".env" ]; then
    echo "Arquivo .env não encontrado. Criando..."
    cp .env.example .env
    echo "Configure as variáveis de ambiente no arquivo .env"
    exit 1
fi

# Iniciar aplicação
node server.js
EOF

chmod +x start.sh

# 9. Criar arquivo de instruções
print_message "Criando arquivo de instruções..."
cat > INSTRUCOES_DEPLOY.md << EOF
# 📋 Instruções de Deploy - Hostinger Hospedagem Compartilhada

## 🚀 Passos para Deploy

### 1. Upload dos Arquivos
1. Acesse o painel da Hostinger
2. Vá para "File Manager"
3. Navegue até \`public_html\`
4. Faça upload de TODOS os arquivos desta pasta

### 2. Configurar Node.js (se disponível)
1. No painel da Hostinger, vá para "Advanced" → "Node.js"
2. Ative o Node.js
3. Configure a versão: 18.x ou superior
4. Configure o arquivo de entrada: \`server.js\`

### 3. Configurar Variáveis de Ambiente
1. No painel da Hostinger, vá para "Advanced" → "Environment Variables"
2. Adicione as seguintes variáveis:
   - \`JWT_SECRET\`: sua-chave-jwt-super-secreta
   - \`MONGODB_URI\`: sua-string-de-conexao-mongodb
   - \`OPENAI_API_KEY\`: sua-chave-api-openai
   - \`NODE_ENV\`: production
   - \`PORT\`: 3000

### 4. Configurar Domínio
1. No painel da Hostinger, vá para "Domains" → "Manage"
2. Configure o domínio para apontar para \`public_html\`

### 5. Configurar SSL (HTTPS)
1. No painel da Hostinger, vá para "SSL"
2. Ative o SSL gratuito para seu domínio

## 🔧 Configurações Importantes

### MongoDB Atlas
1. Crie uma conta no MongoDB Atlas
2. Crie um cluster gratuito
3. Configure Network Access (0.0.0.0/0)
4. Crie um usuário e obtenha a string de conexão

### OpenAI API
1. Crie uma conta na OpenAI
2. Gere uma API key
3. Configure o limite de uso

## 🚨 Solução de Problemas

### Erro de Porta
- Verifique se a porta 3000 está disponível
- Configure uma porta alternativa se necessário

### Erro de Permissões
- Configure as permissões dos arquivos para 644
- Configure as permissões das pastas para 755

### Erro de Conexão com MongoDB
- Verifique se o IP da Hostinger está liberado no MongoDB Atlas
- Use 0.0.0.0/0 para liberar todos os IPs

## 📞 Suporte

Para suporte técnico:
- Suporte da Hostinger: Chat ou tickets do painel
- Dev Chacha: Para dúvidas específicas do projeto

## 🎉 Próximos Passos

Após o deploy bem-sucedido:
1. Teste a aplicação acessando https://$DOMAIN
2. Configure backups automáticos
3. Monitore o desempenho
4. Configure alertas de uptime

---

**💡 Dica:** Se a hospedagem compartilhada não suportar Node.js, considere migrar para um VPS da Hostinger.
EOF

# 10. Criar arquivo de configuração para PM2 (se disponível)
print_message "Criando configuração PM2..."
cat > ecosystem.config.js << EOF
module.exports = {
  apps: [{
    name: 'vortex-chacha',
    script: 'server.js',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    error_file: './logs/err.log',
    out_file: './logs/out.log',
    log_file: './logs/combined.log',
    time: true
  }]
};
EOF

# 11. Criar diretório de logs
mkdir -p logs

# 12. Criar arquivo de configuração para Nginx (se disponível)
print_message "Criando configuração Nginx..."
cat > nginx.conf << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    root /home/user/public_html;
    index index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location /api {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }

    location /socket.io {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# 13. Criar arquivo de configuração para Apache
print_message "Criando configuração Apache..."
cat > apache.conf << EOF
<VirtualHost *:80>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    DocumentRoot /home/user/public_html
    
    <Directory /home/user/public_html>
        AllowOverride All
        Require all granted
    </Directory>
    
    ProxyPreserveHost On
    ProxyPass /api http://localhost:3000/api
    ProxyPassReverse /api http://localhost:3000/api
    
    ProxyPass /socket.io http://localhost:3000/socket.io
    ProxyPassReverse /socket.io http://localhost:3000/socket.io
    
    ErrorLog \${APACHE_LOG_DIR}/vortex-chacha_error.log
    CustomLog \${APACHE_LOG_DIR}/vortex-chacha_access.log combined
</VirtualHost>
EOF

# 14. Criar arquivo de configuração para cPanel
print_message "Criando configuração cPanel..."
cat > cpanel-config.txt << EOF
# Configuração para cPanel/WHM

## 1. Configurar Node.js App
- Vá para "Setup Node.js App"
- App name: vortex-chacha
- Node.js version: 18.x
- Application mode: Production
- Application root: /home/user/public_html
- Application URL: https://$DOMAIN
- Application startup file: server.js

## 2. Configurar Environment Variables
- Vá para "Environment Variables"
- Adicione as variáveis:
  JWT_SECRET=sua-chave-jwt-super-secreta
  MONGODB_URI=sua-string-de-conexao-mongodb
  OPENAI_API_KEY=sua-chave-api-openai
  NODE_ENV=production
  PORT=3000

## 3. Configurar Cron Jobs (opcional)
- Vá para "Cron Jobs"
- Adicione: */5 * * * * cd /home/user/public_html && node server.js

## 4. Configurar SSL
- Vá para "SSL/TLS"
- Ative SSL para $DOMAIN

## 5. Configurar Domínio
- Vá para "Domains"
- Configure $DOMAIN para public_html
EOF

# 15. Criar arquivo de backup
print_message "Criando script de backup..."
cat > backup.sh << 'EOF'
#!/bin/bash
# Script de backup para hospedagem compartilhada

BACKUP_DIR="/home/user/backups"
DATE=$(date +%Y%m%d_%H%M%S)
PROJECT_NAME="vortex-chacha"

# Criar diretório de backup
mkdir -p $BACKUP_DIR

# Fazer backup dos arquivos
tar -czf $BACKUP_DIR/${PROJECT_NAME}_${DATE}.tar.gz \
    --exclude=node_modules \
    --exclude=logs \
    --exclude=.git \
    .

echo "Backup criado: $BACKUP_DIR/${PROJECT_NAME}_${DATE}.tar.gz"

# Manter apenas os últimos 5 backups
ls -t $BACKUP_DIR/${PROJECT_NAME}_*.tar.gz | tail -n +6 | xargs -r rm

echo "Backup concluído!"
EOF

chmod +x backup.sh

# 16. Criar arquivo de monitoramento
print_message "Criando script de monitoramento..."
cat > monitor.sh << 'EOF'
#!/bin/bash
# Script de monitoramento para hospedagem compartilhada

APP_NAME="vortex-chacha"
LOG_FILE="/home/user/logs/monitor.log"

# Verificar se a aplicação está rodando
if ! pgrep -f "node server.js" > /dev/null; then
    echo "$(date): Aplicação $APP_NAME não está rodando. Reiniciando..." >> $LOG_FILE
    cd /home/user/public_html
    nohup node server.js > /dev/null 2>&1 &
    echo "$(date): Aplicação $APP_NAME reiniciada" >> $LOG_FILE
else
    echo "$(date): Aplicação $APP_NAME está rodando normalmente" >> $LOG_FILE
fi

# Verificar uso de memória
MEMORY_USAGE=$(ps aux | grep "node server.js" | grep -v grep | awk '{print $4}')
echo "$(date): Uso de memória: $MEMORY_USAGE%" >> $LOG_FILE

# Limpar logs antigos (manter apenas últimos 1000 linhas)
tail -n 1000 $LOG_FILE > $LOG_FILE.tmp && mv $LOG_FILE.tmp $LOG_FILE
EOF

chmod +x monitor.sh

# 17. Informações finais
print_message "Preparação concluída! 🎉"
echo ""
echo -e "${BLUE}Arquivos criados em: $TEMP_DIR${NC}"
echo ""
echo -e "${YELLOW}Próximos passos:${NC}"
echo "1. Compacte todos os arquivos:"
echo "   cd $TEMP_DIR"
echo "   tar -czf vortex-chacha-shared.tar.gz *"
echo ""
echo "2. Faça upload do arquivo .tar.gz para o File Manager da Hostinger"
echo "3. Extraia os arquivos em public_html"
echo "4. Configure as variáveis de ambiente no painel"
echo "5. Ative o Node.js se disponível"
echo "6. Configure o domínio e SSL"
echo ""
echo -e "${GREEN}Arquivos importantes criados:${NC}"
echo "• INSTRUCOES_DEPLOY.md - Guia completo de deploy"
echo "• .env - Variáveis de ambiente (configure manualmente)"
echo "• .htaccess - Configurações Apache"
echo "• nginx.conf - Configurações Nginx"
echo "• apache.conf - Configurações Apache alternativas"
echo "• cpanel-config.txt - Configurações para cPanel"
echo "• start.sh - Script de inicialização"
echo "• backup.sh - Script de backup"
echo "• monitor.sh - Script de monitoramento"
echo ""
echo -e "${YELLOW}⚠️  Importante:${NC}"
echo "• Configure as variáveis de ambiente no painel da Hostinger"
echo "• Verifique se a hospedagem suporta Node.js"
echo "• Se não suportar, considere migrar para VPS"
echo ""
echo -e "${GREEN}Para suporte técnico, chame o Dev Chacha! 💻${NC}"

# 18. Criar arquivo de verificação
print_message "Criando script de verificação..."
cat > verify.sh << 'EOF'
#!/bin/bash
# Script de verificação para hospedagem compartilhada

echo "🔍 Verificando configuração do Vortex Chacha..."

# Verificar Node.js
if command -v node &> /dev/null; then
    echo "✅ Node.js instalado: $(node --version)"
else
    echo "❌ Node.js não encontrado"
fi

# Verificar NPM
if command -v npm &> /dev/null; then
    echo "✅ NPM instalado: $(npm --version)"
else
    echo "❌ NPM não encontrado"
fi

# Verificar arquivo .env
if [ -f ".env" ]; then
    echo "✅ Arquivo .env encontrado"
    echo "   Variáveis configuradas:"
    grep -E "^(JWT_SECRET|MONGODB_URI|OPENAI_API_KEY|NODE_ENV|PORT)=" .env | sed 's/=.*/=***/'
else
    echo "❌ Arquivo .env não encontrado"
fi

# Verificar dependências
if [ -d "node_modules" ]; then
    echo "✅ Dependências instaladas"
else
    echo "❌ Dependências não instaladas"
    echo "   Execute: npm install --production"
fi

# Verificar arquivo server.js
if [ -f "server.js" ]; then
    echo "✅ Arquivo server.js encontrado"
else
    echo "❌ Arquivo server.js não encontrado"
fi

# Verificar permissões
echo "📁 Verificando permissões..."
ls -la | head -10

echo ""
echo "🎯 Para iniciar a aplicação:"
echo "   node server.js"
echo ""
echo "🎯 Para verificar logs:"
echo "   tail -f logs/app.log"
EOF

chmod +x verify.sh

print_message "Script de verificação criado: verify.sh"
print_message "Execute: ./verify.sh para verificar a configuração"

echo ""
echo -e "${GREEN}Preparação para hospedagem compartilhada concluída! 🚀${NC}"
echo -e "${YELLOW}Lembre-se: Configure as variáveis de ambiente no painel da Hostinger!${NC}" 