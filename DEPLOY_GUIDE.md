# 🚀 Guia Completo de Deploy - Vortex Chacha

## 📋 Pré-requisitos

### 1. Chave da API OpenAI
- Acesse: https://platform.openai.com/api-keys
- Crie uma nova chave de API
- **IMPORTANTE**: Guarde essa chave, você precisará dela

### 2. Conta no GitHub
- Faça upload do projeto para o GitHub
- Certifique-se de que o `.env` está no `.gitignore`

## 🌐 Opções de Deploy

### **Opção 1: Render.com (RECOMENDADO - GRÁTIS)**

#### Passo a Passo:
1. **Acesse**: https://render.com
2. **Crie conta** gratuita
3. **Conecte** seu repositório GitHub
4. **Crie um novo Web Service**
5. **Configure**:
   - **Name**: `vortex-chacha`
   - **Environment**: `Node`
   - **Build Command**: `npm install`
   - **Start Command**: `node server.js`
   - **Plan**: `Free`

#### Variáveis de Ambiente (Environment Variables):
```
JWT_SECRET=sua-chave-jwt-super-secreta-aqui
OPENAI_API_KEY=sua-chave-da-api-openai-aqui
PORT=10000
```

#### Vantagens:
- ✅ **Gratuito** para projetos pequenos
- ✅ **Deploy automático** do GitHub
- ✅ **SSL gratuito**
- ✅ **Domínio personalizado**
- ✅ **Muito fácil de configurar**

---

### **Opção 2: Railway.app (GRÁTIS)**

#### Passo a Passo:
1. **Acesse**: https://railway.app
2. **Conecte** com GitHub
3. **Deploy** diretamente do repositório
4. **Configure** as variáveis de ambiente

#### Variáveis de Ambiente:
```
JWT_SECRET=sua-chave-jwt-super-secreta-aqui
OPENAI_API_KEY=sua-chave-da-api-openai-aqui
```

---

### **Opção 3: Heroku (PAGO)**

#### Passo a Passo:
1. **Instale** Heroku CLI
2. **Login**: `heroku login`
3. **Crie app**: `heroku create vortex-chacha`
4. **Configure** variáveis:
   ```bash
   heroku config:set JWT_SECRET=sua-chave-jwt-super-secreta-aqui
   heroku config:set OPENAI_API_KEY=sua-chave-da-api-openai-aqui
   ```
5. **Deploy**: `git push heroku main`

---

### **Opção 4: Vercel (GRÁTIS)**

#### Passo a Passo:
1. **Acesse**: https://vercel.com
2. **Conecte** GitHub
3. **Importe** o projeto
4. **Configure** as variáveis de ambiente

---

## 🔧 Configurações Importantes

### 1. Gerar JWT Secret Seguro
```bash
# No terminal, execute:
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

### 2. Verificar .gitignore
Certifique-se de que seu `.gitignore` contém:
```
node_modules/
.env
database.sqlite
```

### 3. Testar Localmente
```bash
npm install
npm start
```

## 🚨 Problemas Comuns e Soluções

### Erro: "Cannot find module"
- **Solução**: Verifique se o `package.json` está correto
- **Solução**: Execute `npm install` no servidor

### Erro: "JWT_SECRET not defined"
- **Solução**: Configure a variável `JWT_SECRET` no painel do deploy

### Erro: "OpenAI API Key not configured"
- **Solução**: Configure a variável `OPENAI_API_KEY` no painel do deploy

### Erro: "Port already in use"
- **Solução**: Use `process.env.PORT` no `server.js` (já está configurado)

## 📱 Testando o Deploy

### 1. Verificar se está online
- Acesse a URL fornecida pelo serviço
- Deve aparecer a página inicial

### 2. Testar registro/login
- Tente criar uma conta
- Faça login

### 3. Testar chat
- Envie uma mensagem
- Verifique se a IA responde

## 🔒 Segurança em Produção

### 1. HTTPS
- Todos os serviços acima fornecem HTTPS automaticamente

### 2. Variáveis de Ambiente
- **NUNCA** commite o arquivo `.env`
- Use sempre as variáveis de ambiente do serviço

### 3. Rate Limiting
- Considere adicionar rate limiting para evitar spam

## 💰 Custos Estimados

### Render.com
- **Gratuito**: 750 horas/mês
- **Pago**: $7/mês para uso ilimitado

### Railway.app
- **Gratuito**: $5 de crédito/mês
- **Pago**: $5/mês para uso ilimitado

### Heroku
- **Pago**: $7/mês (Eco Dyno)

### Vercel
- **Gratuito**: 100GB de banda/mês
- **Pago**: $20/mês para uso ilimitado

## 🎯 Recomendação Final

**Use o Render.com** - É gratuito, fácil de configurar e muito confiável para projetos como o seu!

## 📞 Suporte

Se tiver problemas:
1. Verifique os logs do deploy
2. Confirme se todas as variáveis estão configuradas
3. Teste localmente primeiro
4. Consulte a documentação do serviço escolhido 