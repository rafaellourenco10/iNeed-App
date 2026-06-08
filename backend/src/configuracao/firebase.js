// ============================================
// firebase.js — Configuração do Firebase Admin SDK
// ============================================
// Inicializa o Firebase Admin usando a chave de serviço.
// O app Flutter NÃO se conecta ao Firebase diretamente.
// Toda comunicação passa por esta API.

const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');
require('dotenv').config();

let db = null;
let auth = null;
let firebaseConfigurado = false;

const caminhoChave = process.env.CAMINHO_CHAVE_FIREBASE || './serviceAccountKey.json';
const caminhoAbsoluto = path.resolve(__dirname, '../../', caminhoChave);

try {
  if (fs.existsSync(caminhoAbsoluto)) {
    const contaServico = JSON.parse(fs.readFileSync(caminhoAbsoluto, 'utf-8'));

    admin.initializeApp({
      credential: admin.credential.cert(contaServico)
    });

    db = admin.firestore();
    auth = admin.auth();
    firebaseConfigurado = true;

    console.log('🔥 Firebase Admin SDK inicializado com sucesso!');
  } else {
    console.warn('⚠️  Firebase Admin SDK não configurado.');
    console.warn(`   Arquivo não encontrado: ${caminhoAbsoluto}`);
    console.warn('   Coloque o arquivo serviceAccountKey.json na pasta /backend');
    console.warn('   O servidor continuará rodando, mas as rotas do Firebase não funcionarão.');
  }
} catch (erro) {
  console.error('❌ Erro ao inicializar Firebase:', erro.message);
  console.warn('   O servidor continuará rodando sem o Firebase.');
}

module.exports = { admin, db, auth, firebaseConfigurado };
