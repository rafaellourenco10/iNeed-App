// ============================================
// tela_cadastro_prestador.dart — Cadastro de Prestador
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../tema/cores.dart';
import '../../widgets/campo_texto.dart';
import '../../widgets/botao_primario.dart';
import '../../servicos/auth_servico.dart';

class TelaCadastroPrestador extends StatefulWidget {
  const TelaCadastroPrestador({super.key});

  @override
  State<TelaCadastroPrestador> createState() => _TelaCadastroPrestadorState();
}

class _TelaCadastroPrestadorState extends State<TelaCadastroPrestador> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _valorHoraController = TextEditingController();
  final _biografiaController = TextEditingController();
  final _senhaController = TextEditingController();
  String? _especialidadeSelecionada;
  bool _mostrarSenha = false;
  bool _aceitouTermos = false;

  final _mascaraTelefone = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  static const List<String> _especialidades = [
    'Faxina',
    'Eletricista',
    'Encanador',
    'Beleza',
    'Pintura',
    'Jardinagem',
    'Montagem de Móveis',
    'Mudança',
    'Pedreiro',
    'Marceneiro',
    'Outro',
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _valorHoraController.dispose();
    _biografiaController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_especialidadeSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione sua especialidade.'),
          backgroundColor: CoresApp.error,
        ),
      );
      return;
    }
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
    final sucesso = await auth.cadastrarPrestador(
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      senha: _senhaController.text,
      especialidade: _especialidadeSelecionada!,
      telefone: _telefoneController.text.trim(),
      valorHora: double.tryParse(
        _valorHoraController.text.replaceAll(',', '.'),
      ),
      biografia: _biografiaController.text.trim(),
    );

    if (!mounted) return;

    if (sucesso) {
      Navigator.pushNamedAndRemoveUntil(context, '/home-prestador', (r) => false);
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
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
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
                  // ───── Logo ─────
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/logo_ineed.jpeg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ───── Título ─────
                  Text(
                    'Criar conta como Prestador',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cadastre sua especialidade e comece a receber propostas.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CoresApp.onSurfaceVariant,
                        ),
                  ),

                  const SizedBox(height: 24),

                  // Nome
                  CampoTexto(
                    rotulo: 'Nome completo',
                    dica: 'Seu nome e sobrenome',
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

                  // Especialidade (Dropdown)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Especialidade Principal',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _especialidadeSelecionada,
                        decoration: InputDecoration(
                          hintText: 'Selecione sua área de atuação',
                          prefixIcon: const Icon(Icons.build_outlined,
                              size: 22, color: CoresApp.outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: _especialidades.map((e) {
                          return DropdownMenuItem(value: e, child: Text(e));
                        }).toList(),
                        onChanged: (v) =>
                            setState(() => _especialidadeSelecionada = v),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Valor por hora
                  CampoTexto(
                    rotulo: 'Valor base por hora (Opcional)',
                    dica: '0,00',
                    iconePrefixo: Icons.attach_money,
                    controlador: _valorHoraController,
                    tipoTeclado: const TextInputType.numberWithOptions(decimal: true),
                  ),

                  const SizedBox(height: 16),

                  // Biografia
                  CampoTexto(
                    rotulo: 'Breve biografia',
                    dica: 'Descreva brevemente sua experiência e os serviços que oferece...',
                    controlador: _biografiaController,
                    maxLinhas: 4,
                  ),

                  const SizedBox(height: 16),

                  // Senha
                  CampoTexto(
                    rotulo: 'Senha',
                    dica: 'Crie uma senha forte',
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
                              const TextSpan(text: ' e a '),
                              TextSpan(
                                text: 'Política de Privacidade',
                                style: TextStyle(
                                  color: CoresApp.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: ' da iNeed.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Botão Cadastrar
                  BotaoPrimario(
                    texto: 'Cadastrar como Prestador',
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
          ),
        ),
      ),
    );
  }
}
