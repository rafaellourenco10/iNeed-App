import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../servicos/auth_servico.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();

  final _nomeCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _telefoneCtrl = TextEditingController();
  final _cepCtrl = TextEditingController();
  final _enderecoCtrl = TextEditingController();
  final _cidadeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confirmarSenhaCtrl = TextEditingController();

  bool _mostrarSenha = false;
  bool _mostrarConfirmar = false;

  final _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##', filter: {'#': RegExp(r'\d')});
  final _telMask = MaskTextInputFormatter(mask: '(##) #####-####', filter: {'#': RegExp(r'\d')});
  final _cepMask = MaskTextInputFormatter(mask: '#####-###', filter: {'#': RegExp(r'\d')});

  @override
  void dispose() {
    for (final c in [
      _nomeCtrl, _cpfCtrl, _telefoneCtrl, _cepCtrl,
      _enderecoCtrl, _cidadeCtrl, _emailCtrl, _senhaCtrl, _confirmarSenhaCtrl,
    ]) { c.dispose(); }
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthServico>(context, listen: false);
    final sucesso = await auth.registrar(
      nome: _nomeCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      senha: _senhaCtrl.text,
      cpf: _cpfCtrl.text,
      telefone: _telefoneCtrl.text,
      cep: _cepCtrl.text,
      endereco: _enderecoCtrl.text.trim(),
      cidade: _cidadeCtrl.text.trim(),
    );

    if (!mounted) return;

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso! Faça login para continuar.'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      Navigator.pop(context); // volta ao login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.erro ?? 'Erro ao criar conta.'),
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
      appBar: AppBar(
        title: const Text('Criar conta'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        elevation: 0,
        backgroundColor: CoresApp.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dados pessoais',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: CoresApp.primary,
                    ),
              ),
              const SizedBox(height: 16),

              _Campo(
                label: 'Nome completo',
                ctrl: _nomeCtrl,
                icone: Icons.person_outline,
                tipo: TextInputType.name,
                validador: (v) => (v == null || v.trim().length < 3) ? 'Informe o nome completo' : null,
              ),
              const SizedBox(height: 14),

              _Campo(
                label: 'CPF',
                ctrl: _cpfCtrl,
                icone: Icons.badge_outlined,
                tipo: TextInputType.number,
                mascara: _cpfMask,
                validador: (v) => (v == null || v.length < 14) ? 'CPF inválido' : null,
              ),
              const SizedBox(height: 14),

              _Campo(
                label: 'Telefone / WhatsApp',
                ctrl: _telefoneCtrl,
                icone: Icons.phone_outlined,
                tipo: TextInputType.phone,
                mascara: _telMask,
                validador: (v) => (v == null || v.length < 15) ? 'Telefone inválido' : null,
              ),
              const SizedBox(height: 24),

              Text(
                'Endereço',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: CoresApp.primary,
                    ),
              ),
              const SizedBox(height: 16),

              _Campo(
                label: 'CEP',
                ctrl: _cepCtrl,
                icone: Icons.location_on_outlined,
                tipo: TextInputType.number,
                mascara: _cepMask,
                validador: (v) => (v == null || v.length < 9) ? 'CEP inválido' : null,
              ),
              const SizedBox(height: 14),

              _Campo(
                label: 'Endereço (rua, número)',
                ctrl: _enderecoCtrl,
                icone: Icons.home_outlined,
                validador: (v) => (v == null || v.trim().isEmpty) ? 'Informe o endereço' : null,
              ),
              const SizedBox(height: 14),

              _Campo(
                label: 'Cidade',
                ctrl: _cidadeCtrl,
                icone: Icons.location_city_outlined,
                validador: (v) => (v == null || v.trim().isEmpty) ? 'Informe a cidade' : null,
              ),
              const SizedBox(height: 24),

              Text(
                'Acesso',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: CoresApp.primary,
                    ),
              ),
              const SizedBox(height: 16),

              _Campo(
                label: 'E-mail',
                ctrl: _emailCtrl,
                icone: Icons.mail_outline,
                tipo: TextInputType.emailAddress,
                validador: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o e-mail';
                  if (!v.contains('@')) return 'E-mail inválido';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              _CampoSenha(
                label: 'Senha',
                ctrl: _senhaCtrl,
                mostrar: _mostrarSenha,
                toggleMostrar: () => setState(() => _mostrarSenha = !_mostrarSenha),
                validador: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 14),

              _CampoSenha(
                label: 'Confirmar senha',
                ctrl: _confirmarSenhaCtrl,
                mostrar: _mostrarConfirmar,
                toggleMostrar: () => setState(() => _mostrarConfirmar = !_mostrarConfirmar),
                validador: (v) => v != _senhaCtrl.text ? 'Senhas não coincidem' : null,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: auth.carregando ? null : _cadastrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CoresApp.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: auth.carregando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Criar conta',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Já tem conta? ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: CoresApp.onSurfaceVariant),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Fazer login',
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

// ─── Widgets auxiliares ───────────────────────────────────────────────────────

class _Campo extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final IconData icone;
  final TextInputType tipo;
  final MaskTextInputFormatter? mascara;
  final String? Function(String?)? validador;

  const _Campo({
    required this.label,
    required this.ctrl,
    this.icone = Icons.edit_outlined,
    this.tipo = TextInputType.text,
    this.mascara,
    this.validador,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      keyboardType: tipo,
      inputFormatters: mascara != null ? [mascara!] : [],
      validator: validador,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icone, size: 20),
        filled: true,
        fillColor: CoresApp.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CoresApp.outlineVariant, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CoresApp.outlineVariant, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CoresApp.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CoresApp.error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _CampoSenha extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final bool mostrar;
  final VoidCallback toggleMostrar;
  final String? Function(String?)? validador;

  const _CampoSenha({
    required this.label,
    required this.ctrl,
    required this.mostrar,
    required this.toggleMostrar,
    this.validador,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      obscureText: !mostrar,
      validator: validador,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline, size: 20),
        suffixIcon: IconButton(
          onPressed: toggleMostrar,
          icon: Icon(
            mostrar ? Icons.visibility : Icons.visibility_off,
            size: 20,
            color: CoresApp.outline,
          ),
        ),
        filled: true,
        fillColor: CoresApp.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CoresApp.outlineVariant, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CoresApp.outlineVariant, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CoresApp.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CoresApp.error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
