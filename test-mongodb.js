// Teste de conexão MongoDB Atlas
const { MongoClient } = require('mongodb');

async function testConnection() {
    const uri = "mongodb+srv://vortex-chacha:SUA_SENHA_AQUI@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority";
    
    try {
        console.log('🔌 Testando conexão com MongoDB...');
        
        const client = new MongoClient(uri);
        await client.connect();
        
        console.log('✅ Conexão estabelecida com sucesso!');
        
        // Testar criação de banco
        const db = client.db('vortex-chacha');
        const collection = db.collection('test');
        
        // Inserir documento de teste
        await collection.insertOne({
            test: true,
            message: 'Conexão funcionando!',
            timestamp: new Date()
        });
        
        console.log('✅ Banco de dados criado com sucesso!');
        console.log('✅ Coleção de teste criada com sucesso!');
        
        // Limpar documento de teste
        await collection.deleteOne({ test: true });
        
        await client.close();
        console.log('✅ Teste concluído com sucesso!');
        
    } catch (error) {
        console.error('❌ Erro na conexão:', error.message);
        console.log('\n🔧 Verifique:');
        console.log('1. Se a string de conexão está correta');
        console.log('2. Se o usuário e senha estão corretos');
        console.log('3. Se o IP está liberado no Network Access');
    }
}

testConnection(); 