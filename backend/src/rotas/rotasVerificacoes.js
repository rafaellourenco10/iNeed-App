// ============================================
// rotasVerificacoes.js — Rotas de verificação de perfil
// ============================================

const express = require('express');
const roteador = express.Router();
const verificarToken = require('../intermediarios/verificarToken');
const verificarAdmin = require('../intermediarios/verificarAdmin');
const {
  enviarVerificacao,
  minhaVerificacao,
  listarVerificacoes,
  obterArquivos,
  analisarVerificacao
} = require('../controladores/controladorVerificacoes');

// ───── Prestador ─────

// POST /api/verificacoes
roteador.post('/', verificarToken, enviarVerificacao);

// GET /api/verificacoes/minha
roteador.get('/minha', verificarToken, minhaVerificacao);

// ───── Equipe (página /admin) ─────

// GET /api/verificacoes?status=pendente
roteador.get('/', verificarToken, verificarAdmin, listarVerificacoes);

// GET /api/verificacoes/:uid/arquivos
roteador.get('/:uid/arquivos', verificarToken, verificarAdmin, obterArquivos);

// PATCH /api/verificacoes/:uid
roteador.patch('/:uid', verificarToken, verificarAdmin, analisarVerificacao);

module.exports = roteador;
