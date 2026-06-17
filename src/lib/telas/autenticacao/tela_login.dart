// ============================================
// tela_login.dart — Tela de Login
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../widgets/campo_texto.dart';
import '../../servicos/auth_servico.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _mostrarSenha = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    final auth = Provider.of<AuthServico>(context, listen: false);
    final sucesso = await auth.login(
      email: _emailController.text.trim(),
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

    return Scaffold(
      backgroundColor: CoresApp.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ───── Bloco topo com gradiente ─────
                Container(
                  width: double.infinity,
                  height: 240,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF00288E), Color(0xFF1565C0)],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/logo_ineed.jpeg',
                          width: 72,
                          height: 72,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'iNeed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Serviços sob demanda',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // ───── Bloco form com sobreposição ─────
                Transform.translate(
                  offset: const Offset(0, -28),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ───── Título ─────
                        Text(
                          'Bem-vindo de volta',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Acesse sua conta para continuar.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: CoresApp.onSurfaceVariant,
                              ),
                        ),

                        const SizedBox(height: 32),

                        // ───── Email ─────
                        CampoTexto(
                          dica: 'Seu e-mail',
                          iconePrefixo: Icons.mail_outline,
                          controlador: _emailController,
                          tipoTeclado: TextInputType.emailAddress,
                          validador: (_) => null,
                        ),

                        const SizedBox(height: 16),

                        // ───── Senha ─────
                        CampoTexto(
                          dica: 'Sua senha',
                          iconePrefixo: Icons.lock_outline,
                          controlador: _senhaController,
                          obscurecerTexto: !_mostrarSenha,
                          sufixo: IconButton(
                            onPressed: () => setState(() => _mostrarSenha = !_mostrarSenha),
                            icon: Icon(
                              _mostrarSenha ? Icons.visibility : Icons.visibility_off,
                              color: CoresApp.outline,
                            ),
                          ),
                          validador: (_) => null,
                        ),

                        const SizedBox(height: 8),

                        // ───── Esqueceu a senha ─────
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Em breve!')),
                              );
                            },
                            child: Text(
                              'Esqueceu a senha?',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: CoresApp.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ───── Botão Entrar com gradiente ─────
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00288E), Color(0xFF1565C0)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: auth.carregando ? null : _fazerLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              minimumSize: const Size(double.infinity, 52),
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

                        const SizedBox(height: 32),

                        // ───── Separador "Ou entre com" ─────
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Ou entre com',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: CoresApp.onSurfaceVariant,
                                    ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ───── Login Social (visual apenas) ─────
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login com Google em breve!')),
                            );
                          },
                          icon: const Text('G', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                          label: const Text('Google'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: CoresApp.outlineVariant),
                          ),
                        ),

                        const SizedBox(height: 12),

                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login com Apple em breve!')),
                            );
                          },
                          icon: const Icon(Icons.apple, size: 24),
                          label: const Text('Apple'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: CoresApp.outlineVariant),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // ───── Cadastre-se ─────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Não tem uma conta? ',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: CoresApp.onSurfaceVariant,
                                  ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/cadastro'),
                              child: Text(
                                'Cadastre-se',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
