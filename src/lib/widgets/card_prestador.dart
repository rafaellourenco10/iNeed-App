// ============================================
// card_prestador.dart — Card de profissional na listagem
// ============================================

import 'package:flutter/material.dart';
import '../tema/cores.dart';
import '../modelos/usuario.dart';

class CardPrestador extends StatelessWidget {
  final Usuario prestador;
  final VoidCallback? aoVerPerfil;

  const CardPrestador({
    super.key,
    required this.prestador,
    this.aoVerPerfil,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: CoresApp.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───── Header: Avatar + Info + Favorito ─────
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 28,
                  backgroundColor: CoresApp.surfaceContainerHigh,
                  child: Text(
                    prestador.nome.isNotEmpty ? prestador.nome[0].toUpperCase() : 'P',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: CoresApp.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Nome e especialidade
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prestador.nome,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        prestador.especialidade ?? 'Profissional',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: CoresApp.primary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 4),
                      // Avaliação
                      Row(
                        children: [
                          const Icon(Icons.star_outline, size: 16, color: CoresApp.secondaryContainer),
                          const SizedBox(width: 4),
                          Text(
                            (prestador.avaliacao ?? 0).toStringAsFixed(1),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${prestador.totalServicos ?? 0})',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Botão favorito
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border, color: CoresApp.outline),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ───── Tags ─────
            if (prestador.especialidade != null)
              Wrap(
                spacing: 8,
                children: [
                  _buildTag(context, prestador.especialidade!),
                ],
              ),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

            // ───── Preço + Ver Perfil ─────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A partir de',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'R\$ ${(prestador.valorHora ?? 0).toStringAsFixed(0)}/h',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: aoVerPerfil,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CoresApp.secondaryContainer,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(120, 44), // Sobrescreve o infinity do tema
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Ver Perfil',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CoresApp.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
