// ============================================
// card_proposta.dart — Card de proposta de serviço
// ============================================

import 'package:flutter/material.dart';
import '../tema/cores.dart';
import '../modelos/proposta.dart';

class CardProposta extends StatelessWidget {
  final Proposta proposta;
  final VoidCallback? aoAceitar;
  final VoidCallback? aoRecusar;

  const CardProposta({
    super.key,
    required this.proposta,
    this.aoAceitar,
    this.aoRecusar,
  });

  Color _corStatus() {
    switch (proposta.status) {
      case 'pendente':
        return CoresApp.statusPendente;
      case 'aceita':
      case 'em_andamento':
        return CoresApp.statusEmAndamento;
      case 'concluida':
        return CoresApp.statusConcluida;
      case 'recusada':
        return CoresApp.statusRecusada;
      default:
        return CoresApp.outline;
    }
  }

  String _textoStatus() {
    switch (proposta.status) {
      case 'pendente':
        return 'Pendente';
      case 'aceita':
        return 'Aceita';
      case 'em_andamento':
        return 'Em Andamento';
      case 'concluida':
        return 'Concluída';
      case 'recusada':
        return 'Recusada';
      default:
        return proposta.status;
    }
  }

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
            // ───── Status + Valor ─────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Chip de status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _corStatus().withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _textoStatus(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _corStatus(),
                    ),
                  ),
                ),
                Text(
                  'R\$ ${proposta.valor.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: CoresApp.primary,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ───── Título ─────
            Text(
              proposta.titulo,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),

            const SizedBox(height: 12),

            // ───── Cliente info ─────
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: CoresApp.surfaceContainerHigh,
                  child: Text(
                    proposta.nomeCliente.isNotEmpty
                        ? proposta.nomeCliente[0].toUpperCase()
                        : 'C',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: CoresApp.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      proposta.nomeCliente,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (proposta.endereco != null)
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 14, color: CoresApp.outline),
                          const SizedBox(width: 4),
                          Text(
                            proposta.endereco!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ───── Data e Horário ─────
            if (proposta.data != null || proposta.horario != null)
              Column(
                children: [
                  if (proposta.data != null)
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 16, color: CoresApp.outline),
                        const SizedBox(width: 8),
                        Text(
                          proposta.data!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  if (proposta.horario != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time_outlined,
                            size: 16, color: CoresApp.outline),
                        const SizedBox(width: 8),
                        Text(
                          proposta.horario!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ],
              ),

            // ───── Botões Aceitar/Recusar (apenas para pendentes) ─────
            if (proposta.isPendente) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: aoRecusar,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: CoresApp.onSurface,
                        side: const BorderSide(color: CoresApp.outlineVariant),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Recusar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: aoAceitar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CoresApp.primary,
                        foregroundColor: CoresApp.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: const Text('Aceitar'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
