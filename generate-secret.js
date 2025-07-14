const crypto = require('crypto');

// Gerar uma chave JWT segura de 64 bytes
const jwtSecret = crypto.randomBytes(64).toString('hex');

console.log('🔐 Chave JWT gerada com sucesso!');
console.log('📋 Copie esta chave e use como JWT_SECRET:');
console.log('');
console.log(jwtSecret);
console.log('');
console.log('⚠️  IMPORTANTE:');
console.log('- Guarde esta chave em local seguro');
console.log('- Use-a apenas em produção');
console.log('- Nunca commite esta chave no GitHub');
console.log('');
console.log('✅ Para usar, adicione no seu .env:');
console.log(`JWT_SECRET=${jwtSecret}`); 