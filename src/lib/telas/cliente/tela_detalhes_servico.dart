// ============================================
// tela_detalhes_servico.dart — Detalhes de um serviço contratado
// ============================================

import 'package:flutter/material.dart';
import '../../tema/cores.dart';
import '../../modelos/proposta.dart';
import '../../widgets/botao_primario.dart';

class TelaDetalhesServico extends StatelessWidget {
  final Proposta proposta;

  const TelaDetalhesServico({super.key, required this.proposta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.surface,
      appBar: AppBar(
        title: const Text('Detalhes do Serviço'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/images/logo_ineed.jpeg',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ───── Mapa placeholder ─────
            Container(
              margin: const EdgeInsets.all(16),
              height: 200,
              decoration: BoxDecoration(
                color: CoresApp.tertiaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  // Placeholder de mapa
                  Center(
                    child: Icon(
                      Icons.location_on,
                      size: 48,
                      color: CoresApp.primary,
                    ),
                  ),
                  // Endereço
                  if (proposta.endereco != null)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: CoresApp.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: CoresApp.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              proposta.endereco!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ───── Info do Serviço ─────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CoresApp.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CoresApp.outlineVariant, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          proposta.titulo,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      _buildStatusChip(context),
                    ],
                  ),
                  if (proposta.data != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: CoresApp.outline,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          proposta.data!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (proposta.horario != null) ...[
                          Text(
                            ', ${proposta.horario}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Valor Acordado',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CoresApp.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'R\$ ${proposta.valor.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: CoresApp.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ───── Info do Prestador ─────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CoresApp.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CoresApp.outlineVariant, width: 0.5),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: CoresApp.surfaceContainerHigh,
                    child: Text(
                      (proposta.nomePrestador ?? 'P')[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: CoresApp.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          proposta.nomePrestador ?? 'Prestador',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Profissional',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: CoresApp.secondaryContainer,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '4.9',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ───── Contato ─────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CoresApp.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 20,
                        color: CoresApp.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dúvidas sobre o serviço?',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Fale diretamente com o profissional.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Chat em breve!')),
                      );
                    },
                    icon: const Icon(Icons.chat_outlined),
                    label: const Text('Abrir Chat'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ───── Botões de Ação ─────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  if (proposta.isEmAndamento || proposta.isAceita)
                    BotaoPrimario(
                      texto: 'Finalizar Serviço',
                      icone: Icons.check_circle_outline,
                      aoPresionar: () {
                        Navigator.pushNamed(
                          context,
                          '/avaliar-servico',
                          arguments: proposta,
                        );
                      },
                    ),
                  if (proposta.isPendente || proposta.isEmAndamento) ...[
                    const SizedBox(height: 12),
                    BotaoPrimario(
                      texto: 'Cancelar Proposta',
                      tipo: TipoBotao.perigo,
                      aoPresionar: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color cor;
    String texto;
    switch (proposta.status) {
      case 'em_andamento':
        cor = CoresApp.statusEmAndamento;
        texto = 'Em Andamento';
        break;
      case 'concluida':
        cor = CoresApp.statusConcluida;
        texto = 'Concluída';
        break;
      case 'pendente':
        cor = CoresApp.statusPendente;
        texto = 'Pendente';
        break;
      default:
        cor = CoresApp.outline;
        texto = proposta.status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cor),
      ),
    );
  }
}
