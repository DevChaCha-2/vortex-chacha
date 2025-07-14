# 🚀 Deploy na Hostinger - Hospedagem Compartilhada

## 📋 Pré-requisitos

- Conta na Hostinger com hospedagem compartilhada
- Acesso ao painel de controle
- Node.js habilitado (verificar disponibilidade)

## 🎯 Passo a Passo

### 1. Preparar Arquivos Localmente

```bash
# No seu computador
npm install --production
```

### 2. Compactar Arquivos

Crie um arquivo ZIP com:
- `server.js`
- `package.json`
- `package-lock.json`
- `public/` (pasta completa)
- `.env.example`
- `README.md`

### 3. Upload via File Manager

1. **Acesse o painel da Hostinger**
2. **Vá para "File Manager"**
3. **Navegue até `public_html`**
4. **Faça upload do arquivo ZIP**
5. **Extraia o ZIP**

### 4. Configurar Node.js

1. **No painel da Hostinger:**
   - Vá para "Advanced" → "Node.js"
   - Ative o Node.js
   - Configure versão 18.x ou superior

### 5. Configurar Variáveis de Ambiente

1. **No painel da Hostinger:**
   - Vá para "Advanced" → "Environment Variables"
   - Adicione:
     ```
     JWT_SECRET=sua-chave-jwt-super-secreta
     MONGODB_URI=sua-string-mongodb
     OPENAI_API_KEY=sua-chave-openai
     NODE_ENV=production
     PORT=3000
     ```

### 6. Configurar Domínio

1. **No painel da Hostinger:**
   - Vá para "Domains" → "Manage"
   - Configure o domínio para apontar para `public_html`

### 7. Testar Aplicação

Acesse: `http://seu-dominio.com`

## ⚠️ Limitações da Hospedagem Compartilhada

- Sem acesso SSH
- Sem PM2 (gerenciador de processos)
- Sem Nginx personalizado
- Limitações de recursos
- Sem SSL personalizado

## 🎯 Recomendação

**Para melhor performance e controle, considere migrar para VPS.** 