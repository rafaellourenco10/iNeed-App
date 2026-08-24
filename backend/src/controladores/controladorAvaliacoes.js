// ============================================
// controladorAvaliacoes.js — Avaliações de serviços concluídos
// ============================================
// Cliente avalia (estrelas + comentário) um serviço já concluído;
// a avaliação aparece no perfil público do prestador.

const { db } = require('../configuracao/firebase');

// -----------------------------------------------
// POST /api/avaliacoes
// -----------------------------------------------
// Cria uma avaliação para uma proposta concluída (protegida — só o
// cliente dono da proposta pode avaliar, e só uma vez por serviço)
async function criarAvaliacao(req, res) {
  try {
    const { idProposta, estrelas, comentario, elogios } = req.body;

    if (!idProposta || !estrelas || estrelas < 1 || estrelas > 5) {
      return res.status(400).json({
        erro: 'Dados inválidos',
        mensagem: 'Informe idProposta e uma nota de 1 a 5 estrelas.'
      });
    }

    if (!db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    const docProposta = await db.collection('propostas').doc(idProposta).get();

    if (!docProposta.exists) {
      return res.status(404).json({
        erro: 'Proposta não encontrada',
        mensagem: 'Nenhuma proposta encontrada com este ID.'
      });
    }

    const proposta = docProposta.data();

    if (proposta.idCliente !== req.usuario.uid) {
      return res.status(403).json({
        erro: 'Acesso negado',
        mensagem: 'Você só pode avaliar serviços que você contratou.'
      });
    }

    if (proposta.status !== 'concluida') {
      return res.status(400).json({
        erro: 'Serviço não concluído',
        mensagem: 'Só é possível avaliar serviços concluídos.'
      });
    }

    if (proposta.avaliada) {
      return res.status(409).json({
        erro: 'Já avaliado',
        mensagem: 'Este serviço já foi avaliado.'
      });
    }

    const novaAvaliacao = {
      idProposta,
      idCliente: proposta.idCliente,
      nomeCliente: proposta.nomeCliente,
      idPrestador: proposta.idPrestador,
      estrelas,
      comentario: comentario || null,
      elogios: Array.isArray(elogios) ? elogios : [],
      criadaEm: new Date().toISOString()
    };

    const refAvaliacao = await db.collection('avaliacoes').add(novaAvaliacao);
    await docProposta.ref.update({ avaliada: true });

    // Recalcula a média e o total de avaliações do prestador
    const snapshotAvaliacoes = await db.collection('avaliacoes')
      .where('idPrestador', '==', proposta.idPrestador)
      .get();

    let soma = 0;
    let total = 0;
    snapshotAvaliacoes.forEach((doc) => {
      soma += doc.data().estrelas;
      total += 1;
    });
    const media = total > 0 ? soma / total : 0;

    await db.collection('usuarios').doc(proposta.idPrestador).update({
      avaliacao: Math.round(media * 10) / 10,
      totalServicos: total
    });

    res.status(201).json({
      mensagem: 'Avaliação enviada com sucesso!',
      avaliacao: { id: refAvaliacao.id, ...novaAvaliacao }
    });

  } catch (erro) {
    console.error('❌ Erro ao criar avaliação:', erro.message);
    res.status(500).json({
      erro: 'Erro ao criar avaliação',
      mensagem: erro.message
    });
  }
}

// -----------------------------------------------
// GET /api/avaliacoes/prestador/:idPrestador
// -----------------------------------------------
// Lista as avaliações recebidas por um prestador (pública — aparece
// no perfil dele pra qualquer cliente ver antes de contratar)
async function listarAvaliacoesPrestador(req, res) {
  try {
    const { idPrestador } = req.params;

    if (!db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    const snapshot = await db.collection('avaliacoes')
      .where('idPrestador', '==', idPrestador)
      .get();

    const avaliacoes = [];
    snapshot.forEach((doc) => {
      avaliacoes.push({ id: doc.id, ...doc.data() });
    });
    avaliacoes.sort((a, b) => (b.criadaEm || '').localeCompare(a.criadaEm || ''));

    res.status(200).json({
      mensagem: `${avaliacoes.length} avaliação(ões) encontrada(s).`,
      avaliacoes: avaliacoes
    });

  } catch (erro) {
    console.error('❌ Erro ao listar avaliações:', erro.message);
    res.status(500).json({
      erro: 'Erro ao buscar avaliações',
      mensagem: erro.message
    });
  }
}

module.exports = {
  criarAvaliacao,
  listarAvaliacoesPrestador
};
