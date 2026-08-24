// ============================================
// rotasPropostas.js — Rotas de propostas de serviço
// ============================================
// Define as rotas de criação, listagem e atualização de propostas.

const express = require('express');
const roteador = express.Router();
const verificarToken = require('../intermediarios/verificarToken');
const {
  criarProposta,
  listarPropostas,
  atualizarProposta,
  listarPropostasCliente
} = require('../controladores/controladorPropostas');

// POST /api/propostas (protegida — requer autenticação)
roteador.post('/', verificarToken, criarProposta);

// GET /api/propostas/cliente/minhas (protegida — propostas do próprio cliente)
roteador.get('/cliente/minhas', verificarToken, listarPropostasCliente);

// GET /api/propostas/:idPrestador (protegida — só o próprio prestador)
roteador.get('/:idPrestador', verificarToken, listarPropostas);

// PATCH /api/propostas/:id (protegida — requer autenticação + ser dono)
roteador.patch('/:id', verificarToken, atualizarProposta);

module.exports = roteador;
