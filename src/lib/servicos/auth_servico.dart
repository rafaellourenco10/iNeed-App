// ============================================
// auth_servico.dart — Gerenciamento de Autenticação (MOCK PARA TESTE)
// ============================================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/usuario.dart';

class AuthServico extends ChangeNotifier {
  Usuario? _usuarioAtual;
  bool _carregando = false;
  String? _erro;

  // Armazena usuários registrados em memória (mock)
  static final Map<String, Map<String, dynamic>> _cadastros = {};

  Usuario? get usuarioAtual => _usuarioAtual;
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

    if (email != null && tipo != null && uid != null && nome != null && tipo.isNotEmpty) {
      final dados = _cadastros[email.toLowerCase()];
      _usuarioAtual = Usuario(
        uid: uid,
        nome: nome,
        email: email,
        tipo: tipo,
        telefone: dados?['telefone'],
        cpf: dados?['cpf'],
        cep: dados?['cep'],
        cidade: dados?['cidade'],
        endereco: dados?['endereco'],
        especialidade: prefs.getString('usuario_especialidade'),
        valorHora: prefs.getDouble('usuario_valor_hora'),
        biografia: prefs.getString('usuario_biografia'),
      );
      notifyListeners();
    }
  }

  /// Cadastro unificado — salva dados básicos sem logar
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

    await Future.delayed(const Duration(milliseconds: 800));

    final emailKey = email.trim().toLowerCase();

    if (_cadastros.containsKey(emailKey)) {
      _erro = 'E-mail já cadastrado.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    _cadastros[emailKey] = {
      'uid': 'uid_${DateTime.now().millisecondsSinceEpoch}',
      'nome': nome.trim(),
      'email': email.trim(),
      'senha': senha,
      'cpf': cpf,
      'telefone': telefone,
      'cep': cep,
      'endereco': endereco,
      'cidade': cidade,
    };

    _carregando = false;
    notifyListeners();
    return true;
  }

  /// Login — autentica mas não define papel (vai para onboarding)
  Future<bool> login({String email = '', String senha = ''}) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final emailUsado = email.trim().isEmpty ? 'usuario@ineed.com' : email.trim();
    final emailKey = emailUsado.toLowerCase();
    final dados = _cadastros[emailKey];

    if (dados != null) {
      // Usuário cadastrado — usa os dados reais
      _usuarioAtual = Usuario(
        uid: dados['uid'] as String,
        nome: dados['nome'] as String,
        email: emailUsado,
        tipo: '', // papel será escolhido no onboarding
        telefone: dados['telefone'] as String?,
        cpf: dados['cpf'] as String?,
        cep: dados['cep'] as String?,
        cidade: dados['cidade'] as String?,
        endereco: dados['endereco'] as String?,
      );
    } else {
      // Mock de fallback para testes sem cadastro prévio
      _usuarioAtual = Usuario(
        uid: 'mock_uid_${DateTime.now().millisecondsSinceEpoch}',
        nome: emailUsado.contains('prestador') ? 'Prestador Teste' : 'Cliente Teste',
        email: emailUsado,
        tipo: '', // papel será escolhido no onboarding
      );
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

  /// Confirma papel de prestador com info de serviço e persiste a sessão
  Future<void> definirComoPrestador({
    required String especialidade,
    required double valorHora,
    String? biografia,
  }) async {
    if (_usuarioAtual == null) return;
    _usuarioAtual = Usuario(
      uid: _usuarioAtual!.uid,
      nome: _usuarioAtual!.nome,
      email: _usuarioAtual!.email,
      tipo: 'prestador',
      telefone: _usuarioAtual!.telefone,
      cpf: _usuarioAtual!.cpf,
      cep: _usuarioAtual!.cep,
      cidade: _usuarioAtual!.cidade,
      endereco: _usuarioAtual!.endereco,
      especialidade: especialidade,
      valorHora: valorHora,
      biografia: biografia,
    );
    await _salvarSessao();
    notifyListeners();
  }

  /// Logout
  Future<void> logout() async {
    _usuarioAtual = null;
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
    if (_usuarioAtual!.especialidade != null) {
      await prefs.setString('usuario_especialidade', _usuarioAtual!.especialidade!);
    }
    if (_usuarioAtual!.valorHora != null) {
      await prefs.setDouble('usuario_valor_hora', _usuarioAtual!.valorHora!);
    }
    if (_usuarioAtual!.biografia != null) {
      await prefs.setString('usuario_biografia', _usuarioAtual!.biografia!);
    }
  }
}
