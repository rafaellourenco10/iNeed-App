// ============================================
// rotasAutenticacao.js — Rotas de autenticação
// ============================================
// Define as rotas de cadastro e login.

const express = require('express');
const roteador = express.Router();
const { 
  cadastrarCliente, 
  cadastrarPrestador, 
  loginUsuario 
} = require('../controladores/controladorAutenticacao');

// POST /api/auth/cadastro-cliente
roteador.post('/cadastro-cliente', cadastrarCliente);

// POST /api/auth/cadastro-prestador
roteador.post('/cadastro-prestador', cadastrarPrestador);

// POST /api/auth/login
roteador.post('/login', loginUsuario);

module.exports = roteador;
