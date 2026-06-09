// ============================================
// shell_navegacao.dart — Scaffold principal com Bottom Nav
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../servicos/auth_servico.dart';
import '../widgets/barra_navegacao.dart';
import 'cliente/tela_home.dart';
import 'prestador/tela_propostas.dart';
import 'perfil/tela_perfil.dart';

class ShellNavegacao extends StatefulWidget {
  final bool isPrestador;

  const ShellNavegacao({super.key, this.isPrestador = false});

  @override
  State<ShellNavegacao> createState() => _ShellNavegacaoState();
}

class _ShellNavegacaoState extends State<ShellNavegacao> {
  int _indiceAtual = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthServico>(context);
    final isPrestador = widget.isPrestador || (auth.usuarioAtual?.isPrestador ?? false);

    final telas = isPrestador
        ? [
            const TelaHome(),           // Início
            const _TelaPlaceholder(titulo: 'Busca', icone: Icons.search), // Busca
            const TelaPropostas(),       // Serviços
            const TelaPerfil(),          // Perfil
          ]
        : [
            const TelaHome(),           // Início
            const _TelaPlaceholder(titulo: 'Busca', icone: Icons.search), // Busca
            const _TelaPlaceholder(titulo: 'Pedidos', icone: Icons.receipt_long), // Pedidos
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

/// Tela placeholder para abas ainda não implementadas
class _TelaPlaceholder extends StatelessWidget {
  final String titulo;
  final IconData icone;

  const _TelaPlaceholder({required this.titulo, required this.icone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              titulo,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey.shade400,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Em desenvolvimento',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
