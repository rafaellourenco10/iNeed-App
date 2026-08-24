// ============================================
// rotasNotificacoes.js — Rotas de notificações
// ============================================

const express = require('express');
const roteador = express.Router();
const verificarToken = require('../intermediarios/verificarToken');
const {
  listarNotificacoes,
  marcarLida,
  marcarTodasLidas
} = require('../controladores/controladorNotificacoes');

// GET /api/notificacoes (protegida — próprias notificações)
roteador.get('/', verificarToken, listarNotificacoes);

// PATCH /api/notificacoes/marcar-todas-lidas (protegida)
roteador.patch('/marcar-todas-lidas', verificarToken, marcarTodasLidas);

// PATCH /api/notificacoes/:id/lida (protegida — só o dono)
roteador.patch('/:id/lida', verificarToken, marcarLida);

module.exports = roteador;
