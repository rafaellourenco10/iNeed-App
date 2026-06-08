// ============================================
// verificarToken.js — Middleware de autenticação
// ============================================
// Verifica se o token Firebase enviado no header Authorization é válido.
// Uso: Proteger rotas que exigem usuário autenticado.

const { auth } = require('../configuracao/firebase');

async function verificarToken(req, res, next) {
  try {
    const cabecalhoAuth = req.headers.authorization;

    if (!cabecalhoAuth || !cabecalhoAuth.startsWith('Bearer ')) {
      return res.status(401).json({
        erro: 'Não autorizado',
        mensagem: 'Token de autenticação não fornecido. Envie no header: Authorization: Bearer <token>'
      });
    }

    const token = cabecalhoAuth.split('Bearer ')[1];

    if (!auth) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase Auth não está configurado no servidor.'
      });
    }

    // Verificar o token com o Firebase Auth
    const tokenDecodificado = await auth.verifyIdToken(token);
    
    // Anexar dados do usuário à requisição
    req.usuario = {
      uid: tokenDecodificado.uid,
      email: tokenDecodificado.email,
      nome: tokenDecodificado.name || null
    };

    next();
  } catch (erro) {
    console.error('❌ Erro ao verificar token:', erro.message);
    return res.status(401).json({
      erro: 'Token inválido',
      mensagem: 'O token de autenticação é inválido ou expirou.'
    });
  }
}

module.exports = verificarToken;
