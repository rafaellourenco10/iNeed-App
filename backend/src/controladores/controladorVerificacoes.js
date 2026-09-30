// ============================================
// controladorVerificacoes.js — Verificação de perfil do prestador
// ============================================
// O prestador envia foto de um documento (RG/CNH) e de um comprovante de
// qualificação. A equipe analisa pela página /admin e aprova ou recusa.
// Aprovado → usuarios/{uid}.verificado = true (selo nos cards e no perfil).
//
// Estrutura no Firestore:
//   verificacoes/{uid}                  → status da análise (sem imagens)
//   verificacoes/{uid}/arquivos/{tipo}  → imagem em base64 (um doc por
//                                         arquivo, pra não estourar 1 MB)

const { db } = require('../configuracao/firebase');
const { criarNotificacao } = require('./controladorNotificacoes');

const TIPOS_ARQUIVO = ['documentoFoto', 'comprovante'];

// ponytail: imagem em base64 no Firestore (sem plano Blaze não dá pra usar
// o Storage). Limite de ~600 KB por imagem por causa do teto de 1 MB por
// documento. Se um dia ativar o Blaze, migrar pro Firebase Storage.
const TAMANHO_MAXIMO_BYTES = 600 * 1024;

// Confere que o base64 é mesmo uma imagem JPEG ou PNG (pelos bytes
// iniciais, não pelo que o cliente diz) e que cabe no limite.
function validarImagem(base64) {
  if (typeof base64 !== 'string' || !base64) return 'Arquivo não enviado.';

  const bytes = Buffer.from(base64, 'base64');
  if (bytes.length > TAMANHO_MAXIMO_BYTES) {
    return 'Imagem muito grande. Tente uma foto com menos resolução.';
  }

  const ehJpeg = bytes[0] === 0xff && bytes[1] === 0xd8 && bytes[2] === 0xff;
  const ehPng = bytes.subarray(0, 4).toString('hex') === '89504e47';
  if (!ehJpeg && !ehPng) return 'Formato inválido. Envie uma foto (JPG ou PNG).';

  return null;
}

function servicoIndisponivel(res) {
  return res.status(503).json({
    erro: 'Serviço indisponível',
    mensagem: 'Firebase não está configurado.'
  });
}

// -----------------------------------------------
// POST /api/verificacoes
// -----------------------------------------------
// Prestador envia os dois arquivos. Reenvio é permitido enquanto não
// estiver aprovado (ex: depois de uma recusa) — substitui os anteriores.
async function enviarVerificacao(req, res) {
  try {
    if (!db) return servicoIndisponivel(res);

    const { uid } = req.usuario;
    const docUsuario = await db.collection('usuarios').doc(uid).get();

    if (!docUsuario.exists || docUsuario.data().tipo !== 'prestador') {
      return res.status(403).json({
        erro: 'Acesso negado',
        mensagem: 'Somente prestadores podem enviar documentos de verificação.'
      });
    }

    for (const tipo of TIPOS_ARQUIVO) {
      const problema = validarImagem(req.body[tipo]);
      if (problema) {
        return res.status(400).json({ erro: 'Arquivo inválido', mensagem: problema, campo: tipo });
      }
    }

    const refVerificacao = db.collection('verificacoes').doc(uid);
    const atual = await refVerificacao.get();
    if (atual.exists && atual.data().status === 'aprovado') {
      return res.status(409).json({
        erro: 'Já verificado',
        mensagem: 'Seu perfil já está verificado.'
      });
    }

    const usuario = docUsuario.data();
    const lote = db.batch();
    for (const tipo of TIPOS_ARQUIVO) {
      lote.set(refVerificacao.collection('arquivos').doc(tipo), { base64: req.body[tipo] });
    }
    lote.set(refVerificacao, {
      uid,
      nome: usuario.nome || '',
      email: usuario.email || '',
      especialidade: usuario.especialidade || null,
      status: 'pendente',
      motivoRecusa: null,
      enviadoEm: new Date().toISOString(),
      analisadoEm: null,
      analisadoPor: null
    });
    await lote.commit();

    res.status(201).json({
      mensagem: 'Documentos enviados! Nossa equipe vai analisar em breve.',
      status: 'pendente'
    });

  } catch (erro) {
    console.error('❌ Erro ao enviar verificação:', erro.message);
    res.status(500).json({ erro: 'Erro ao enviar documentos', mensagem: erro.message });
  }
}

// -----------------------------------------------
// GET /api/verificacoes/minha
// -----------------------------------------------
// Status da verificação do próprio prestador (null = nunca enviou)
async function minhaVerificacao(req, res) {
  try {
    if (!db) return servicoIndisponivel(res);

    const doc = await db.collection('verificacoes').doc(req.usuario.uid).get();
    if (!doc.exists) return res.status(200).json({ status: null });

    const { status, motivoRecusa, enviadoEm } = doc.data();
    res.status(200).json({ status, motivoRecusa, enviadoEm });

  } catch (erro) {
    console.error('❌ Erro ao buscar verificação:', erro.message);
    res.status(500).json({ erro: 'Erro ao buscar verificação', mensagem: erro.message });
  }
}

// -----------------------------------------------
// GET /api/verificacoes?status=pendente   (admin)
// -----------------------------------------------
async function listarVerificacoes(req, res) {
  try {
    if (!db) return servicoIndisponivel(res);

    const status = req.query.status || 'pendente';
    const snapshot = await db.collection('verificacoes').where('status', '==', status).get();
    const verificacoes = snapshot.docs
      .map(doc => doc.data())
      .sort((a, b) => (a.enviadoEm || '').localeCompare(b.enviadoEm || ''));

    res.status(200).json({ verificacoes });

  } catch (erro) {
    console.error('❌ Erro ao listar verificações:', erro.message);
    res.status(500).json({ erro: 'Erro ao listar verificações', mensagem: erro.message });
  }
}

// -----------------------------------------------
// GET /api/verificacoes/:uid/arquivos   (admin)
// -----------------------------------------------
async function obterArquivos(req, res) {
  try {
    if (!db) return servicoIndisponivel(res);

    const snapshot = await db.collection('verificacoes').doc(req.params.uid)
      .collection('arquivos').get();
    const arquivos = {};
    snapshot.forEach(doc => { arquivos[doc.id] = doc.data().base64; });

    res.status(200).json({ arquivos });

  } catch (erro) {
    console.error('❌ Erro ao buscar arquivos:', erro.message);
    res.status(500).json({ erro: 'Erro ao buscar arquivos', mensagem: erro.message });
  }
}

// -----------------------------------------------
// PATCH /api/verificacoes/:uid   (admin)
// -----------------------------------------------
// Body: { acao: 'aprovar' | 'recusar', motivo?: string }
async function analisarVerificacao(req, res) {
  try {
    if (!db) return servicoIndisponivel(res);

    const { uid } = req.params;
    const { acao, motivo } = req.body;

    if (acao !== 'aprovar' && acao !== 'recusar') {
      return res.status(400).json({ erro: 'Ação inválida', mensagem: 'Use "aprovar" ou "recusar".' });
    }
    if (acao === 'recusar' && !motivo?.trim()) {
      return res.status(400).json({ erro: 'Motivo obrigatório', mensagem: 'Informe o motivo da recusa.' });
    }

    const refVerificacao = db.collection('verificacoes').doc(uid);
    if (!(await refVerificacao.get()).exists) {
      return res.status(404).json({ erro: 'Não encontrada', mensagem: 'Verificação não encontrada.' });
    }

    const aprovado = acao === 'aprovar';
    const lote = db.batch();
    lote.update(refVerificacao, {
      status: aprovado ? 'aprovado' : 'recusado',
      motivoRecusa: aprovado ? null : motivo.trim(),
      analisadoEm: new Date().toISOString(),
      analisadoPor: req.usuario.email
    });
    lote.update(db.collection('usuarios').doc(uid), { verificado: aprovado });
    await lote.commit();

    await criarNotificacao({
      idUsuario: uid,
      tipo: aprovado ? 'verificacao_aprovada' : 'verificacao_recusada',
      titulo: aprovado ? 'Perfil verificado!' : 'Verificação recusada',
      mensagem: aprovado
        ? 'Seus documentos foram aprovados. Seu perfil agora tem o selo de verificado.'
        : `Seus documentos não foram aprovados: ${motivo.trim()}. Você pode enviar novamente.`
    });

    res.status(200).json({ mensagem: aprovado ? 'Prestador verificado.' : 'Verificação recusada.' });

  } catch (erro) {
    console.error('❌ Erro ao analisar verificação:', erro.message);
    res.status(500).json({ erro: 'Erro ao analisar verificação', mensagem: erro.message });
  }
}

// Apaga a verificação e as imagens de um usuário (usado ao excluir a conta)
async function apagarVerificacao(uid) {
  await db.recursiveDelete(db.collection('verificacoes').doc(uid));
}

module.exports = {
  enviarVerificacao,
  minhaVerificacao,
  listarVerificacoes,
  obterArquivos,
  analisarVerificacao,
  apagarVerificacao
};
