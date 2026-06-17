import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../servicos/auth_servico.dart';

class TelaCompletarPrestador extends StatefulWidget {
  const TelaCompletarPrestador({super.key});

  @override
  State<TelaCompletarPrestador> createState() => _TelaCompletarPrestadorState();
}

class _TelaCompletarPrestadorState extends State<TelaCompletarPrestador> {
  final _formKey = GlobalKey<FormState>();
  final _valorCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  String? _especialidade;

  static const _especialidades = [
    ('Eletricista', Icons.electrical_services_outlined),
    ('Encanador', Icons.plumbing_outlined),
    ('Pintor', Icons.format_paint_outlined),
    ('Faxineiro', Icons.cleaning_services_outlined),
    ('Marceneiro', Icons.handyman_outlined),
    ('Jardineiro', Icons.grass_outlined),
    ('Pedreiro', Icons.construction_outlined),
    ('Outros', Icons.build_outlined),
  ];

  @override
  void dispose() {
    _valorCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _concluir() async {
    if (_especialidade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione sua especialidade.')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthServico>(context, listen: false);
    await auth.definirComoPrestador(
      especialidade: _especialidade!,
      valorHora: double.tryParse(_valorCtrl.text.replaceAll(',', '.')) ?? 0.0,
      biografia: _bioCtrl.text.trim().isEmpty ? null : _bioCtrl.text.trim(),
    );

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home-prestador', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthServico>(context);
    final nome = auth.usuarioAtual?.nome.split(' ').first ?? 'Prestador';

    return Scaffold(
      backgroundColor: CoresApp.surface,
      appBar: AppBar(
        backgroundColor: CoresApp.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Perfil de Prestador'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                // ───── Header ─────
                Text(
                  'Quase lá, $nome!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Conte aos clientes o que você faz para começar a receber pedidos.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CoresApp.onSurfaceVariant,
                        height: 1.5,
                      ),
                ),

                const SizedBox(height: 32),

                // ───── Especialidade ─────
                Text(
                  'Qual é a sua especialidade?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Selecione uma opção',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CoresApp.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),

                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.85,
                  children: _especialidades.map((e) {
                    final nome = e.$1;
                    final icone = e.$2;
                    final sel = _especialidade == nome;
                    return GestureDetector(
                      onTap: () => setState(() => _especialidade = nome),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: sel
                              ? CoresApp.primary.withValues(alpha: 0.1)
                              : CoresApp.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: sel ? CoresApp.primary : CoresApp.outlineVariant,
                            width: sel ? 2 : 0.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              icone,
                              color: sel ? CoresApp.primary : CoresApp.onSurfaceVariant,
                              size: 26,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              nome,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                                color: sel ? CoresApp.primary : CoresApp.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 28),

                // ───── Valor por hora ─────
                Text(
                  'Valor cobrado por hora (R\$)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _valorCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Informe o valor por hora';
                    final n = double.tryParse(v.replaceAll(',', '.'));
                    if (n == null || n <= 0) return 'Valor inválido';
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Ex: 80,00',
                    prefixText: 'R\$ ',
                    prefixStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: CoresApp.primary,
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
                ),

                const SizedBox(height: 28),

                // ───── Biografia ─────
                Text(
                  'Apresentação (opcional)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fale sobre sua experiência e diferenciais.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CoresApp.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bioCtrl,
                  maxLines: 4,
                  maxLength: 300,
                  decoration: InputDecoration(
                    hintText: 'Ex: Trabalho há 8 anos com instalações elétricas residenciais...',
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
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),

                const SizedBox(height: 32),

                // ───── Botão ─────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.carregando ? null : _concluir,
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
                            'Começar como Prestador',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
