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

// Em produção (Render) não há arquivo local — a credencial vem inteira
// numa variável de ambiente. Localmente, continua lendo o arquivo.
try {
  let contaServico;

  if (process.env.FIREBASE_SERVICE_ACCOUNT) {
    contaServico = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
  } else {
    const caminhoChave = process.env.CAMINHO_CHAVE_FIREBASE || './serviceAccountKey.json';
    const caminhoAbsoluto = path.resolve(__dirname, '../../', caminhoChave);

    if (fs.existsSync(caminhoAbsoluto)) {
      contaServico = JSON.parse(fs.readFileSync(caminhoAbsoluto, 'utf-8'));
    } else {
      console.warn('⚠️  Firebase Admin SDK não configurado.');
      console.warn(`   Arquivo não encontrado: ${caminhoAbsoluto}`);
      console.warn('   Coloque o arquivo serviceAccountKey.json na pasta /backend');
      console.warn('   (ou defina FIREBASE_SERVICE_ACCOUNT em produção)');
      console.warn('   O servidor continuará rodando, mas as rotas do Firebase não funcionarão.');
    }
  }

  if (contaServico) {
    admin.initializeApp({
      credential: admin.credential.cert(contaServico)
    });

    db = admin.firestore();
    auth = admin.auth();
    firebaseConfigurado = true;

    console.log('🔥 Firebase Admin SDK inicializado com sucesso!');
  }
} catch (erro) {
  console.error('❌ Erro ao inicializar Firebase:', erro.message);
  console.warn('   O servidor continuará rodando sem o Firebase.');
}

module.exports = { admin, db, auth, firebaseConfigurado };
