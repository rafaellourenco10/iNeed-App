// ============================================
// servidor.js — Ponto de entrada do backend iNeed
// ============================================
// Inicializa o Express, aplica middlewares e registra as rotas.

const express = require('express');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

// Importar rotas
const rotasAutenticacao = require('./rotas/rotasAutenticacao');
const rotasPrestadores = require('./rotas/rotasPrestadores');
const rotasPropostas = require('./rotas/rotasPropostas');
const rotasAvaliacoes = require('./rotas/rotasAvaliacoes');
const rotasNotificacoes = require('./rotas/rotasNotificacoes');
const rotasVerificacoes = require('./rotas/rotasVerificacoes');

const app = express();
// Em produção (Render) a porta vem via PORT, injetada pela plataforma.
const PORTA = process.env.PORT || process.env.PORTA || 3000;

// ============================================
// Middlewares Globais
// ============================================
app.use(cors());                    // Permitir requisições do app Flutter
// Limite maior que o padrão (100 KB) por causa das fotos de verificação em base64
app.use(express.json({ limit: '3mb' }));

// ============================================
// Rota de Saúde (Health Check)
// ============================================
app.get('/api/saude', (req, res) => {
  res.status(200).json({
    status: 'ok',
    mensagem: '🚀 Servidor iNeed está funcionando!',
    timestamp: new Date().toISOString()
  });
});

// ============================================
// Registrar Rotas
// ============================================
app.use('/api/auth', rotasAutenticacao);
app.use('/api/prestadores', rotasPrestadores);
app.use('/api/propostas', rotasPropostas);
app.use('/api/avaliacoes', rotasAvaliacoes);
app.use('/api/notificacoes', rotasNotificacoes);
app.use('/api/verificacoes', rotasVerificacoes);

// Página da equipe pra validar documentos dos prestadores
app.get('/admin', (req, res) => res.sendFile(path.join(__dirname, '../public/admin.html')));

// ============================================
// Middleware de Erro Global
// ============================================
app.use((erro, req, res, next) => {
  console.error('❌ Erro no servidor:', erro.message);
  res.status(500).json({
    erro: 'Erro interno do servidor',
    mensagem: erro.message
  });
});

// ============================================
// Iniciar Servidor
// ============================================
app.listen(PORTA, () => {
  console.log(`✅ Servidor iNeed rodando na porta ${PORTA}`);
  console.log(`📡 Health check: http://localhost:${PORTA}/api/saude`);
});
