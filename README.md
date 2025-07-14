# 🚀 Vortex Chacha - Chat IA Terminal

Um sistema de chat com IA especializado em tecnologia e programação, com tema hacker/terminal.

## ✨ Características

- 🤖 **IA Especializada**: Vortex Chacha, assistente focado em tecnologia
- 🔐 **Sistema de Autenticação**: Registro, login e JWT
- 💬 **Chat em Tempo Real**: Interface moderna e responsiva
- 💾 **Histórico de Conversas**: Salva e gerencia conversas
- 🎨 **Tema Hacker**: Visual neon verde/azul com efeitos
- 📱 **Responsivo**: Funciona perfeitamente no mobile
- 🔒 **Seguro**: Autenticação JWT e validações

## 🛠️ Tecnologias

- **Backend**: Node.js, Express.js
- **Banco de Dados**: SQLite
- **Autenticação**: JWT, bcryptjs
- **IA**: OpenAI GPT-4
- **Frontend**: HTML5, CSS3, JavaScript
- **Markdown**: Suporte a código e formatação

## 🚀 Deploy Rápido

### Pré-requisitos
1. **Chave OpenAI**: https://platform.openai.com/api-keys
2. **Conta GitHub**: Para fazer upload do projeto

### Deploy no Render.com (RECOMENDADO)

1. **Faça upload** do projeto para o GitHub
2. **Acesse**: https://render.com
3. **Crie conta** gratuita
4. **Conecte** seu repositório
5. **Crie Web Service**:
   - **Name**: `vortex-chacha`
   - **Environment**: `Node`
   - **Build Command**: `npm install`
   - **Start Command**: `node server.js`

6. **Configure variáveis de ambiente**:
   ```
   JWT_SECRET=sua-chave-jwt-super-secreta-aqui
   OPENAI_API_KEY=sua-chave-da-api-openai-aqui
   PORT=10000
   ```

7. **Deploy** e aguarde ficar online!

### Deploy na Hostinger

#### VPS (Recomendado)
```bash
# Baixe o script de deploy
wget https://raw.githubusercontent.com/seu-usuario/vortex-chacha/main/deploy-hostinger.sh
chmod +x deploy-hostinger.sh
sudo ./deploy-hostinger.sh
```

#### Hospedagem Compartilhada
```bash
# Baixe o script de preparação
wget https://raw.githubusercontent.com/seu-usuario/vortex-chacha/main/deploy-hostinger-shared.sh
chmod +x deploy-hostinger-shared.sh
./deploy-hostinger-shared.sh
```

Veja os guias completos:
- [Guia Geral de Deploy](DEPLOY_GUIDE.md)
- [Deploy na Hostinger](DEPLOY_HOSTINGER.md)

### Gerar Chave JWT Segura
```bash
node generate-secret.js
```

## 📦 Instalação Local

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/vortex-chacha.git
cd vortex-chacha

# Instale as dependências
npm install

# Configure as variáveis de ambiente
cp env.example .env
# Edite o .env com suas chaves

# Execute o projeto
npm start
```

## 🔧 Configuração

### Variáveis de Ambiente (.env)
```env
PORT=3000
JWT_SECRET=sua-chave-jwt-super-secreta-aqui
OPENAI_API_KEY=sua-chave-da-api-openai-aqui
```

### Estrutura do Projeto
```
vortex-chacha/
├── public/           # Arquivos estáticos
│   ├── index.html    # Página inicial
│   ├── login.html    # Página de login
│   ├── register.html # Página de registro
│   ├── chat.html     # Interface do chat
│   ├── styles.css    # Estilos CSS
│   └── auth.js       # JavaScript de autenticação
├── server.js         # Servidor Express
├── package.json      # Dependências
├── database.sqlite   # Banco de dados
└── .env             # Variáveis de ambiente
```

## 🎯 Funcionalidades

### Sistema de Autenticação
- ✅ Registro de usuários
- ✅ Login com JWT
- ✅ Proteção de rotas
- ✅ Validação de dados

### Chat com IA
- ✅ Interface moderna
- ✅ Histórico de conversas
- ✅ Formatação markdown
- ✅ Blocos de código
- ✅ Responsivo mobile

### Gerenciamento de Conversas
- ✅ Salvar conversas
- ✅ Renomear conversas
- ✅ Excluir conversas
- ✅ Limpar histórico

## 🔒 Segurança

- **JWT**: Autenticação segura
- **bcrypt**: Hash de senhas
- **Validação**: Dados de entrada
- **HTTPS**: Em produção
- **Rate Limiting**: Proteção contra spam

## 📱 Responsividade

- **Desktop**: Interface completa
- **Tablet**: Adaptação automática
- **Mobile**: Menu hambúrguer, botões otimizados

## 🎨 Tema Hacker

- **Cores**: Neon verde (#0f0) e azul (#0ff)
- **Fonte**: Monospace (Courier New)
- **Efeitos**: Glow, glitch, animações
- **Background**: Gradiente escuro com linhas

## 🚨 Solução de Problemas

### Erro: "Cannot find module"
```bash
npm install
```

### Erro: "JWT_SECRET not defined"
Configure a variável no painel do deploy

### Erro: "OpenAI API Key not configured"
Adicione sua chave da API OpenAI

### Erro: "Port already in use"
Use `process.env.PORT` (já configurado)

## 💰 Custos

### Render.com
- **Gratuito**: 750 horas/mês
- **Pago**: $7/mês (ilimitado)

### Railway.app
- **Gratuito**: $5 crédito/mês
- **Pago**: $5/mês (ilimitado)

## 📞 Suporte

Se tiver problemas:
1. Verifique os logs do deploy
2. Confirme as variáveis de ambiente
3. Teste localmente primeiro
4. Consulte o `DEPLOY_GUIDE.md`

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 👨‍💻 Autor

**Dev Chacha**
- GitHub: [@devchacha](https://github.com/devchacha)

---

**💡 Caso tenha dificuldades, chame o Dev Chacha!** 