// ============================================
// auth_servico.dart — Gerenciamento de Autenticação (MOCK PARA TESTE)
// ============================================
// Gerencia login e persistência dos dados do usuário.
// ATUALMENTE: Retorna sucesso automático para testes de interface.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/usuario.dart';

class AuthServico extends ChangeNotifier {
  Usuario? _usuarioAtual;
  bool _carregando = false;
  String? _erro;

  Usuario? get usuarioAtual => _usuarioAtual;
  bool get estaLogado => _usuarioAtual != null;
  bool get carregando => _carregando;
  String? get erro => _erro;

  /// Tenta restaurar a sessão anterior ao iniciar o app
  Future<void> restaurarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('usuario_email');
    final tipo = prefs.getString('usuario_tipo');
    final uid = prefs.getString('usuario_uid');
    final nome = prefs.getString('usuario_nome');

    if (email != null && tipo != null && uid != null && nome != null) {
      _usuarioAtual = Usuario(
        uid: uid,
        nome: nome,
        email: email,
        tipo: tipo,
      );
      notifyListeners();
    }
  }

  /// Cadastrar um novo cliente (MOCK)
  Future<bool> cadastrarCliente({
    required String nome,
    required String email,
    required String senha,
    String? telefone,
    String? localizacao,
  }) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    // Simula tempo de rede
    await Future.delayed(const Duration(seconds: 1));

    _usuarioAtual = Usuario(
      uid: 'mock_uid_cliente',
      nome: nome,
      email: email,
      tipo: 'cliente',
    );
    await _salvarSessao();
    _carregando = false;
    notifyListeners();
    return true;
  }

  /// Cadastrar um novo prestador (MOCK)
  Future<bool> cadastrarPrestador({
    required String nome,
    required String email,
    required String senha,
    required String especialidade,
    String? telefone,
    double? valorHora,
    String? biografia,
  }) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    // Simula tempo de rede
    await Future.delayed(const Duration(seconds: 1));

    _usuarioAtual = Usuario(
      uid: 'mock_uid_prestador',
      nome: nome,
      email: email,
      tipo: 'prestador',
      especialidade: especialidade,
    );
    await _salvarSessao();
    _carregando = false;
    notifyListeners();
    return true;
  }

  /// Login do usuário (MOCK)
  Future<bool> login({
    required String email,
    required String senha,
  }) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    // Simula tempo de rede
    await Future.delayed(const Duration(seconds: 1));

    // Lógica simples de mock: se o email tiver a palavra "prestador", loga como prestador
    if (email.toLowerCase().contains('prestador')) {
      _usuarioAtual = Usuario(
        uid: 'mock_uid_prestador',
        nome: 'Prestador Teste',
        email: email,
        tipo: 'prestador',
        especialidade: 'Eletricista',
      );
    } else {
      _usuarioAtual = Usuario(
        uid: 'mock_uid_cliente',
        nome: 'Cliente Teste',
        email: email,
        tipo: 'cliente',
      );
    }

    await _salvarSessao();
    _carregando = false;
    notifyListeners();
    return true;
  }

  /// Logout
  Future<void> logout() async {
    _usuarioAtual = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  /// Salvar dados mínimos da sessão localmente
  Future<void> _salvarSessao() async {
    if (_usuarioAtual == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario_email', _usuarioAtual!.email);
    await prefs.setString('usuario_tipo', _usuarioAtual!.tipo);
    await prefs.setString('usuario_uid', _usuarioAtual!.uid);
    await prefs.setString('usuario_nome', _usuarioAtual!.nome);
  }
}
