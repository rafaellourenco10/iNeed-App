// ============================================
// barra_navegacao.dart — Bottom Navigation Bar customizada
// ============================================

import 'package:flutter/material.dart';
import '../tema/cores.dart';

class BarraNavegacao extends StatelessWidget {
  final int indiceAtual;
  final ValueChanged<int> aoMudar;
  final bool isPrestador;

  const BarraNavegacao({
    super.key,
    required this.indiceAtual,
    required this.aoMudar,
    this.isPrestador = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CoresApp.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: isPrestador
                ? [
                    _buildItem(context, 0, Icons.home_outlined, Icons.home, 'Início'),
                    _buildItem(context, 1, Icons.search_outlined, Icons.search, 'Busca'),
                    _buildItemDestaque(context, 2, Icons.build_outlined, Icons.build, 'Serviços'),
                    _buildItem(context, 3, Icons.person_outline, Icons.person, 'Perfil'),
                  ]
                : [
                    _buildItem(context, 0, Icons.home_outlined, Icons.home, 'Início'),
                    _buildItem(context, 1, Icons.search_outlined, Icons.search, 'Busca'),
                    _buildItem(context, 2, Icons.receipt_long_outlined, Icons.receipt_long, 'Pedidos'),
                    _buildItem(context, 3, Icons.person_outline, Icons.person, 'Perfil'),
                  ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    int indice,
    IconData iconeInativo,
    IconData iconeAtivo,
    String rotulo,
  ) {
    final selecionado = indice == indiceAtual;
    return InkWell(
      onTap: () => aoMudar(indice),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selecionado ? iconeAtivo : iconeInativo,
              color: selecionado ? CoresApp.primary : CoresApp.outline,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              rotulo,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selecionado ? FontWeight.w600 : FontWeight.w400,
                color: selecionado ? CoresApp.primary : CoresApp.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemDestaque(
    BuildContext context,
    int indice,
    IconData iconeInativo,
    IconData iconeAtivo,
    String rotulo,
  ) {
    final selecionado = indice == indiceAtual;
    return InkWell(
      onTap: () => aoMudar(indice),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: selecionado
            ? BoxDecoration(
                color: CoresApp.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selecionado ? iconeAtivo : iconeInativo,
              color: selecionado ? Colors.white : CoresApp.outline,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              rotulo,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selecionado ? FontWeight.w600 : FontWeight.w400,
                color: selecionado ? Colors.white : CoresApp.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
