// ============================================
// controladorAutenticacao.js — Lógica de cadastro e login
// ============================================
// Gerencia criação de usuários (Cliente e Prestador) e login.
// Cria o usuário no Firebase Auth E salva os dados no Firestore.

const { auth, db } = require('../configuracao/firebase');

// -----------------------------------------------
// POST /api/auth/cadastro-cliente
// -----------------------------------------------
async function cadastrarCliente(req, res) {
  try {
    const { nome, email, telefone, localizacao, senha } = req.body;

    // Validações básicas
    if (!nome || !email || !senha) {
      return res.status(400).json({
        erro: 'Dados incompletos',
        mensagem: 'Nome, email e senha são obrigatórios.'
      });
    }

    if (!auth || !db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    // Criar usuário no Firebase Auth
    const usuarioCriado = await auth.createUser({
      email: email,
      password: senha,
      displayName: nome
    });

    // Salvar dados adicionais no Firestore
    await db.collection('usuarios').doc(usuarioCriado.uid).set({
      nome: nome,
      email: email,
      telefone: telefone || null,
      localizacao: localizacao || null,
      tipo: 'cliente',
      criadoEm: new Date().toISOString(),
      atualizadoEm: new Date().toISOString()
    });

    res.status(201).json({
      mensagem: 'Cliente cadastrado com sucesso!',
      usuario: {
        uid: usuarioCriado.uid,
        nome: nome,
        email: email,
        tipo: 'cliente'
      }
    });

  } catch (erro) {
    console.error('❌ Erro ao cadastrar cliente:', erro.message);

    if (erro.code === 'auth/email-already-exists') {
      return res.status(409).json({
        erro: 'Email já cadastrado',
        mensagem: 'Já existe uma conta com este email.'
      });
    }

    res.status(500).json({
      erro: 'Erro ao cadastrar',
      mensagem: erro.message
    });
  }
}

// -----------------------------------------------
// POST /api/auth/cadastro-prestador
// -----------------------------------------------
async function cadastrarPrestador(req, res) {
  try {
    const { nome, email, telefone, especialidade, valorHora, biografia, senha } = req.body;

    // Validações básicas
    if (!nome || !email || !senha || !especialidade) {
      return res.status(400).json({
        erro: 'Dados incompletos',
        mensagem: 'Nome, email, senha e especialidade são obrigatórios.'
      });
    }

    if (!auth || !db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    // Criar usuário no Firebase Auth
    const usuarioCriado = await auth.createUser({
      email: email,
      password: senha,
      displayName: nome
    });

    // Salvar dados adicionais no Firestore
    await db.collection('usuarios').doc(usuarioCriado.uid).set({
      nome: nome,
      email: email,
      telefone: telefone || null,
      especialidade: especialidade,
      valorHora: valorHora || null,
      biografia: biografia || null,
      tipo: 'prestador',
      avaliacao: 0,
      totalServicos: 0,
      disponivel: true,
      criadoEm: new Date().toISOString(),
      atualizadoEm: new Date().toISOString()
    });

    res.status(201).json({
      mensagem: 'Prestador cadastrado com sucesso!',
      usuario: {
        uid: usuarioCriado.uid,
        nome: nome,
        email: email,
        tipo: 'prestador',
        especialidade: especialidade
      }
    });

  } catch (erro) {
    console.error('❌ Erro ao cadastrar prestador:', erro.message);

    if (erro.code === 'auth/email-already-exists') {
      return res.status(409).json({
        erro: 'Email já cadastrado',
        mensagem: 'Já existe uma conta com este email.'
      });
    }

    res.status(500).json({
      erro: 'Erro ao cadastrar',
      mensagem: erro.message
    });
  }
}

// -----------------------------------------------
// POST /api/auth/login
// -----------------------------------------------
// Nota: O login real com email/senha é feito no lado do cliente
// usando o Firebase Auth SDK (ou via REST API do Firebase Auth).
// Este endpoint serve para buscar os dados do usuário após o login.
async function loginUsuario(req, res) {
  try {
    const { email } = req.body;

    if (!email) {
      return res.status(400).json({
        erro: 'Dados incompletos',
        mensagem: 'Email é obrigatório.'
      });
    }

    if (!auth || !db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    // Buscar usuário pelo email no Firebase Auth
    const usuarioAuth = await auth.getUserByEmail(email);

    // Buscar dados complementares no Firestore
    const docUsuario = await db.collection('usuarios').doc(usuarioAuth.uid).get();

    if (!docUsuario.exists) {
      return res.status(404).json({
        erro: 'Usuário não encontrado',
        mensagem: 'Dados do usuário não encontrados no banco de dados.'
      });
    }

    const dadosUsuario = docUsuario.data();

    res.status(200).json({
      mensagem: 'Dados do usuário obtidos com sucesso!',
      usuario: {
        uid: usuarioAuth.uid,
        ...dadosUsuario
      }
    });

  } catch (erro) {
    console.error('❌ Erro no login:', erro.message);

    if (erro.code === 'auth/user-not-found') {
      return res.status(404).json({
        erro: 'Usuário não encontrado',
        mensagem: 'Nenhuma conta encontrada com este email.'
      });
    }

    res.status(500).json({
      erro: 'Erro no login',
      mensagem: erro.message
    });
  }
}

module.exports = {
  cadastrarCliente,
  cadastrarPrestador,
  loginUsuario
};
