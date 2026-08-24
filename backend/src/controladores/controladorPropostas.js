// ============================================
// controladorPropostas.js — Lógica de propostas de serviço
// ============================================
// CRUD de propostas: criar, listar, aceitar e recusar.

const { db } = require('../configuracao/firebase');

// -----------------------------------------------
// POST /api/propostas
// -----------------------------------------------
// Cliente envia uma proposta de serviço a um prestador
async function criarProposta(req, res) {
  try {
    const { 
      idPrestador, 
      titulo, 
      descricao, 
      valor, 
      data, 
      horario, 
      endereco 
    } = req.body;

    // O ID do cliente vem do token verificado pelo middleware
    const idCliente = req.usuario.uid;
    const nomeCliente = req.usuario.nome;

    // Validações básicas
    if (!idPrestador || !titulo || !valor) {
      return res.status(400).json({
        erro: 'Dados incompletos',
        mensagem: 'ID do prestador, título e valor são obrigatórios.'
      });
    }

    if (!db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    // Verificar se o prestador existe
    const docPrestador = await db.collection('usuarios').doc(idPrestador).get();
    if (!docPrestador.exists || docPrestador.data().tipo !== 'prestador') {
      return res.status(404).json({
        erro: 'Prestador não encontrado',
        mensagem: 'O prestador informado não existe.'
      });
    }

    // Criar a proposta no Firestore
    const novaProposta = {
      idCliente: idCliente,
      nomeCliente: nomeCliente || 'Cliente',
      emailCliente: req.usuario.email,
      idPrestador: idPrestador,
      nomePrestador: docPrestador.data().nome,
      telefonePrestador: docPrestador.data().telefone || null,
      especialidadePrestador: docPrestador.data().especialidade || null,
      titulo: titulo,
      descricao: descricao || null,
      valor: parseFloat(valor),
      data: data || null,
      horario: horario || null,
      endereco: endereco || null,
      status: 'pendente', // pendente, aceita, recusada, em_andamento, concluida
      criadaEm: new Date().toISOString(),
      atualizadaEm: new Date().toISOString()
    };

    const docRef = await db.collection('propostas').add(novaProposta);

    res.status(201).json({
      mensagem: 'Proposta enviada com sucesso!',
      proposta: {
        id: docRef.id,
        ...novaProposta
      }
    });

  } catch (erro) {
    console.error('❌ Erro ao criar proposta:', erro.message);
    res.status(500).json({
      erro: 'Erro ao enviar proposta',
      mensagem: erro.message
    });
  }
}

// -----------------------------------------------
// GET /api/propostas/:idPrestador
// -----------------------------------------------
// Lista as propostas recebidas por um prestador (protegida — só o
// próprio prestador pode ver suas propostas, evita vazar dados de
// clientes pra qualquer um que souber o uid de um prestador)
async function listarPropostas(req, res) {
  try {
    const { idPrestador } = req.params;
    const { status } = req.query;

    if (idPrestador !== req.usuario.uid) {
      return res.status(403).json({
        erro: 'Acesso negado',
        mensagem: 'Você só pode ver as próprias propostas.'
      });
    }

    if (!db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    // Sem orderBy no Firestore (evita exigir índice composto pra
    // where+orderBy em campos diferentes) — ordena em memória depois.
    let consulta = db.collection('propostas')
      .where('idPrestador', '==', idPrestador);

    // Filtro opcional por status
    if (status) {
      consulta = db.collection('propostas')
        .where('idPrestador', '==', idPrestador)
        .where('status', '==', status);
    }

    const snapshot = await consulta.get();
    const propostas = [];

    snapshot.forEach((doc) => {
      propostas.push({
        id: doc.id,
        ...doc.data()
      });
    });

    propostas.sort((a, b) => (b.criadaEm || '').localeCompare(a.criadaEm || ''));

    res.status(200).json({
      mensagem: `${propostas.length} proposta(s) encontrada(s).`,
      propostas: propostas
    });

  } catch (erro) {
    console.error('❌ Erro ao listar propostas:', erro.message);
    res.status(500).json({
      erro: 'Erro ao buscar propostas',
      mensagem: erro.message
    });
  }
}

// -----------------------------------------------
// PATCH /api/propostas/:id
// -----------------------------------------------
// Atualiza o status de uma proposta (aceitar/recusar)
async function atualizarProposta(req, res) {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const statusValidos = ['aceita', 'recusada', 'em_andamento', 'concluida'];

    if (!status || !statusValidos.includes(status)) {
      return res.status(400).json({
        erro: 'Status inválido',
        mensagem: `Status deve ser um dos seguintes: ${statusValidos.join(', ')}`
      });
    }

    if (!db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    const docRef = db.collection('propostas').doc(id);
    const docProposta = await docRef.get();

    if (!docProposta.exists) {
      return res.status(404).json({
        erro: 'Proposta não encontrada',
        mensagem: 'Nenhuma proposta encontrada com este ID.'
      });
    }

    if (docProposta.data().idPrestador !== req.usuario.uid) {
      return res.status(403).json({
        erro: 'Acesso negado',
        mensagem: 'Você só pode atualizar propostas endereçadas a você.'
      });
    }

    await docRef.update({
      status: status,
      atualizadaEm: new Date().toISOString()
    });

    res.status(200).json({
      mensagem: `Proposta ${status} com sucesso!`,
      proposta: {
        id: id,
        status: status
      }
    });

  } catch (erro) {
    console.error('❌ Erro ao atualizar proposta:', erro.message);
    res.status(500).json({
      erro: 'Erro ao atualizar proposta',
      mensagem: erro.message
    });
  }
}

// -----------------------------------------------
// GET /api/propostas/cliente/minhas
// -----------------------------------------------
// Lista as propostas enviadas pelo cliente autenticado
async function listarPropostasCliente(req, res) {
  try {
    if (!db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    const snapshot = await db.collection('propostas')
      .where('idCliente', '==', req.usuario.uid)
      .get();

    const propostas = [];
    snapshot.forEach((doc) => {
      propostas.push({
        id: doc.id,
        ...doc.data()
      });
    });

    propostas.sort((a, b) => (b.criadaEm || '').localeCompare(a.criadaEm || ''));

    res.status(200).json({
      mensagem: `${propostas.length} proposta(s) encontrada(s).`,
      propostas: propostas
    });

  } catch (erro) {
    console.error('❌ Erro ao listar propostas do cliente:', erro.message);
    res.status(500).json({
      erro: 'Erro ao buscar propostas',
      mensagem: erro.message
    });
  }
}

module.exports = {
  criarProposta,
  listarPropostas,
  atualizarProposta,
  listarPropostasCliente
};
