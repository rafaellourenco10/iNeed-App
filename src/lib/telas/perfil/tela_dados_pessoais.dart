// ============================================
// tela_dados_pessoais.dart — Editar dados pessoais
// ============================================

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../servicos/auth_servico.dart';

class TelaDadosPessoais extends StatefulWidget {
  const TelaDadosPessoais({super.key});

  @override
  State<TelaDadosPessoais> createState() => _TelaDadosPessoaisState();
}

class _TelaDadosPessoaisState extends State<TelaDadosPessoais> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeCtrl;
  late final TextEditingController _cpfCtrl;
  late final TextEditingController _telefoneCtrl;
  late final TextEditingController _cepCtrl;
  late final TextEditingController _enderecoCtrl;
  late final TextEditingController _cidadeCtrl;

  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'\d')},
  );
  final _telMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'\d')},
  );
  final _cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp(r'\d')},
  );

  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    final usuario = Provider.of<AuthServico>(
      context,
      listen: false,
    ).usuarioAtual;

    _nomeCtrl = TextEditingController(text: usuario?.nome ?? '');
    _cpfCtrl = TextEditingController(text: usuario?.cpf ?? '');
    _telefoneCtrl = TextEditingController(text: usuario?.telefone ?? '');
    _cepCtrl = TextEditingController(text: usuario?.cep ?? '');
    _enderecoCtrl = TextEditingController(text: usuario?.endereco ?? '');
    _cidadeCtrl = TextEditingController(text: usuario?.cidade ?? '');
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _cpfCtrl.dispose();
    _telefoneCtrl.dispose();
    _cepCtrl.dispose();
    _enderecoCtrl.dispose();
    _cidadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthServico>(context, listen: false);
    setState(() => _salvando = true);

    final sucesso = await auth.atualizarDadosPessoais(
      nome: _nomeCtrl.text.trim(),
      telefone: _telefoneCtrl.text.trim().isEmpty
          ? null
          : _telefoneCtrl.text.trim(),
      cpf: _cpfCtrl.text.trim().isEmpty ? null : _cpfCtrl.text.trim(),
      cep: _cepCtrl.text.trim().isEmpty ? null : _cepCtrl.text.trim(),
      endereco: _enderecoCtrl.text.trim().isEmpty
          ? null
          : _enderecoCtrl.text.trim(),
      cidade: _cidadeCtrl.text.trim().isEmpty ? null : _cidadeCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _salvando = false);

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dados atualizados com sucesso!'),
          backgroundColor: CoresApp.statusConcluida,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.erro ?? 'Erro ao atualizar dados.'),
          backgroundColor: CoresApp.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<AuthServico>(context).usuarioAtual;

    return Scaffold(
      backgroundColor: CoresApp.surface,
      appBar: AppBar(
        title: const Text('Dados Pessoais'),
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
              // ───── E-mail (não editável) ─────
              Text(
                'E-mail',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: CoresApp.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: CoresApp.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.mail_outline, size: 20, color: CoresApp.outline),
                    const SizedBox(width: 12),
                    Text(
                      usuario?.email ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _Campo(
                label: 'Nome completo',
                ctrl: _nomeCtrl,
                icone: Icons.person_outline,
                tipo: TextInputType.name,
                validador: (v) => (v == null || v.trim().length < 3)
                    ? 'Informe o nome completo'
                    : null,
              ),
              const SizedBox(height: 14),

              _Campo(
                label: 'CPF',
                ctrl: _cpfCtrl,
                icone: Icons.badge_outlined,
                tipo: TextInputType.number,
                mascara: _cpfMask,
              ),
              const SizedBox(height: 14),

              _Campo(
                label: 'Telefone / WhatsApp',
                ctrl: _telefoneCtrl,
                icone: Icons.phone_outlined,
                tipo: TextInputType.phone,
                mascara: _telMask,
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
              ),
              const SizedBox(height: 14),

              _Campo(
                label: 'Endereço completo',
                ctrl: _enderecoCtrl,
                icone: Icons.home_outlined,
              ),
              const SizedBox(height: 14),

              _Campo(
                label: 'Cidade',
                ctrl: _cidadeCtrl,
                icone: Icons.location_city_outlined,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvando ? null : _salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CoresApp.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _salvando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Salvar alterações',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Widget auxiliar ────────────────────────────────────────────────────────

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
          borderSide: BorderSide(color: CoresApp.outlineVariant, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: CoresApp.outlineVariant, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: CoresApp.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: CoresApp.error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
