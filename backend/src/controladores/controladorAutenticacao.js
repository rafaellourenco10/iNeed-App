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
//
// O usuário pode entrar com email, CPF ou celular — o Firebase Auth só
// entende email, então quando o identificador não é um email o backend
// busca em usuarios/ (comparando só os dígitos, pra não depender de
// formatação igual) e resolve pro email antes de validar a senha.
const MENSAGENS_ERRO_LOGIN = {
  EMAIL_NOT_FOUND: 'Nenhuma conta encontrada com este email.',
  INVALID_PASSWORD: 'Senha incorreta.',
  INVALID_LOGIN_CREDENTIALS: 'Email ou senha incorretos.',
  USER_DISABLED: 'Esta conta foi desativada.',
  TOO_MANY_ATTEMPTS_TRY_LATER: 'Muitas tentativas. Tente novamente mais tarde.'
};

const apenasDigitos = (valor) => (valor || '').replace(/\D/g, '');

// Recebe o que o usuário digitou (email, CPF ou celular) e devolve o email
// pra autenticar no Firebase. Se já for email, devolve direto. Se for CPF
// ou celular, procura em usuarios/ o primeiro documento cujo cpf/telefone
// bate (comparando só os dígitos) e devolve o email daquela conta.
async function resolverEmailDoIdentificador(identificador) {
  if (identificador.includes('@')) return identificador;

  const digitos = apenasDigitos(identificador);
  if (!digitos) return null;

  const snapshot = await db.collection('usuarios').get();
  for (const doc of snapshot.docs) {
    const dados = doc.data();
    if (
      (dados.cpf && apenasDigitos(dados.cpf) === digitos) ||
      (dados.telefone && apenasDigitos(dados.telefone) === digitos)
    ) {
      return dados.email || null;
    }
  }
  return null;
}

async function loginUsuario(req, res) {
  try {
    const identificador = (req.body.identificador || req.body.email || '').trim();
    const { senha } = req.body;

    if (!identificador || !senha) {
      return res.status(400).json({
        erro: 'Dados incompletos',
        mensagem: 'Informe seu email, CPF ou celular, e a senha.'
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

    const email = await resolverEmailDoIdentificador(identificador);
    if (!email) {
      return res.status(401).json({
        erro: 'Credenciais inválidas',
        mensagem: 'Não foi possível fazer login. Verifique seus dados.'
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
    const { nome, telefone, cpf, cep, endereco, cidade, chavePix, formaPagamentoAceita } = req.body;

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
      formaPagamentoAceita: formaPagamentoAceita || null,
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

// -----------------------------------------------
// GET /api/auth/meu-perfil
// -----------------------------------------------
// Retorna os dados atuais do usuário autenticado direto do Firestore.
// Usado pelo app pra revalidar a sessão salva localmente (SharedPreferences)
// contra o backend ao abrir — evita mostrar dados desatualizados (ex: tipo
// 'cliente' em cache num aparelho depois da conta ter virado 'prestador').
async function meuPerfil(req, res) {
  try {
    if (!db) {
      return res.status(503).json({
        erro: 'Serviço indisponível',
        mensagem: 'Firebase não está configurado.'
      });
    }

    const uid = req.usuario.uid;
    const docUsuario = await db.collection('usuarios').doc(uid).get();

    if (!docUsuario.exists) {
      return res.status(404).json({
        erro: 'Usuário não encontrado',
        mensagem: 'Conta não encontrada no banco de dados.'
      });
    }

    res.status(200).json({
      usuario: {
        uid: uid,
        ...docUsuario.data()
      }
    });

  } catch (erro) {
    console.error('❌ Erro ao buscar perfil:', erro.message);
    res.status(500).json({
      erro: 'Erro ao buscar perfil',
      mensagem: erro.message
    });
  }
}

// -----------------------------------------------
// DELETE /api/auth/excluir-conta
// -----------------------------------------------
// Apaga a conta do usuário autenticado e tudo que está ligado a ela —
// propostas e avaliações (como cliente OU como prestador, os dois lados),
// notificações, o cadastro em usuarios/ e a conta no Firebase Auth.
// Ação irreversível, por isso reconfirma a senha antes de apagar
// qualquer coisa, mesmo a requisição já vindo com token válido.
async function excluirConta(req, res) {
  try {
    const { senha } = req.body;
    const { uid, email } = req.usuario;

    if (!senha) {
      return res.status(400).json({
        erro: 'Dados incompletos',
        mensagem: 'Informe sua senha pra confirmar a exclusão.'
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

    // Reconfirma a senha antes de apagar qualquer coisa
    const respostaAuth = await fetch(
      `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${chaveApi}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password: senha, returnSecureToken: true })
      }
    );

    if (!respostaAuth.ok) {
      return res.status(401).json({
        erro: 'Senha incorreta',
        mensagem: 'Senha incorreta. Não foi possível confirmar a exclusão.'
      });
    }

    // Propostas — como cliente e como prestador
    const propostasCliente = await db.collection('propostas').where('idCliente', '==', uid).get();
    const propostasPrestador = await db.collection('propostas').where('idPrestador', '==', uid).get();
    const loteA = db.batch();
    propostasCliente.forEach(doc => loteA.delete(doc.ref));
    propostasPrestador.forEach(doc => loteA.delete(doc.ref));
    await loteA.commit();

    // Avaliações — como cliente e como prestador
    const avaliacoesCliente = await db.collection('avaliacoes').where('idCliente', '==', uid).get();
    const avaliacoesPrestador = await db.collection('avaliacoes').where('idPrestador', '==', uid).get();
    const loteB = db.batch();
    avaliacoesCliente.forEach(doc => loteB.delete(doc.ref));
    avaliacoesPrestador.forEach(doc => loteB.delete(doc.ref));
    await loteB.commit();

    // Notificações
    const notificacoes = await db.collection('notificacoes').where('idUsuario', '==', uid).get();
    const loteC = db.batch();
    notificacoes.forEach(doc => loteC.delete(doc.ref));
    await loteC.commit();

    // Cadastro e conta
    await db.collection('usuarios').doc(uid).delete();
    await auth.deleteUser(uid);

    res.status(200).json({ mensagem: 'Conta excluída com sucesso.' });

  } catch (erro) {
    console.error('❌ Erro ao excluir conta:', erro.message);
    res.status(500).json({
      erro: 'Erro ao excluir conta',
      mensagem: erro.message
    });
  }
}

module.exports = {
  cadastrarCliente,
  cadastrarPrestador,
  loginUsuario,
  tornarPrestador,
  atualizarPerfil,
  meuPerfil,
  excluirConta
};
