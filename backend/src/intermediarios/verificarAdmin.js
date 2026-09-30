// ============================================
// verificarAdmin.js — Middleware de acesso da equipe
// ============================================
// Usar depois de verificarToken. Libera só os e-mails listados na
// variável de ambiente ADMIN_EMAILS (separados por vírgula).

function verificarAdmin(req, res, next) {
  const admins = (process.env.ADMIN_EMAILS || '')
    .split(',')
    .map(e => e.trim().toLowerCase())
    .filter(Boolean);

  if (!admins.includes((req.usuario.email || '').toLowerCase())) {
    return res.status(403).json({
      erro: 'Acesso negado',
      mensagem: 'Esta conta não tem permissão de validador.'
    });
  }

  next();
}

module.exports = verificarAdmin;
