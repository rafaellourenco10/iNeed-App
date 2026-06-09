// ============================================
// chip_categoria.dart — Chip de categoria com ícone
// ============================================

import 'package:flutter/material.dart';
import '../tema/cores.dart';

class ChipCategoria extends StatelessWidget {
  final String nome;
  final IconData icone;
  final bool selecionado;
  final VoidCallback? aoPresionar;

  const ChipCategoria({
    super.key,
    required this.nome,
    required this.icone,
    this.selecionado = false,
    this.aoPresionar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: aoPresionar,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: selecionado
                  ? CoresApp.primary
                  : CoresApp.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selecionado
                    ? CoresApp.primary
                    : CoresApp.outlineVariant,
                width: selecionado ? 2 : 1,
              ),
            ),
            child: Icon(
              icone,
              size: 28,
              color: selecionado ? Colors.white : CoresApp.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            nome,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selecionado ? FontWeight.w600 : FontWeight.w400,
              color: selecionado ? CoresApp.primary : CoresApp.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Categorias padrão do iNeed com ícones
  static List<Map<String, dynamic>> get categoriasPadrao => [
        {'nome': 'Faxina', 'icone': Icons.cleaning_services},
        {'nome': 'Eletricista', 'icone': Icons.electrical_services},
        {'nome': 'Encanador', 'icone': Icons.plumbing},
        {'nome': 'Beleza', 'icone': Icons.spa},
        {'nome': 'Pintura', 'icone': Icons.format_paint},
        {'nome': 'Jardinagem', 'icone': Icons.yard},
        {'nome': 'Montagem', 'icone': Icons.handyman},
        {'nome': 'Mudança', 'icone': Icons.local_shipping},
      ];
}
