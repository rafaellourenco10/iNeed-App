// ============================================
// area_atualizavel.dart — "Puxar pra atualizar" em conteúdo que não rola
// ============================================
// O RefreshIndicator só reage se houver algo rolável embaixo dele. Estados
// vazios ou de erro (um ícone + texto centralizado) não rolam, então o
// gesto não funciona justo quando o usuário mais espera algo novo aparecer.
// Este widget embrulha esse conteúdo numa área rolável do tamanho da tela.

import 'package:flutter/material.dart';

class AreaAtualizavel extends StatelessWidget {
  final Future<void> Function() aoAtualizar;
  final Widget child;

  const AreaAtualizavel({
    super.key,
    required this.aoAtualizar,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: aoAtualizar,
      child: LayoutBuilder(
        builder: (context, limites) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(height: limites.maxHeight, child: child),
        ),
      ),
    );
  }
}
