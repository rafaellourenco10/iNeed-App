// ============================================
// servidor.js — Ponto de entrada do backend iNeed
// ============================================
// Inicializa o Express, aplica middlewares e registra as rotas.

const express = require('express');
const cors = require('cors');
require('dotenv').config();

// Importar rotas
const rotasAutenticacao = require('./rotas/rotasAutenticacao');
const rotasPrestadores = require('./rotas/rotasPrestadores');
const rotasPropostas = require('./rotas/rotasPropostas');
const rotasAvaliacoes = require('./rotas/rotasAvaliacoes');
const rotasNotificacoes = require('./rotas/rotasNotificacoes');

const app = express();
// Em produção (Render) a porta vem via PORT, injetada pela plataforma.
const PORTA = process.env.PORT || process.env.PORTA || 3000;

// ============================================
// Middlewares Globais
// ============================================
app.use(cors());                    // Permitir requisições do app Flutter
app.use(express.json());            // Parsear JSON no corpo das requisições

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
