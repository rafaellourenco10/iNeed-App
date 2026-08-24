// ============================================
// controladorNotificacoes.js — Central de notificações in-app
// ============================================
// Feed de eventos relevantes pro usuário (proposta recebida, aceita,
// recusada, concluída, avaliação recebida). Sem push nativo — só
// aparece quando o usuário abre o app.

const { db } = require('../configuracao/firebase');

// -----------------------------------------------
// Helper interno — usado por outros controladores pra registrar
// uma notificação quando um evento relevante acontece
// -----------------------------------------------
async function criarNotificacao({ idUsuario, tipo, titulo, mensagem, idProposta }) {
  if (!db || !idUsuario) return;
  try {
    await db.collection('notificacoes').add({
      idUsuario,
      tipo,
      titulo,
      mensagem,
      idProposta: idProposta || null,
      lida: false,
      criadaEm: new Date().toISOString()
    });
  } catch (erro) {
    // Notificação é auxiliar — se falhar, não deve derrubar a ação principal
    console.error('❌ Erro ao criar notificação:', erro.message);
  }
}

// -----------------------------------------------
// GET /api/notificacoes
// -----------------------------------------------
// Lista as notificações do usuário autenticado
async function listarNotificacoes(req, res) {
  try {
    if (!db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    const snapshot = await db.collection('notificacoes')
      .where('idUsuario', '==', req.usuario.uid)
      .get();

    const notificacoes = [];
    snapshot.forEach((doc) => {
      notificacoes.push({ id: doc.id, ...doc.data() });
    });
    notificacoes.sort((a, b) => (b.criadaEm || '').localeCompare(a.criadaEm || ''));

    res.status(200).json({
      mensagem: `${notificacoes.length} notificação(ões) encontrada(s).`,
      notificacoes
    });

  } catch (erro) {
    console.error('❌ Erro ao listar notificações:', erro.message);
    res.status(500).json({
      erro: 'Erro ao buscar notificações',
      mensagem: erro.message
    });
  }
}

// -----------------------------------------------
// PATCH /api/notificacoes/:id/lida
// -----------------------------------------------
// Marca uma notificação como lida (protegida — só o dono)
async function marcarLida(req, res) {
  try {
    const { id } = req.params;

    if (!db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    const docRef = db.collection('notificacoes').doc(id);
    const doc = await docRef.get();

    if (!doc.exists) {
      return res.status(404).json({
        erro: 'Notificação não encontrada',
        mensagem: 'Nenhuma notificação encontrada com este ID.'
      });
    }

    if (doc.data().idUsuario !== req.usuario.uid) {
      return res.status(403).json({
        erro: 'Acesso negado',
        mensagem: 'Você só pode marcar suas próprias notificações.'
      });
    }

    await docRef.update({ lida: true });

    res.status(200).json({ mensagem: 'Notificação marcada como lida.' });

  } catch (erro) {
    console.error('❌ Erro ao marcar notificação como lida:', erro.message);
    res.status(500).json({
      erro: 'Erro ao atualizar notificação',
      mensagem: erro.message
    });
  }
}

// -----------------------------------------------
// PATCH /api/notificacoes/marcar-todas-lidas
// -----------------------------------------------
// Marca todas as notificações do usuário como lidas
async function marcarTodasLidas(req, res) {
  try {
    if (!db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    const snapshot = await db.collection('notificacoes')
      .where('idUsuario', '==', req.usuario.uid)
      .where('lida', '==', false)
      .get();

    const lote = db.batch();
    snapshot.forEach((doc) => lote.update(doc.ref, { lida: true }));
    await lote.commit();

    res.status(200).json({
      mensagem: `${snapshot.size} notificação(ões) marcada(s) como lida(s).`
    });

  } catch (erro) {
    console.error('❌ Erro ao marcar notificações como lidas:', erro.message);
    res.status(500).json({
      erro: 'Erro ao atualizar notificações',
      mensagem: erro.message
    });
  }
}

module.exports = {
  criarNotificacao,
  listarNotificacoes,
  marcarLida,
  marcarTodasLidas
};
