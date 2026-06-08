// ============================================
// rotasPrestadores.js — Rotas de prestadores
// ============================================
// Define as rotas de listagem e detalhes dos prestadores.

const express = require('express');
const roteador = express.Router();
const { 
  listarPrestadores, 
  obterPrestador 
} = require('../controladores/controladorPrestadores');

// GET /api/prestadores
roteador.get('/', listarPrestadores);

// GET /api/prestadores/:id
roteador.get('/:id', obterPrestador);

module.exports = roteador;
