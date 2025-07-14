@echo off
chcp 65001 >nul
echo.
echo ========================================
echo   Vortex Chacha - Deploy Hostinger VPS
echo ========================================
echo.

echo [INFO] Script de deploy automatizado para Hostinger VPS
echo.

REM Solicitar informações do usuário
set /p VPS_IP="Digite o IP do seu VPS: "
set /p VPS_USER="Digite o usuário (geralmente root): "
set /p DOMAIN="Digite seu domínio (ex: meusite.com): "
set /p GITHUB_USER="Digite seu usuário do GitHub (DevChaCha-2): "

echo.
echo [INFO] Iniciando deploy no VPS...
echo.

REM Conectar via SSH e executar o script de deploy
echo [INFO] Conectando ao VPS e executando deploy...
ssh %VPS_USER%@%VPS_IP% "bash -s" < deploy-hostinger.sh

echo.
echo [SUCCESS] Deploy concluído!
echo.
echo [INFO] Próximos passos:
echo 1. Configure as variáveis de ambiente no VPS
echo 2. Acesse seu domínio: http://%DOMAIN%
echo 3. Configure SSL se necessário
echo.
echo [INFO] Para acessar o VPS: ssh %VPS_USER%@%VPS_IP%
echo.

pause 