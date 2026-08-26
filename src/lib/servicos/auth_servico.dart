// ============================================
// auth_servico.dart — Gerenciamento de Autenticação (MOCK PARA TESTE)
// ============================================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/usuario.dart';
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
        especialidade: prefs.getString('usuario_especialidade'),
        valorHora: prefs.getDouble('usuario_valor_hora'),
        biografia: prefs.getString('usuario_biografia'),
      );
      notifyListeners();
    }
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

  /// Login — valida credenciais de verdade contra o backend/Firebase Auth
  Future<bool> login({String email = '', String senha = ''}) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      final resposta = await ApiServico.login(
        email: email.trim(),
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

  /// Confirma papel de cliente e persiste a sessão
  Future<void> definirComoCliente() async {
    if (_usuarioAtual == null) return;
    _usuarioAtual = Usuario(
      uid: _usuarioAtual!.uid,
      nome: _usuarioAtual!.nome,
      email: _usuarioAtual!.email,
      tipo: 'cliente',
      telefone: _usuarioAtual!.telefone,
      cpf: _usuarioAtual!.cpf,
      cep: _usuarioAtual!.cep,
      cidade: _usuarioAtual!.cidade,
      endereco: _usuarioAtual!.endereco,
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
        // Reenvia a chave Pix atual pra não perdê-la —
        // o endpoint sobrescreve tudo que recebe.
        chavePix: _usuarioAtual!.chavePix,
      );

      if (resposta.containsKey('erro')) {
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

  /// Atualiza a chave Pix do prestador logado (referência, não
  /// processa transação nenhuma)
  Future<bool> atualizarMetodoPagamento({String? chavePix}) async {
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
      );

      if (resposta.containsKey('erro')) {
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
