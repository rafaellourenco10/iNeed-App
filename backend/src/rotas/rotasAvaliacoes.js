// ============================================
// rotasAvaliacoes.js — Rotas de avaliações de serviço
// ============================================

const express = require('express');
const roteador = express.Router();
const verificarToken = require('../intermediarios/verificarToken');
const {
  criarAvaliacao,
  listarAvaliacoesPrestador
} = require('../controladores/controladorAvaliacoes');

// POST /api/avaliacoes (protegida — só o cliente dono da proposta)
roteador.post('/', verificarToken, criarAvaliacao);

// GET /api/avaliacoes/prestador/:idPrestador (pública)
roteador.get('/prestador/:idPrestador', listarAvaliacoesPrestador);

module.exports = roteador;
