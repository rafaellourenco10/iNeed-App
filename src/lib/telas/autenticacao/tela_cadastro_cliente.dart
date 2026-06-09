// ============================================
// tela_cadastro_cliente.dart — Cadastro de Cliente
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../tema/cores.dart';
import '../../widgets/campo_texto.dart';
import '../../widgets/botao_primario.dart';
import '../../servicos/auth_servico.dart';

class TelaCadastroCliente extends StatefulWidget {
  const TelaCadastroCliente({super.key});

  @override
  State<TelaCadastroCliente> createState() => _TelaCadastroClienteState();
}

class _TelaCadastroClienteState extends State<TelaCadastroCliente> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _localizacaoController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _mostrarSenha = false;
  bool _aceitouTermos = false;

  final _mascaraTelefone = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _localizacaoController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_aceitouTermos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aceite os termos de serviço para continuar.'),
          backgroundColor: CoresApp.error,
        ),
      );
      return;
    }

    final auth = Provider.of<AuthServico>(context, listen: false);
    final sucesso = await auth.cadastrarCliente(
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      senha: _senhaController.text,
      telefone: _telefoneController.text.trim(),
      localizacao: _localizacaoController.text.trim(),
    );

    if (!mounted) return;

    if (sucesso) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.erro ?? 'Erro ao cadastrar.'),
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
                const SizedBox(height: 40),

                // ───── Logo ─────
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/logo_ineed.jpeg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 24),

                // ───── Container do Formulário ─────
                Container(
                  padding: const EdgeInsets.all(24),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Criar conta como Cliente',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Preencha seus dados para começar a solicitar serviços.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: CoresApp.onSurfaceVariant,
                            ),
                      ),

                      const SizedBox(height: 24),

                      // Nome
                      CampoTexto(
                        rotulo: 'Nome completo',
                        dica: 'Seu nome',
                        iconePrefixo: Icons.person_outline,
                        controlador: _nomeController,
                        validador: (v) =>
                            v == null || v.isEmpty ? 'Digite seu nome' : null,
                      ),

                      const SizedBox(height: 16),

                      // Email
                      CampoTexto(
                        rotulo: 'Email',
                        dica: 'seu@email.com',
                        iconePrefixo: Icons.mail_outline,
                        controlador: _emailController,
                        tipoTeclado: TextInputType.emailAddress,
                        validador: (v) {
                          if (v == null || v.isEmpty) return 'Digite seu e-mail';
                          if (!v.contains('@')) return 'E-mail inválido';
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Telefone
                      CampoTexto(
                        rotulo: 'Telefone',
                        dica: '(00) 00000-0000',
                        iconePrefixo: Icons.phone_outlined,
                        controlador: _telefoneController,
                        tipoTeclado: TextInputType.phone,
                        formatadores: [_mascaraTelefone],
                      ),

                      const SizedBox(height: 16),

                      // Localização
                      CampoTexto(
                        rotulo: 'Localização',
                        dica: 'Seu endereço ou CEP',
                        iconePrefixo: Icons.location_on_outlined,
                        controlador: _localizacaoController,
                        sufixo: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.my_location,
                              color: CoresApp.primary, size: 20),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Senha
                      CampoTexto(
                        rotulo: 'Senha',
                        dica: 'Crie uma senha segura',
                        iconePrefixo: Icons.lock_outline,
                        controlador: _senhaController,
                        obscurecerTexto: !_mostrarSenha,
                        sufixo: IconButton(
                          onPressed: () =>
                              setState(() => _mostrarSenha = !_mostrarSenha),
                          icon: Icon(
                            _mostrarSenha
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: CoresApp.outline,
                          ),
                        ),
                        validador: (v) {
                          if (v == null || v.isEmpty) return 'Digite uma senha';
                          if (v.length < 6) return 'Mínimo 6 caracteres';
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Termos
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _aceitouTermos,
                              onChanged: (v) =>
                                  setState(() => _aceitouTermos = v ?? false),
                              activeColor: CoresApp.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodySmall,
                                children: [
                                  const TextSpan(text: 'Eu concordo com os '),
                                  TextSpan(
                                    text: 'Termos de Serviço',
                                    style: TextStyle(
                                      color: CoresApp.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: ' e '),
                                  TextSpan(
                                    text: 'Política de Privacidade.',
                                    style: TextStyle(
                                      color: CoresApp.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Botão Cadastrar
                      BotaoPrimario(
                        texto: 'Cadastrar',
                        carregando: auth.carregando,
                        aoPresionar: _cadastrar,
                      ),

                      const SizedBox(height: 20),

                      // Já tem conta
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Já tenho uma conta. ',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: CoresApp.onSurfaceVariant,
                                  ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/login'),
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
                      ),
                    ],
                  ),
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
