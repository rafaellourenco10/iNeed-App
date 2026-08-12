// ============================================
// controladorPrestadores.js — Lógica de prestadores
// ============================================
// Listagem, busca e detalhes dos prestadores de serviço.

const { db } = require('../configuracao/firebase');

// -----------------------------------------------
// GET /api/prestadores
// -----------------------------------------------
// Lista todos os prestadores com filtros opcionais
// Query params: ?especialidade=eletricista&valorMaximo=100
async function listarPrestadores(req, res) {
  try {
    if (!db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    let consulta = db.collection('usuarios').where('tipo', '==', 'prestador');

    // Filtro por especialidade
    const { especialidade, valorMaximo, excluirUid } = req.query;

    if (especialidade) {
      consulta = consulta.where('especialidade', '==', especialidade);
    }

    const snapshot = await consulta.get();
    let prestadores = [];

    snapshot.forEach((doc) => {
      const dados = doc.data();
      prestadores.push({
        uid: doc.id,
        ...dados
      });
    });

    // Filtro por valor máximo (aplicado em memória pois Firestore
    // não suporta filtros em campos diferentes sem índice composto)
    if (valorMaximo) {
      const valorMax = parseFloat(valorMaximo);
      prestadores = prestadores.filter(p =>
        p.valorHora && p.valorHora <= valorMax
      );
    }

    // Exclui o próprio usuário da lista — quem tem conta de cliente e
    // também de prestador não pode se ver como opção pra contratar
    // (não tem como atender a si mesmo)
    if (excluirUid) {
      prestadores = prestadores.filter(p => p.uid !== excluirUid);
    }

    res.status(200).json({
      mensagem: `${prestadores.length} prestador(es) encontrado(s).`,
      prestadores: prestadores
    });

  } catch (erro) {
    console.error('❌ Erro ao listar prestadores:', erro.message);
    res.status(500).json({
      erro: 'Erro ao buscar prestadores',
      mensagem: erro.message
    });
  }
}

// -----------------------------------------------
// GET /api/prestadores/:id
// -----------------------------------------------
// Retorna detalhes de um prestador específico
async function obterPrestador(req, res) {
  try {
    const { id } = req.params;

    if (!db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    const docPrestador = await db.collection('usuarios').doc(id).get();

    if (!docPrestador.exists) {
      return res.status(404).json({
        erro: 'Prestador não encontrado',
        mensagem: 'Nenhum prestador encontrado com este ID.'
      });
    }

    const dados = docPrestador.data();

    if (dados.tipo !== 'prestador') {
      return res.status(404).json({
        erro: 'Prestador não encontrado',
        mensagem: 'Este usuário não é um prestador de serviço.'
      });
    }

    res.status(200).json({
      mensagem: 'Prestador encontrado!',
      prestador: {
        uid: docPrestador.id,
        ...dados
      }
    });

  } catch (erro) {
    console.error('❌ Erro ao obter prestador:', erro.message);
    res.status(500).json({
      erro: 'Erro ao buscar prestador',
      mensagem: erro.message
    });
  }
}

module.exports = {
  listarPrestadores,
  obterPrestador
};
