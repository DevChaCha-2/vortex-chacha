@echo off
echo 🚀 Vortex Chacha - Script de Deploy
echo ==================================
echo.

REM Verificar se o Node.js está instalado
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js não está instalado!
    echo 📥 Instale em: https://nodejs.org/
    pause
    exit /b 1
)

REM Verificar se o npm está instalado
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm não está instalado!
    pause
    exit /b 1
)

echo ✅ Node.js e npm encontrados
echo.

REM Instalar dependências
echo 📦 Instalando dependências...
npm install

if %errorlevel% neq 0 (
    echo ❌ Erro ao instalar dependências!
    pause
    exit /b 1
)

echo ✅ Dependências instaladas
echo.

REM Verificar se o arquivo .env existe
if not exist ".env" (
    echo ⚠️  Arquivo .env não encontrado!
    echo 📝 Criando arquivo .env...
    copy env.example .env
    echo ✅ Arquivo .env criado
    echo.
    echo 🔧 IMPORTANTE: Configure as variáveis no arquivo .env:
    echo    - JWT_SECRET (execute: node generate-secret.js)
    echo    - OPENAI_API_KEY (obtenha em: https://platform.openai.com/api-keys)
    echo.
    echo 📋 Exemplo de .env:
    echo    PORT=3000
    echo    JWT_SECRET=sua-chave-jwt-aqui
    echo    OPENAI_API_KEY=sua-chave-openai-aqui
    echo.
    pause
)

REM Gerar chave JWT se solicitado
echo 🔐 Deseja gerar uma chave JWT segura? (s/n)
set /p generate_jwt=Resposta: 

if /i "%generate_jwt%"=="s" (
    echo.
    echo 🔐 Gerando chave JWT...
    node generate-secret.js
    echo.
)

REM Testar o projeto
echo 🧪 Testando o projeto...
echo 📝 Para testar localmente, execute: npm start
echo 🌐 Acesse: http://localhost:3000
echo.

REM Informações sobre deploy
echo 🚀 Para fazer deploy:
echo 1. 📤 Faça upload para o GitHub
echo 2. 🌐 Use Render.com (recomendado):
echo    - Acesse: https://render.com
echo    - Conecte seu repositório
echo    - Configure as variáveis de ambiente
echo 3. 📋 Consulte o DEPLOY_GUIDE.md para mais detalhes
echo.

echo ✅ Script concluído!
echo 💡 Caso tenha dificuldades, chame o Dev Chacha!
pause 