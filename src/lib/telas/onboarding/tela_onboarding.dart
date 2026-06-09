// ============================================
// tela_onboarding.dart — Tela inicial de escolha de perfil
// ============================================
// "Como podemos ajudar você hoje?"
// Opções: Cliente ou Prestador

import 'package:flutter/material.dart';
import '../../tema/cores.dart';

class TelaOnboarding extends StatelessWidget {
  const TelaOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ───── Logo ─────
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/logo_ineed.jpeg',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 32),

              // ───── Título ─────
              Text(
                'Como podemos ajudar\nvocê hoje?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: CoresApp.onSurface,
                    ),
              ),

              const SizedBox(height: 48),

              // ───── Card: Quero contratar ─────
              _CardOpcao(
                icone: Icons.search,
                titulo: 'Quero contratar um serviço',
                subtitulo: 'Encontre os melhores profissionais para o que você precisa.',
                aoPresionar: () {
                  Navigator.pushNamed(context, '/cadastro-cliente');
                },
              ),

              const SizedBox(height: 16),

              // ───── Card: Quero prestar ─────
              _CardOpcao(
                icone: Icons.work_outline,
                titulo: 'Quero prestar serviços',
                subtitulo: 'Cadastre suas habilidades e comece a receber propostas.',
                aoPresionar: () {
                  Navigator.pushNamed(context, '/cadastro-prestador');
                },
              ),

              const Spacer(flex: 2),

              // ───── Já tem conta ─────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Já tem uma conta? ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CoresApp.onSurfaceVariant,
                        ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'Fazer Login',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: CoresApp.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardOpcao extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String subtitulo;
  final VoidCallback aoPresionar;

  const _CardOpcao({
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    required this.aoPresionar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: aoPresionar,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CoresApp.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CoresApp.outlineVariant, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: CoresApp.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icone, color: CoresApp.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitulo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: CoresApp.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: CoresApp.outline),
          ],
        ),
      ),
    );
  }
}
