# 🚀 Deploy na Hostinger - Vortex Chacha

Este guia te ajudará a fazer deploy do Vortex Chacha na Hostinger, tanto em hospedagem compartilhada quanto em VPS.

## 📋 Pré-requisitos

- Conta na Hostinger (hospedagem compartilhada ou VPS)
- Acesso ao painel de controle da Hostinger
- Node.js instalado localmente (para preparar os arquivos)

## 🎯 Opção 1: Deploy em VPS (Recomendado)

### 1.1 Configurar VPS na Hostinger

1. **Acesse o painel da Hostinger**
2. **Vá para "VPS" → "Gerenciar"**
3. **Configure seu VPS:**
   - Escolha Ubuntu 20.04 ou superior
   - Mínimo: 1GB RAM, 1 vCPU
   - Recomendado: 2GB RAM, 2 vCPU

### 1.2 Conectar via SSH

```bash
# Conecte ao seu VPS
ssh root@seu-ip-do-vps

# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalar PM2 (gerenciador de processos)
sudo npm install -g pm2

# Instalar Nginx
sudo apt install nginx -y
```

### 1.3 Configurar o Projeto

```bash
# Criar diretório do projeto
mkdir /var/www/vortex-chacha
cd /var/www/vortex-chacha

# Fazer upload dos arquivos (via SCP ou Git)
# Se usando Git:
git clone https://github.com/seu-usuario/vortex-chacha.git .

# Instalar dependências
npm install

# Configurar variáveis de ambiente
cp .env.example .env
nano .env
```

### 1.4 Configurar Variáveis de Ambiente

```bash
# Editar arquivo .env
nano .env
```

```env
PORT=3000
JWT_SECRET=sua-chave-jwt-super-secreta
MONGODB_URI=sua-string-de-conexao-mongodb
OPENAI_API_KEY=sua-chave-api-openai
NODE_ENV=production
```

### 1.5 Configurar Nginx

```bash
# Criar configuração do Nginx
sudo nano /etc/nginx/sites-available/vortex-chacha
```

```nginx
server {
    listen 80;
    server_name seu-dominio.com www.seu-dominio.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
# Ativar o site
sudo ln -s /etc/nginx/sites-available/vortex-chacha /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# Configurar firewall
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```

### 1.6 Iniciar a Aplicação

```bash
# Iniciar com PM2
pm2 start server.js --name "vortex-chacha"

# Configurar PM2 para iniciar com o sistema
pm2 startup
pm2 save

# Verificar status
pm2 status
```

### 1.7 Configurar SSL (HTTPS)

```bash
# Instalar Certbot
sudo apt install certbot python3-certbot-nginx -y

# Obter certificado SSL
sudo certbot --nginx -d seu-dominio.com -d www.seu-dominio.com
```

## 🎯 Opção 2: Hospedagem Compartilhada

### 2.1 Preparar Arquivos

```bash
# No seu computador local
npm run build  # Se tiver script de build
# Ou apenas compactar os arquivos
```

### 2.2 Upload via File Manager

1. **Acesse o painel da Hostinger**
2. **Vá para "File Manager"**
3. **Navegue até `public_html`**
4. **Faça upload dos arquivos do projeto**

### 2.3 Configurar Node.js (se disponível)

Algumas hospedagens compartilhadas da Hostinger suportam Node.js:

1. **No painel da Hostinger:**
   - Vá para "Advanced" → "Node.js"
   - Ative o Node.js
   - Configure a versão (18.x ou superior)

2. **Configure o arquivo `package.json`:**
```json
{
  "scripts": {
    "start": "node server.js"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
```

### 2.4 Configurar Variáveis de Ambiente

1. **No painel da Hostinger:**
   - Vá para "Advanced" → "Environment Variables"
   - Adicione as variáveis:
     - `JWT_SECRET`
     - `MONGODB_URI`
     - `OPENAI_API_KEY`
     - `NODE_ENV=production`

### 2.5 Configurar Domínio

1. **No painel da Hostinger:**
   - Vá para "Domains" → "Manage"
   - Configure o domínio para apontar para `public_html`

## 🔧 Configurações Adicionais

### MongoDB Atlas (Recomendado)

1. **Crie uma conta no MongoDB Atlas**
2. **Crie um cluster gratuito**
3. **Configure Network Access (0.0.0.0/0)**
4. **Crie um usuário e obtenha a string de conexão**

### Variáveis de Ambiente Completas

```env
# Configurações do Servidor
PORT=3000
NODE_ENV=production

# Segurança
JWT_SECRET=sua-chave-jwt-super-secreta-aqui

# Banco de Dados
MONGODB_URI=mongodb+srv://usuario:senha@cluster.mongodb.net/vortex-chacha

# OpenAI
OPENAI_API_KEY=sk-sua-chave-api-openai

# Configurações Opcionais
CORS_ORIGIN=https://seu-dominio.com
SESSION_SECRET=outra-chave-secreta-para-sessoes
```

## 🚨 Solução de Problemas

### Erro de Porta em Uso
```bash
# Verificar processos na porta 3000
sudo lsof -i :3000

# Matar processo se necessário
sudo kill -9 PID_DO_PROCESSO
```

### Erro de Permissões
```bash
# Corrigir permissões
sudo chown -R $USER:$USER /var/www/vortex-chacha
sudo chmod -R 755 /var/www/vortex-chacha
```

### Logs da Aplicação
```bash
# Ver logs do PM2
pm2 logs vortex-chacha

# Ver logs do Nginx
sudo tail -f /var/log/nginx/error.log
```

### Reiniciar Serviços
```bash
# Reiniciar aplicação
pm2 restart vortex-chacha

# Reiniciar Nginx
sudo systemctl restart nginx
```

## 📊 Monitoramento

### PM2 Monitoring
```bash
# Ver estatísticas
pm2 monit

# Ver logs em tempo real
pm2 logs --lines 100
```

### Nginx Status
```bash
# Verificar status do Nginx
sudo systemctl status nginx

# Testar configuração
sudo nginx -t
```

## 🔒 Segurança

### Firewall (VPS)
```bash
# Configurar firewall básico
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw enable
```

### Atualizações Regulares
```bash
# Atualizar sistema regularmente
sudo apt update && sudo apt upgrade -y

# Atualizar Node.js
sudo npm update -g
```

## 📞 Suporte

Se encontrar problemas:

1. **Verifique os logs:** `pm2 logs` e `/var/log/nginx/error.log`
2. **Teste localmente:** Certifique-se que funciona no seu computador
3. **Suporte da Hostinger:** Use o chat ou tickets do painel
4. **Dev Chacha:** Para dúvidas técnicas específicas do projeto

## 🎉 Próximos Passos

Após o deploy bem-sucedido:

1. **Configure um domínio personalizado**
2. **Ative SSL/HTTPS**
3. **Configure backups automáticos**
4. **Monitore o desempenho**
5. **Configure alertas de uptime**

---

**💡 Dica:** Para VPS, recomendo usar o script de deploy automático que criamos. Para hospedagem compartilhada, o processo manual é mais adequado devido às limitações da plataforma. 