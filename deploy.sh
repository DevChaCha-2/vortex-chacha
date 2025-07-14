#!/bin/bash

echo "🚀 Vortex Chacha - Script de Deploy"
echo "=================================="
echo ""

# Verificar se o Node.js está instalado
if ! command -v node &> /dev/null; then
    echo "❌ Node.js não está instalado!"
    echo "📥 Instale em: https://nodejs.org/"
    exit 1
fi

# Verificar se o npm está instalado
if ! command -v npm &> /dev/null; then
    echo "❌ npm não está instalado!"
    exit 1
fi

echo "✅ Node.js e npm encontrados"
echo ""

# Instalar dependências
echo "📦 Instalando dependências..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ Erro ao instalar dependências!"
    exit 1
fi

echo "✅ Dependências instaladas"
echo ""

# Verificar se o arquivo .env existe
if [ ! -f ".env" ]; then
    echo "⚠️  Arquivo .env não encontrado!"
    echo "📝 Criando arquivo .env..."
    cp env.example .env
    echo "✅ Arquivo .env criado"
    echo ""
    echo "🔧 IMPORTANTE: Configure as variáveis no arquivo .env:"
    echo "   - JWT_SECRET (execute: node generate-secret.js)"
    echo "   - OPENAI_API_KEY (obtenha em: https://platform.openai.com/api-keys)"
    echo ""
    echo "📋 Exemplo de .env:"
    echo "   PORT=3000"
    echo "   JWT_SECRET=sua-chave-jwt-aqui"
    echo "   OPENAI_API_KEY=sua-chave-openai-aqui"
    echo ""
    read -p "Pressione Enter para continuar..."
fi

# Gerar chave JWT se solicitado
echo "🔐 Deseja gerar uma chave JWT segura? (s/n)"
read -p "Resposta: " generate_jwt

if [[ $generate_jwt == "s" || $generate_jwt == "S" ]]; then
    echo ""
    echo "🔐 Gerando chave JWT..."
    node generate-secret.js
    echo ""
fi

# Testar o projeto
echo "🧪 Testando o projeto..."
echo "📝 Para testar localmente, execute: npm start"
echo "🌐 Acesse: http://localhost:3000"
echo ""

# Informações sobre deploy
echo "🚀 Para fazer deploy:"
echo "1. 📤 Faça upload para o GitHub"
echo "2. 🌐 Use Render.com (recomendado):"
echo "   - Acesse: https://render.com"
echo "   - Conecte seu repositório"
echo "   - Configure as variáveis de ambiente"
echo "3. 📋 Consulte o DEPLOY_GUIDE.md para mais detalhes"
echo ""

echo "✅ Script concluído!"
echo "💡 Caso tenha dificuldades, chame o Dev Chacha!" 