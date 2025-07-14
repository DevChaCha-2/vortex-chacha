// Função para mostrar mensagens
function showMessage(text, type = 'info') {
    const messageDiv = document.getElementById('message');
    if (!messageDiv) return;
    
    messageDiv.textContent = text;
    messageDiv.className = `message ${type} show`;
    
    // Ocultar mensagem após 5 segundos
    setTimeout(() => {
        messageDiv.classList.remove('show');
    }, 5000);
}

// Função para verificar se o usuário está logado
function isLoggedIn() {
    const token = localStorage.getItem('token');
    return token !== null;
}

// Função para obter informações do usuário
function getUserInfo() {
    const userStr = localStorage.getItem('user');
    return userStr ? JSON.parse(userStr) : null;
}

// Função para fazer logout
function logout() {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    window.location.href = '/';
}

// Função para fazer requisições autenticadas
async function authenticatedFetch(url, options = {}) {
    const token = localStorage.getItem('token');
    
    if (!token) {
        throw new Error('Token não encontrado');
    }
    
    const headers = {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
        ...options.headers
    };
    
    return fetch(url, {
        ...options,
        headers
    });
}

// Verificar se o usuário está logado ao carregar páginas protegidas
function checkAuthOnLoad() {
    const currentPath = window.location.pathname;
    const protectedPaths = ['/chat'];
    
    if (protectedPaths.includes(currentPath) && !isLoggedIn()) {
        window.location.href = '/login';
    }
}

// Formatar data e hora
function formatDateTime(date) {
    return new Date(date).toLocaleString('pt-BR', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

// Validar email
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// Validar senha
function isValidPassword(password) {
    return password.length >= 6;
}

// Executar verificação de autenticação ao carregar a página
document.addEventListener('DOMContentLoaded', checkAuthOnLoad); 