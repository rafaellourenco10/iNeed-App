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
  atualizarProposta 
} = require('../controladores/controladorPropostas');

// POST /api/propostas (protegida — requer autenticação)
roteador.post('/', verificarToken, criarProposta);

// GET /api/propostas/:idPrestador
roteador.get('/:idPrestador', listarPropostas);

// PATCH /api/propostas/:id (protegida — requer autenticação)
roteador.patch('/:id', verificarToken, atualizarProposta);

module.exports = roteador;
