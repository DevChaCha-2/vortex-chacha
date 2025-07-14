const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const sqlite3 = require('sqlite3').verbose();
const OpenAI = require('openai');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Configuração do OpenAI
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// Conectar ao banco de dados SQLite
const db = new sqlite3.Database('./database.sqlite');

// Criar tabela de usuários se não existir
db.run(`CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)`);

// Middleware para verificar token JWT
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Token de acesso requerido' });
  }

  jwt.verify(token, process.env.JWT_SECRET || 'seu-jwt-secret', (err, user) => {
    if (err) return res.status(403).json({ error: 'Token inválido' });
    req.user = user;
    next();
  });
};

// Rotas principais
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.get('/login', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'login.html'));
});

app.get('/register', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'register.html'));
});

app.get('/chat', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'chat.html'));
});



// Rota de registro
app.post('/api/register', async (req, res) => {
  try {
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
      return res.status(400).json({ error: 'Todos os campos são obrigatórios' });
    }

    // Verificar se o usuário já existe
    db.get('SELECT * FROM users WHERE email = ? OR username = ?', [email, username], async (err, user) => {
      if (err) {
        return res.status(500).json({ error: 'Erro interno do servidor' });
      }

      if (user) {
        return res.status(400).json({ error: 'Usuário ou email já existe' });
      }

      // Hash da senha
      const hashedPassword = await bcrypt.hash(password, 10);

      // Inserir usuário no banco
      db.run('INSERT INTO users (username, email, password) VALUES (?, ?, ?)', 
        [username, email, hashedPassword], function(err) {
          if (err) {
            return res.status(500).json({ error: 'Erro ao criar usuário' });
          }

          const token = jwt.sign(
            { userId: this.lastID, username, email },
            process.env.JWT_SECRET || 'seu-jwt-secret',
            { expiresIn: '24h' }
          );

          res.json({
            message: 'Usuário criado com sucesso',
            token,
            user: { id: this.lastID, username, email }
          });
        });
    });
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Rota de login
app.post('/api/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email e senha são obrigatórios' });
  }

  db.get('SELECT * FROM users WHERE email = ?', [email], async (err, user) => {
    if (err) {
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }

    if (!user) {
      return res.status(400).json({ error: 'Usuário não encontrado' });
    }

    const isValidPassword = await bcrypt.compare(password, user.password);
    if (!isValidPassword) {
      return res.status(400).json({ error: 'Senha incorreta' });
    }

    const token = jwt.sign(
      { userId: user.id, username: user.username, email: user.email },
      process.env.JWT_SECRET || 'seu-jwt-secret',
      { expiresIn: '24h' }
    );

    res.json({
      message: 'Login realizado com sucesso',
      token,
      user: { id: user.id, username: user.username, email: user.email }
    });
  });
});

// Configuração do Vortex Chacha
const vortexChachaPrompt = `Você é o Vortex Chacha, um assistente altamente especializado criado por DevChacha.

PERSONALIDADE E CARACTERÍSTICAS:
- Especialista em tecnologia, programação e desenvolvimento
- Comunicação direta, clara e técnica
- Sempre fornece soluções práticas e testadas
- Mantém um tom profissional mas acessível
- Foco em resultados concretos e implementáveis

ESPECIALIDADES TÉCNICAS:
- Desenvolvimento Web (JavaScript, Node.js, React, Vue.js)
- Backend (Express, APIs REST, GraphQL)
- Bancos de dados (SQL, NoSQL, MongoDB, PostgreSQL)
- DevOps (Docker, CI/CD, Cloud Computing)
- Inteligência Artificial e Machine Learning
- Automação e scripts
- Arquitetura de software e design patterns

FORMA DE RESPONDER:
- Sempre em português brasileiro
- Forneça código funcional quando solicitado
- Explique o raciocínio por trás das soluções
- Sugira alternativas quando apropriado
- Seja preciso e evite respostas vagas
- Inclua exemplos práticos e implementações

ESTILO DE COMUNICAÇÃO:
- Use linguagem técnica apropriada
- Seja direto ao ponto
- Mantenha respostas organizadas e bem estruturadas
- Sempre teste mentalmente as soluções antes de apresentá-las

Se não souber algo específico, admita claramente e sugira onde encontrar a informação ou como investigar o problema.`;

// Rota do chat com IA (apenas Vortex Chacha)
app.post('/api/chat', authenticateToken, async (req, res) => {
  try {
    const { message } = req.body;

    if (!message) {
      return res.status(400).json({ error: 'Mensagem é obrigatória' });
    }

    if (!process.env.OPENAI_API_KEY) {
      return res.status(500).json({ error: 'Chave da API OpenAI não configurada' });
    }

    const completion = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      messages: [
        {
          role: "system",
          content: vortexChachaPrompt
        },
        {
          role: "user",
          content: message
        }
      ],
      max_tokens: 800,
      temperature: 0.7,
    });

    const aiResponse = completion.choices[0].message.content;
    
    // Adicionar mensagem de suporte no final de toda resposta da IA
    const responseWithSupport = `${aiResponse}\n\n---\n\n**💡 Caso tenha dificuldades, chame o Dev Chacha!**`;

    res.json({
      response: responseWithSupport,
      agent: "Vortex Chacha",
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('Erro na API OpenAI:', error);
    res.status(500).json({ 
      error: 'Erro ao processar mensagem com IA',
      details: error.message 
    });
  }
});

// Rota para verificar se o usuário está logado
app.get('/api/verify', authenticateToken, (req, res) => {
  res.json({ user: req.user });
});

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  console.log(`Acesse: http://localhost:${PORT}`);
}); 