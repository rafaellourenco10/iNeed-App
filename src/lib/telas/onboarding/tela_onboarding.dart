// ============================================
// tela_onboarding.dart — Tela inicial de escolha de perfil
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../servicos/auth_servico.dart';

class TelaOnboarding extends StatefulWidget {
  const TelaOnboarding({super.key});

  @override
  State<TelaOnboarding> createState() => _TelaOnboardingState();
}

class _TelaOnboardingState extends State<TelaOnboarding>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _cardsFade;
  late Animation<Offset> _cardsSlide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );
    _titleFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
          ),
        );
    _cardsFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.58, 0.9, curve: Curves.easeOut),
    );
    _cardsSlide = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.58, 0.9, curve: Curves.easeOut),
          ),
        );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    foregroundColor: CoresApp.onSurface,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // ───── Logo com fade + escala ─────
              FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF00288E,
                          ).withValues(alpha: 0.18),
                          blurRadius: 40,
                          spreadRadius: 2,
                          offset: const Offset(0, 12),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(
                        'assets/images/logo_ineed.jpeg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // ───── Título com slide + fade ─────
              FadeTransition(
                opacity: _titleFade,
                child: SlideTransition(
                  position: _titleSlide,
                  child: Column(
                    children: [
                      Text(
                        'Como podemos ajudar\nvocê hoje?',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: CoresApp.onSurface,
                              shadows: [
                                Shadow(
                                  color: const Color(
                                    0xFF00288E,
                                  ).withValues(alpha: 0.12),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Escolha como deseja usar o iNeed',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CoresApp.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // ───── Cards com slide + fade ─────
              FadeTransition(
                opacity: _cardsFade,
                child: SlideTransition(
                  position: _cardsSlide,
                  child: Column(
                    children: [
                      _CardOpcao(
                        icone: Icons.search,
                        titulo: 'Sou cliente',
                        subtitulo:
                            'Encontre os melhores profissionais para o que você precisa.',
                        aoPresionar: () async {
                          final auth = Provider.of<AuthServico>(
                            context,
                            listen: false,
                          );
                          await auth.definirComoCliente();
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (r) => false,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      _CardOpcao(
                        icone: Icons.work_outline,
                        titulo: 'Sou prestador de serviço',
                        subtitulo:
                            'Informe suas habilidades e comece a receber pedidos.',
                        aoPresionar: () {
                          final auth = Provider.of<AuthServico>(
                            context,
                            listen: false,
                          );
                          if (auth.usuarioAtual == null || auth.token == null) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (r) => false,
                            );
                            return;
                          }
                          Navigator.pushNamed(context, '/completar-prestador');
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardOpcao extends StatefulWidget {
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
  State<_CardOpcao> createState() => _CardOpcaoState();
}

class _CardOpcaoState extends State<_CardOpcao> {
  bool _pressionado = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressionado = true),
      onTapUp: (_) {
        setState(() => _pressionado = false);
        widget.aoPresionar();
      },
      onTapCancel: () => setState(() => _pressionado = false),
      child: AnimatedScale(
        scale: _pressionado ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: _pressionado
                ? [
                    BoxShadow(
                      color: const Color(0xFF00288E).withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: const Color(0xFF00288E).withValues(alpha: 0.12),
                      blurRadius: 32,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF00288E).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(widget.icone, color: CoresApp.primary, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.titulo,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitulo,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CoresApp.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF00288E).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: CoresApp.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
