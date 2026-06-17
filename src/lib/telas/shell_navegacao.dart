// ============================================
// shell_navegacao.dart — Scaffold principal com Bottom Nav
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../servicos/auth_servico.dart';
import '../widgets/barra_navegacao.dart';
import 'cliente/tela_home.dart';
import 'cliente/tela_pedidos.dart';
import 'prestador/tela_home_prestador.dart';
import 'prestador/tela_busca_prestador.dart';
import 'prestador/tela_propostas.dart';
import 'perfil/tela_perfil.dart';

class ShellNavegacao extends StatefulWidget {
  final bool isPrestador;
  final int indiceInicial;

  const ShellNavegacao({super.key, this.isPrestador = false, this.indiceInicial = 0});

  @override
  State<ShellNavegacao> createState() => _ShellNavegacaoState();
}

class _ShellNavegacaoState extends State<ShellNavegacao> {
  late int _indiceAtual;

  @override
  void initState() {
    super.initState();
    _indiceAtual = widget.indiceInicial;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthServico>(context);
    final isPrestador = widget.isPrestador || (auth.usuarioAtual?.isPrestador ?? false);

    final telas = isPrestador
        ? [
            const TelaHomePrestador(),      // Início
            const TelaBuscaPrestador(),    // Busca
            const TelaPropostas(),       // Serviços
            const TelaPerfil(),          // Perfil
          ]
        : [
            const TelaHome(),           // Início
            const TelaPedidos(),        // Pedidos
            const TelaPerfil(),          // Perfil
          ];

    return Scaffold(
      body: IndexedStack(
        index: _indiceAtual,
        children: telas,
      ),
      bottomNavigationBar: BarraNavegacao(
        indiceAtual: _indiceAtual,
        isPrestador: isPrestador,
        aoMudar: (indice) {
          setState(() => _indiceAtual = indice);
        },
      ),
    );
  }
}

