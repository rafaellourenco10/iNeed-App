// ============================================
// rotasAutenticacao.js — Rotas de autenticação
// ============================================
// Define as rotas de cadastro e login.

const express = require('express');
const roteador = express.Router();
const verificarToken = require('../intermediarios/verificarToken');
const {
  cadastrarCliente,
  cadastrarPrestador,
  loginUsuario,
  tornarPrestador
} = require('../controladores/controladorAutenticacao');

// POST /api/auth/cadastro-cliente
roteador.post('/cadastro-cliente', cadastrarCliente);

// POST /api/auth/cadastro-prestador
roteador.post('/cadastro-prestador', cadastrarPrestador);

// POST /api/auth/login
roteador.post('/login', loginUsuario);

// PATCH /api/auth/tornar-prestador (protegida — requer autenticação)
roteador.patch('/tornar-prestador', verificarToken, tornarPrestador);

module.exports = roteador;
