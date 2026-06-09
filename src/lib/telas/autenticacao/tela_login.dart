// ============================================
// tela_login.dart — Tela de Login
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../widgets/campo_texto.dart';
import '../../widgets/botao_primario.dart';
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
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthServico>(context, listen: false);
    final sucesso = await auth.login(
      email: _emailController.text.trim(),
      senha: _senhaController.text,
    );

    if (!mounted) return;

    if (sucesso) {
      final usuario = auth.usuarioAtual;
      if (usuario != null && usuario.isPrestador) {
        Navigator.pushNamedAndRemoveUntil(context, '/home-prestador', (r) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
      }
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),

                // ───── Logo ─────
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/logo_ineed.jpeg',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 32),

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

                const SizedBox(height: 40),

                // ───── Email ─────
                CampoTexto(
                  dica: 'Seu e-mail',
                  iconePrefixo: Icons.mail_outline,
                  controlador: _emailController,
                  tipoTeclado: TextInputType.emailAddress,
                  validador: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Digite seu e-mail';
                    }
                    if (!valor.contains('@')) {
                      return 'E-mail inválido';
                    }
                    return null;
                  },
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
                  validador: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Digite sua senha';
                    }
                    return null;
                  },
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

                // ───── Botão Entrar ─────
                BotaoPrimario(
                  texto: 'Entrar',
                  carregando: auth.carregando,
                  aoPresionar: _fazerLogin,
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
                      onTap: () => Navigator.pushNamed(context, '/onboarding'),
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
      ),
    );
  }
}
