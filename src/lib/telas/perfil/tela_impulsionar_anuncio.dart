// ============================================
// tela_impulsionar_anuncio.dart — Impulsionar anúncio do prestador
// ============================================
// Sem função ainda — só a interface. No futuro, o prestador vai poder
// pagar pra destacar o perfil dele nas buscas dos clientes.

import 'package:flutter/material.dart';
import '../../tema/cores.dart';

class TelaImpulsionarAnuncio extends StatelessWidget {
  const TelaImpulsionarAnuncio({super.key});

  void _emBreve(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Impulsionar anúncio em breve!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.surface,
      appBar: AppBar(
        backgroundColor: CoresApp.surface,
        elevation: 0,
        title: const Text('Impulsionar Anúncio'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00288E), Color(0xFF1565C0)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.rocket_launch_outlined,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Impulsione seu anúncio',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Destaque seu perfil nas buscas dos clientes e apareça em '
                'primeiro entre outros prestadores da sua especialidade.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: CoresApp.onSurfaceVariant,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              _cartaoBeneficio(
                context,
                icone: Icons.trending_up,
                titulo: 'Apareça no topo da busca',
                subtitulo: 'Seu perfil sobe na frente dos outros prestadores',
              ),
              const SizedBox(height: 12),
              _cartaoBeneficio(
                context,
                icone: Icons.visibility_outlined,
                titulo: 'Mais visibilidade',
                subtitulo: 'Mais clientes veem seu perfil e suas avaliações',
              ),
              const SizedBox(height: 12),
              _cartaoBeneficio(
                context,
                icone: Icons.handshake_outlined,
                titulo: 'Mais propostas',
                subtitulo: 'Mais chances de ser chamado pra um serviço novo',
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: CoresApp.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CoresApp.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: CoresApp.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Em breve você vai poder pagar pra impulsionar seu '
                        'perfil por um período. Essa funcionalidade ainda '
                        'está em desenvolvimento.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: CoresApp.onSurface,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _emBreve(context),
                  icon: const Icon(Icons.bolt_outlined),
                  label: const Text('Impulsionar (em breve)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CoresApp.primary,
                    side: BorderSide(color: CoresApp.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cartaoBeneficio(
    BuildContext context, {
    required IconData icone,
    required String titulo,
    required String subtitulo,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CoresApp.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CoresApp.outlineVariant, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icone, color: CoresApp.primary, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitulo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CoresApp.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
