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
    const { nome, email, telefone, localizacao, senha, cpf, cep, endereco, cidade } = req.body;

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
      cpf: cpf || null,
      cep: cep || null,
      endereco: endereco || null,
      cidade: cidade || null,
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
// O Firebase Admin SDK não consegue validar senha (isso só existe do lado
// cliente). Por isso o backend chama a REST API do Firebase Identity
// Toolkit pra validar email+senha de verdade, mantendo o app Flutter
// sem contato direto com o Firebase.
const MENSAGENS_ERRO_LOGIN = {
  EMAIL_NOT_FOUND: 'Nenhuma conta encontrada com este email.',
  INVALID_PASSWORD: 'Senha incorreta.',
  INVALID_LOGIN_CREDENTIALS: 'Email ou senha incorretos.',
  USER_DISABLED: 'Esta conta foi desativada.',
  TOO_MANY_ATTEMPTS_TRY_LATER: 'Muitas tentativas. Tente novamente mais tarde.'
};

async function loginUsuario(req, res) {
  try {
    const { email, senha } = req.body;

    if (!email || !senha) {
      return res.status(400).json({
        erro: 'Dados incompletos',
        mensagem: 'Email e senha são obrigatórios.'
      });
    }

    if (!auth || !db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    const chaveApi = process.env.FIREBASE_WEB_API_KEY;
    if (!chaveApi) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'FIREBASE_WEB_API_KEY não está configurada no servidor.'
      });
    }

    // Valida email+senha na REST API do Firebase Auth
    const respostaAuth = await fetch(
      `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${chaveApi}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password: senha, returnSecureToken: true })
      }
    );

    const dadosAuth = await respostaAuth.json();

    if (!respostaAuth.ok) {
      const codigo = dadosAuth.error?.message || '';
      return res.status(401).json({
        erro: 'Credenciais inválidas',
        mensagem: MENSAGENS_ERRO_LOGIN[codigo] || 'Não foi possível fazer login. Verifique seus dados.'
      });
    }

    // Busca os dados complementares no Firestore
    const docUsuario = await db.collection('usuarios').doc(dadosAuth.localId).get();

    if (!docUsuario.exists) {
      return res.status(404).json({
        erro: 'Usuário não encontrado',
        mensagem: 'Dados do usuário não encontrados no banco de dados.'
      });
    }

    res.status(200).json({
      mensagem: 'Login realizado com sucesso!',
      token: dadosAuth.idToken,
      usuario: {
        uid: dadosAuth.localId,
        ...docUsuario.data()
      }
    });

  } catch (erro) {
    console.error('❌ Erro no login:', erro.message);
    res.status(500).json({
      erro: 'Erro no login',
      mensagem: erro.message
    });
  }
}

// -----------------------------------------------
// PATCH /api/auth/tornar-prestador
// -----------------------------------------------
// Adiciona informações de prestador a uma conta já existente (cliente
// que decide também prestar serviços). Não cria usuário novo — só
// atualiza o documento já existente no Firestore, dono do token.
async function tornarPrestador(req, res) {
  try {
    const { especialidade, valorHora, biografia } = req.body;

    if (!especialidade || valorHora === undefined || valorHora === null) {
      return res.status(400).json({
        erro: 'Dados incompletos',
        mensagem: 'Especialidade e valor por hora são obrigatórios.'
      });
    }

    if (!db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    const uid = req.usuario.uid;
    const docRef = db.collection('usuarios').doc(uid);
    const docUsuario = await docRef.get();

    if (!docUsuario.exists) {
      return res.status(404).json({
        erro: 'Usuário não encontrado',
        mensagem: 'Conta não encontrada no banco de dados.'
      });
    }

    await docRef.update({
      tipo: 'prestador',
      especialidade: especialidade,
      valorHora: parseFloat(valorHora),
      biografia: biografia || null,
      avaliacao: 0,
      totalServicos: 0,
      disponivel: true,
      atualizadoEm: new Date().toISOString()
    });

    const docAtualizado = await docRef.get();

    res.status(200).json({
      mensagem: 'Perfil de prestador criado com sucesso!',
      usuario: {
        uid: uid,
        ...docAtualizado.data()
      }
    });

  } catch (erro) {
    console.error('❌ Erro ao tornar prestador:', erro.message);
    res.status(500).json({
      erro: 'Erro ao atualizar perfil',
      mensagem: erro.message
    });
  }
}

// -----------------------------------------------
// PATCH /api/auth/atualizar-perfil
// -----------------------------------------------
// Atualiza os dados pessoais do usuário autenticado (nome, telefone,
// cpf, cep, endereço, cidade). Email não é editável aqui — é a
// identidade da conta no Firebase Auth, exige fluxo próprio.
async function atualizarPerfil(req, res) {
  try {
    const { nome, telefone, cpf, cep, endereco, cidade, chavePix } = req.body;

    if (!nome || !nome.trim()) {
      return res.status(400).json({
        erro: 'Dados incompletos',
        mensagem: 'O nome é obrigatório.'
      });
    }

    if (!db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    const uid = req.usuario.uid;
    const docRef = db.collection('usuarios').doc(uid);
    const docUsuario = await docRef.get();

    if (!docUsuario.exists) {
      return res.status(404).json({
        erro: 'Usuário não encontrado',
        mensagem: 'Conta não encontrada no banco de dados.'
      });
    }

    await docRef.update({
      nome: nome.trim(),
      telefone: telefone || null,
      cpf: cpf || null,
      cep: cep || null,
      endereco: endereco || null,
      cidade: cidade || null,
      chavePix: chavePix || null,
      atualizadoEm: new Date().toISOString()
    });

    const docAtualizado = await docRef.get();

    res.status(200).json({
      mensagem: 'Dados atualizados com sucesso!',
      usuario: {
        uid: uid,
        ...docAtualizado.data()
      }
    });

  } catch (erro) {
    console.error('❌ Erro ao atualizar perfil:', erro.message);
    res.status(500).json({
      erro: 'Erro ao atualizar perfil',
      mensagem: erro.message
    });
  }
}

module.exports = {
  cadastrarCliente,
  cadastrarPrestador,
  loginUsuario,
  tornarPrestador,
  atualizarPerfil
};
