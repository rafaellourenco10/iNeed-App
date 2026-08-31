// ============================================
// auth_servico.dart — Gerenciamento de Autenticação (MOCK PARA TESTE)
// ============================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/usuario.dart';
import '../navegacao_global.dart';
import 'api_servico.dart';

class AuthServico extends ChangeNotifier {
  Usuario? _usuarioAtual;
  String? _token;
  bool _carregando = false;
  String? _erro;

  Usuario? get usuarioAtual => _usuarioAtual;
  String? get token => _token;
  bool get carregando => _carregando;
  String? get erro => _erro;

  // Logado com papel definido
  bool get estaLogado => _usuarioAtual != null && !_usuarioAtual!.semPapel;

  // Autenticado mas ainda sem papel escolhido (vai para onboarding)
  bool get aguardandoPapel => _usuarioAtual != null && _usuarioAtual!.semPapel;

  /// Restaura sessão anterior
  Future<void> restaurarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('usuario_email');
    final tipo = prefs.getString('usuario_tipo');
    final uid = prefs.getString('usuario_uid');
    final nome = prefs.getString('usuario_nome');

    if (email != null &&
        tipo != null &&
        uid != null &&
        nome != null &&
        tipo.isNotEmpty) {
      _token = prefs.getString('usuario_token');
      _usuarioAtual = Usuario(
        uid: uid,
        nome: nome,
        email: email,
        tipo: tipo,
        telefone: prefs.getString('usuario_telefone'),
        cpf: prefs.getString('usuario_cpf'),
        cep: prefs.getString('usuario_cep'),
        cidade: prefs.getString('usuario_cidade'),
        endereco: prefs.getString('usuario_endereco'),
        chavePix: prefs.getString('usuario_chave_pix'),
        formaPagamentoAceita: prefs.getString('usuario_forma_pagamento'),
        especialidade: prefs.getString('usuario_especialidade'),
        valorHora: prefs.getDouble('usuario_valor_hora'),
        biografia: prefs.getString('usuario_biografia'),
      );
      notifyListeners();

      // Sessão salva localmente pode estar desatualizada (ex: virou
      // prestador num outro momento e este aparelho nunca soube) —
      // revalida com o backend em segundo plano, sem travar a abertura.
      unawaited(sincronizarPerfil());
    }
  }

  /// Busca os dados atuais do usuário no backend e atualiza a sessão local
  /// se algo tiver mudado. Silencioso — falha de rede não afeta o app,
  /// só mantém os dados em cache até a próxima tentativa. Se o token salvo
  /// tiver expirado (dura só 1h), desloga e manda pro login.
  Future<void> sincronizarPerfil() async {
    if (_token == null) return;

    try {
      final resposta = await ApiServico.buscarMeuPerfil(token: _token!);
      if (resposta.containsKey('erro')) {
        await _tratarTokenExpirado(resposta);
        return;
      }

      _usuarioAtual = Usuario.fromJson(
        resposta['usuario'] as Map<String, dynamic>,
      );
      await _salvarSessao();
      notifyListeners();
    } catch (_) {
      // Sem internet ou backend fora — mantém os dados em cache.
    }
  }

  /// Se a resposta indica token expirado/inválido, desloga e manda pro
  /// login. Retorna true se tratou (chamador deve parar o que tava fazendo).
  Future<bool> _tratarTokenExpirado(Map<String, dynamic> resposta) async {
    if (resposta['erro'] != 'Token inválido') return false;

    await logout();
    chaveNavegadorGlobal.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (rota) => false,
    );
    return true;
  }

  /// Cadastro real — cria a conta no backend/Firebase (sempre como cliente)
  Future<bool> registrar({
    required String nome,
    required String email,
    required String senha,
    required String cpf,
    required String telefone,
    required String cep,
    required String endereco,
    required String cidade,
  }) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      final resposta = await ApiServico.cadastrarCliente(
        nome: nome.trim(),
        email: email.trim(),
        senha: senha,
        telefone: telefone,
        cpf: cpf,
        cep: cep,
        endereco: endereco,
        cidade: cidade,
      );

      if (resposta.containsKey('erro')) {
        _erro = resposta['mensagem'] as String? ?? 'Erro ao criar conta.';
        _carregando = false;
        notifyListeners();
        return false;
      }
    } catch (_) {
      _erro = 'Não foi possível conectar ao servidor.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    _carregando = false;
    notifyListeners();
    return true;
  }

  /// Login — valida credenciais de verdade contra o backend/Firebase Auth.
  /// [identificador] aceita email, CPF ou celular.
  Future<bool> login({String identificador = '', String senha = ''}) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      final resposta = await ApiServico.login(
        identificador: identificador.trim(),
        senha: senha,
      );

      if (resposta.containsKey('erro')) {
        _erro = resposta['mensagem'] as String? ?? 'Erro ao fazer login.';
        _carregando = false;
        notifyListeners();
        return false;
      }

      _usuarioAtual = Usuario.fromJson(
        resposta['usuario'] as Map<String, dynamic>,
      );
      _token = resposta['token'] as String?;
      await _salvarSessao();
    } catch (_) {
      _erro = 'Não foi possível conectar ao servidor.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    _carregando = false;
    notifyListeners();
    return true;
  }

  /// Confirma papel de cliente e persiste a sessão. Só troca o `tipo` —
  /// preserva os campos de prestador (especialidade, valorHora, etc.) pra
  /// quem é os dois não perder o cadastro de prestador só por navegar
  /// pro lado cliente.
  Future<void> definirComoCliente() => _trocarTipoLocal('cliente');

  /// Volta o modo local pra prestador (sem chamar o backend) — usado
  /// quando a conta já tem cadastro de prestador e só está alternando de
  /// volta depois de ter navegado como cliente (ver TelaOnboarding).
  Future<void> voltarParaPrestador() => _trocarTipoLocal('prestador');

  /// Troca só o campo `tipo` do usuário em memória, preservando todo o
  /// resto — é uma troca de "modo de navegação atual", não uma chamada
  /// ao backend (que continua com os dados reais intactos).
  Future<void> _trocarTipoLocal(String tipo) async {
    if (_usuarioAtual == null) return;
    _usuarioAtual = Usuario(
      uid: _usuarioAtual!.uid,
      nome: _usuarioAtual!.nome,
      email: _usuarioAtual!.email,
      tipo: tipo,
      localizacao: _usuarioAtual!.localizacao,
      telefone: _usuarioAtual!.telefone,
      cpf: _usuarioAtual!.cpf,
      cep: _usuarioAtual!.cep,
      cidade: _usuarioAtual!.cidade,
      endereco: _usuarioAtual!.endereco,
      chavePix: _usuarioAtual!.chavePix,
      formaPagamentoAceita: _usuarioAtual!.formaPagamentoAceita,
      especialidade: _usuarioAtual!.especialidade,
      valorHora: _usuarioAtual!.valorHora,
      biografia: _usuarioAtual!.biografia,
      avaliacao: _usuarioAtual!.avaliacao,
      totalServicos: _usuarioAtual!.totalServicos,
      disponivel: _usuarioAtual!.disponivel,
      criadoEm: _usuarioAtual!.criadoEm,
      atualizadoEm: _usuarioAtual!.atualizadoEm,
    );
    await _salvarSessao();
    notifyListeners();
  }

  /// Adiciona informações de prestador à conta já existente (via backend)
  Future<bool> definirComoPrestador({
    required String especialidade,
    required double valorHora,
    String? biografia,
  }) async {
    if (_usuarioAtual == null || _token == null) {
      _erro = 'Sessão expirada. Faça login novamente.';
      notifyListeners();
      return false;
    }

    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      final resposta = await ApiServico.tornarPrestador(
        token: _token!,
        especialidade: especialidade,
        valorHora: valorHora,
        biografia: biografia,
      );

      if (resposta.containsKey('erro')) {
        if (await _tratarTokenExpirado(resposta)) return false;
        _erro = resposta['mensagem'] as String? ?? 'Erro ao atualizar perfil.';
        _carregando = false;
        notifyListeners();
        return false;
      }

      _usuarioAtual = Usuario.fromJson(
        resposta['usuario'] as Map<String, dynamic>,
      );
      await _salvarSessao();
    } catch (_) {
      _erro = 'Não foi possível conectar ao servidor.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    _carregando = false;
    notifyListeners();
    return true;
  }

  /// Atualiza os dados pessoais do usuário logado (via backend)
  Future<bool> atualizarDadosPessoais({
    required String nome,
    String? telefone,
    String? cpf,
    String? cep,
    String? endereco,
    String? cidade,
  }) async {
    if (_usuarioAtual == null || _token == null) {
      _erro = 'Sessão expirada. Faça login novamente.';
      notifyListeners();
      return false;
    }

    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      final resposta = await ApiServico.atualizarPerfil(
        token: _token!,
        nome: nome,
        telefone: telefone,
        cpf: cpf,
        cep: cep,
        endereco: endereco,
        cidade: cidade,
        // Reenvia os campos de pagamento atuais pra não perdê-los —
        // o endpoint sobrescreve tudo que recebe.
        chavePix: _usuarioAtual!.chavePix,
        formaPagamentoAceita: _usuarioAtual!.formaPagamentoAceita,
      );

      if (resposta.containsKey('erro')) {
        if (await _tratarTokenExpirado(resposta)) return false;
        _erro = resposta['mensagem'] as String? ?? 'Erro ao atualizar dados.';
        _carregando = false;
        notifyListeners();
        return false;
      }

      _usuarioAtual = Usuario.fromJson(
        resposta['usuario'] as Map<String, dynamic>,
      );
      await _salvarSessao();
    } catch (_) {
      _erro = 'Não foi possível conectar ao servidor.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    _carregando = false;
    notifyListeners();
    return true;
  }

  /// Atualiza a chave Pix e as formas de pagamento aceitas pelo
  /// prestador logado (referência, não processa transação nenhuma)
  Future<bool> atualizarMetodoPagamento({
    String? chavePix,
    String? formaPagamentoAceita,
  }) async {
    if (_usuarioAtual == null || _token == null) {
      _erro = 'Sessão expirada. Faça login novamente.';
      notifyListeners();
      return false;
    }

    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      final resposta = await ApiServico.atualizarPerfil(
        token: _token!,
        nome: _usuarioAtual!.nome,
        telefone: _usuarioAtual!.telefone,
        cpf: _usuarioAtual!.cpf,
        cep: _usuarioAtual!.cep,
        endereco: _usuarioAtual!.endereco,
        cidade: _usuarioAtual!.cidade,
        chavePix: chavePix,
        formaPagamentoAceita: formaPagamentoAceita,
      );

      if (resposta.containsKey('erro')) {
        if (await _tratarTokenExpirado(resposta)) return false;
        _erro = resposta['mensagem'] as String? ?? 'Erro ao atualizar dados.';
        _carregando = false;
        notifyListeners();
        return false;
      }

      _usuarioAtual = Usuario.fromJson(
        resposta['usuario'] as Map<String, dynamic>,
      );
      await _salvarSessao();
    } catch (_) {
      _erro = 'Não foi possível conectar ao servidor.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    _carregando = false;
    notifyListeners();
    return true;
  }

  /// Exclui a conta do usuário logado (e tudo ligado a ela) — irreversível.
  /// Exige a senha de novo pra confirmar. Já limpa a sessão local no sucesso.
  Future<bool> excluirConta({required String senha}) async {
    if (_usuarioAtual == null || _token == null) {
      _erro = 'Sessão expirada. Faça login novamente.';
      notifyListeners();
      return false;
    }

    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      final resposta = await ApiServico.excluirConta(
        token: _token!,
        senha: senha,
      );

      if (resposta.containsKey('erro')) {
        if (await _tratarTokenExpirado(resposta)) return false;
        _erro = resposta['mensagem'] as String? ?? 'Erro ao excluir conta.';
        _carregando = false;
        notifyListeners();
        return false;
      }

      _usuarioAtual = null;
      _token = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (_) {
      _erro = 'Não foi possível conectar ao servidor.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    _carregando = false;
    notifyListeners();
    return true;
  }

  /// Logout
  Future<void> logout() async {
    _usuarioAtual = null;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  Future<void> _salvarSessao() async {
    if (_usuarioAtual == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario_email', _usuarioAtual!.email);
    await prefs.setString('usuario_tipo', _usuarioAtual!.tipo);
    await prefs.setString('usuario_uid', _usuarioAtual!.uid);
    await prefs.setString('usuario_nome', _usuarioAtual!.nome);
    if (_token != null) {
      await prefs.setString('usuario_token', _token!);
    }
    if (_usuarioAtual!.telefone != null) {
      await prefs.setString('usuario_telefone', _usuarioAtual!.telefone!);
    }
    if (_usuarioAtual!.cpf != null) {
      await prefs.setString('usuario_cpf', _usuarioAtual!.cpf!);
    }
    if (_usuarioAtual!.cep != null) {
      await prefs.setString('usuario_cep', _usuarioAtual!.cep!);
    }
    if (_usuarioAtual!.cidade != null) {
      await prefs.setString('usuario_cidade', _usuarioAtual!.cidade!);
    }
    if (_usuarioAtual!.endereco != null) {
      await prefs.setString('usuario_endereco', _usuarioAtual!.endereco!);
    }
    if (_usuarioAtual!.chavePix != null) {
      await prefs.setString('usuario_chave_pix', _usuarioAtual!.chavePix!);
    }
    if (_usuarioAtual!.formaPagamentoAceita != null) {
      await prefs.setString(
        'usuario_forma_pagamento',
        _usuarioAtual!.formaPagamentoAceita!,
      );
    }
    if (_usuarioAtual!.especialidade != null) {
      await prefs.setString(
        'usuario_especialidade',
        _usuarioAtual!.especialidade!,
      );
    }
    if (_usuarioAtual!.valorHora != null) {
      await prefs.setDouble('usuario_valor_hora', _usuarioAtual!.valorHora!);
    }
    if (_usuarioAtual!.biografia != null) {
      await prefs.setString('usuario_biografia', _usuarioAtual!.biografia!);
    }
  }
}
