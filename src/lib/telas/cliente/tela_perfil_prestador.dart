// ============================================
// tela_perfil_prestador.dart — Perfil completo do prestador
// ============================================

import 'package:flutter/material.dart';
import '../../tema/cores.dart';
import '../../modelos/usuario.dart';

class TelaPerfilPrestador extends StatelessWidget {
  final Usuario prestador;

  const TelaPerfilPrestador({super.key, required this.prestador});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.surface,
      appBar: AppBar(
        title: const Text('Perfil do Prestador'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ───── Avatar e Info Principal ─────
            CircleAvatar(
              radius: 50,
              backgroundColor: CoresApp.surfaceContainerHigh,
              child: Text(
                prestador.nome.isNotEmpty
                    ? prestador.nome[0].toUpperCase()
                    : 'P',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: CoresApp.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  prestador.nome,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.verified, color: CoresApp.primary, size: 20),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              prestador.especialidade ?? 'Profissional',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: CoresApp.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),

            // ───── Avaliação e Serviços ─────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star,
                  color: CoresApp.secondaryContainer,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  (prestador.avaliacao ?? 0).toStringAsFixed(1),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 16),
                Text(
                  '${prestador.totalServicos ?? 0}+ serviços',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CoresApp.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ───── Stats Cards ─────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStatCard(context, Icons.access_time, '1h', 'Resposta'),
                  const SizedBox(width: 12),
                  _buildStatCard(context, Icons.work_outline, '5', 'Anos Exp.'),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    context,
                    Icons.location_on_outlined,
                    '2km',
                    'Distância',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ───── Sobre ─────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CoresApp.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sobre',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      prestador.biografia ??
                          'Profissional dedicado com ampla experiência na área de ${prestador.especialidade ?? "serviços"}. Comprometido em entregar trabalhos de qualidade com pontualidade e eficiência.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CoresApp.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ───── Especialidades (chips) ─────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Especialidades',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (prestador.especialidade != null)
                        _buildChip(prestador.especialidade!),
                      _buildChip('Residencial'),
                      _buildChip('Pós-obra'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ───── Avaliações ─────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Avaliações (${prestador.totalServicos ?? 0})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAvaliacaoItem(
                    context,
                    nome: 'Mariana Costa',
                    tempo: 'Há 2 dias',
                    estrelas: 5,
                    comentario:
                        'Serviço impecável! Muito pontual e profissional. Com certeza contratarei novamente.',
                  ),
                  const SizedBox(height: 12),
                  _buildAvaliacaoItem(
                    context,
                    nome: 'Rafael Almeida',
                    tempo: 'Semana passada',
                    estrelas: 4,
                    comentario:
                        'Muito detalhista, especialmente na área de ${prestador.especialidade ?? "serviços"}. Recomendo o trabalho.',
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Ver todas as avaliações'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ───── Logo footer ─────
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo_ineed.jpeg',
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // ───── Botões fixos ─────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
          child: Row(
            children: [
              // ── Solicitar Orçamento ──
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Solicitação de orçamento enviada!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: const Text('Orçamento'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CoresApp.primary,
                    side: const BorderSide(color: CoresApp.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // ── Contratar Serviço ──
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/nova-proposta',
                      arguments: prestador,
                    );
                  },
                  icon: const Icon(Icons.handshake_outlined),
                  label: const Text('Contratar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CoresApp.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String valor,
    String label,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: CoresApp.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CoresApp.outlineVariant, width: 0.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: CoresApp.primary, size: 22),
            const SizedBox(height: 8),
            Text(
              valor,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: CoresApp.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: CoresApp.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CoresApp.outlineVariant),
      ),
      child: Text(
        texto,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildAvaliacaoItem(
    BuildContext context, {
    required String nome,
    required String tempo,
    required int estrelas,
    required String comentario,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CoresApp.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CoresApp.outlineVariant, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: CoresApp.surfaceContainerHigh,
                child: Text(
                  nome[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: CoresApp.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nome,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(tempo, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < estrelas ? Icons.star : Icons.star_border,
                    size: 16,
                    color: CoresApp.secondaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comentario,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
