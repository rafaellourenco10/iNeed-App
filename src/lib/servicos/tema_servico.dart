// ============================================
// tema_servico.dart — Preferência de tema (claro/escuro)
// ============================================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../tema/cores.dart';

class TemaServico extends ChangeNotifier {
  bool _escuro = false;
  bool get escuro => _escuro;

  /// Carrega a preferência salva e aplica em CoresApp — chamado uma vez
  /// na inicialização do app.
  Future<void> carregarPreferencia() async {
    final prefs = await SharedPreferences.getInstance();
    _escuro = prefs.getBool('tema_escuro') ?? false;
    CoresApp.definirBrilho(_escuro ? Brightness.dark : Brightness.light);
    notifyListeners();
  }

  Future<void> alternar(bool escuro) async {
    _escuro = escuro;
    CoresApp.definirBrilho(escuro ? Brightness.dark : Brightness.light);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tema_escuro', escuro);
  }
}
