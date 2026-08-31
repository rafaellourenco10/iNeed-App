// ============================================
// tela_login.dart — Tela de Login
// ============================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../widgets/campo_texto.dart';
import '../../servicos/auth_servico.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> with TickerProviderStateMixin {
  // ── Animações ────────────────────────────────────────────────
  late AnimationController _ctrl;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _heroTextFade;
  late Animation<Offset> _heroTextSlide;
  late Animation<double> _formFade;
  late Animation<Offset> _formSlide;

  // ── Fundo animado (prestadores passando) ────────────────────
  late AnimationController _bgCtrl;
  static const _fotosPrestadores = [
    'assets/images/eletrecista.jpeg',
    'assets/images/encanador.jpeg',
    'assets/images/pintor.jpeg',
    'assets/images/faxina.jpeg',
    'assets/images/entregador.jpeg',
  ];
  static const _larguraCardFoto = 108.0;
  static const _alturaCardFoto = 150.0;
  static const _espacamentoCardFoto = 18.0;

  // ── Formulário ───────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _identificadorController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _mostrarSenha = false;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );
    _heroTextFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.3, 0.62, curve: Curves.easeOut),
    );
    _heroTextSlide =
        Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.3, 0.62, curve: Curves.easeOut),
          ),
        );
    _formFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.52, 0.85, curve: Curves.easeOut),
    );
    _formSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.52, 0.85, curve: Curves.easeOut),
          ),
        );

    _ctrl.forward();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _bgCtrl.dispose();
    _identificadorController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  // Faixa de fotos dos prestadores deslizando ao fundo do hero
  Widget _buildFaixaPrestadores() {
    final fotos = [..._fotosPrestadores, ..._fotosPrestadores];
    const passo = _larguraCardFoto + _espacamentoCardFoto;
    final larguraConjunto = passo * _fotosPrestadores.length;

    return ClipRect(
      child: OverflowBox(
        maxWidth: double.infinity,
        alignment: Alignment.centerLeft,
        child: AnimatedBuilder(
          animation: _bgCtrl,
          builder: (context, _) {
            final deslocamentoX = -(_bgCtrl.value * larguraConjunto);
            return Transform.translate(
              offset: Offset(deslocamentoX, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < fotos.length; i++)
                    Transform.translate(
                      offset: Offset(0, i.isEven ? -12 : 12),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: _espacamentoCardFoto,
                        ),
                        child: Opacity(
                          opacity: 0.75,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.asset(
                              fotos[i],
                              width: _larguraCardFoto,
                              height: _alturaCardFoto,
                              fit: BoxFit.cover,
                              color: const Color(
                                0xFF0D3FA8,
                              ).withValues(alpha: 0.35),
                              colorBlendMode: BlendMode.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _fazerLogin() async {
    final auth = Provider.of<AuthServico>(context, listen: false);
    final sucesso = await auth.login(
      identificador: _identificadorController.text.trim(),
      senha: _senhaController.text,
    );

    if (!mounted) return;

    if (sucesso) {
      Navigator.pushNamedAndRemoveUntil(context, '/explicacao', (r) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.erro ?? 'Erro ao fazer login.'),
          backgroundColor: CoresApp.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthServico>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // ───── Hero Gradiente ─────────────────────────────
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF00288E), Color(0xFF1565C0)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Prestadores passando ao fundo
                        Positioned.fill(child: _buildFaixaPrestadores()),

                        // Camada de cor por cima das fotos (contraste do texto)
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(
                                    0xFF00288E,
                                  ).withValues(alpha: 0.45),
                                  const Color(
                                    0xFF1565C0,
                                  ).withValues(alpha: 0.45),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            20,
                            48 + MediaQuery.paddingOf(context).top,
                            20,
                            64,
                          ),
                          child: Column(
                            children: [
                              // Logo com escala + fade + sombra
                              FadeTransition(
                                opacity: _logoFade,
                                child: ScaleTransition(
                                  scale: _logoScale,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(26),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withValues(
                                            alpha: 0.25,
                                          ),
                                          blurRadius: 48,
                                          spreadRadius: 6,
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.25,
                                          ),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(26),
                                      child: Image.asset(
                                        'assets/images/logo_ineed.jpeg',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 22),

                              // Texto "iNeed" + subtítulo com slide + fade
                              FadeTransition(
                                opacity: _heroTextFade,
                                child: SlideTransition(
                                  position: _heroTextSlide,
                                  child: Column(
                                    children: [
                                      Text(
                                        'iNeed',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -1.0,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.35,
                                              ),
                                              blurRadius: 24,
                                              offset: const Offset(0, 6),
                                            ),
                                            Shadow(
                                              color: const Color(
                                                0xFF001A6B,
                                              ).withValues(alpha: 0.6),
                                              blurRadius: 40,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Serviços sob demanda',
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.85,
                                          ),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.8,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.2,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ───── Card do Formulário com fade + slide ────────
                  FadeTransition(
                    opacity: _formFade,
                    child: SlideTransition(
                      position: _formSlide,
                      child: Transform.translate(
                        offset: const Offset(0, -28),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(28),
                              topRight: Radius.circular(28),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF00288E,
                                ).withValues(alpha: 0.18),
                                blurRadius: 30,
                                offset: const Offset(0, -8),
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 16,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Título ───────────────────────────
                              Text(
                                'Bem-vindo',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Acesse sua conta para continuar.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: CoresApp.onSurfaceVariant,
                                    ),
                              ),

                              const SizedBox(height: 32),

                              // ── Email / CPF / Celular ─────────────
                              CampoTexto(
                                dica: 'E-mail, CPF ou celular',
                                iconePrefixo: Icons.person_outline,
                                controlador: _identificadorController,
                                tipoTeclado: TextInputType.text,
                                validador: (_) => null,
                              ),

                              const SizedBox(height: 16),

                              // ── Senha ─────────────────────────────
                              CampoTexto(
                                dica: 'Sua senha',
                                iconePrefixo: Icons.lock_outline,
                                controlador: _senhaController,
                                obscurecerTexto: !_mostrarSenha,
                                sufixo: IconButton(
                                  onPressed: () => setState(
                                    () => _mostrarSenha = !_mostrarSenha,
                                  ),
                                  icon: Icon(
                                    _mostrarSenha
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: CoresApp.outline,
                                  ),
                                ),
                                validador: (_) => null,
                              ),

                              const SizedBox(height: 8),

                              // ── Esqueceu a senha ──────────────────
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Em breve!'),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Esqueceu a senha?',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: CoresApp.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // ── Botão Entrar ──────────────────────
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF00288E),
                                      Color(0xFF1565C0),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF00288E,
                                      ).withValues(alpha: 0.35),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: auth.carregando
                                      ? null
                                      : _fazerLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    minimumSize: const Size(
                                      double.infinity,
                                      52,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: auth.carregando
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : const Text(
                                          'Entrar',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // ── Cadastre-se ───────────────────────
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Não tem uma conta? ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: CoresApp.onSurfaceVariant,
                                        ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      '/cadastro',
                                    ),
                                    child: Text(
                                      'Cadastre-se',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: CoresApp.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 32),

                              // ── Separador ─────────────────────────
                              Row(
                                children: [
                                  const Expanded(child: Divider()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      'Ou entre com',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: CoresApp.onSurfaceVariant,
                                          ),
                                    ),
                                  ),
                                  const Expanded(child: Divider()),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // ── Login Social ──────────────────────
                              OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Login com Google em breve!',
                                      ),
                                    ),
                                  );
                                },
                                icon: const Text(
                                  'G',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                label: const Text('Google'),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: const BorderSide(
                                    color: CoresApp.outlineVariant,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Login com Apple em breve!',
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.apple, size: 24),
                                label: const Text('Apple'),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: const BorderSide(
                                    color: CoresApp.outlineVariant,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
