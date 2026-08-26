// ============================================
// tela_nova_proposta.dart — Formulário de nova proposta de serviço
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../modelos/usuario.dart';
import '../../servicos/api_servico.dart';
import '../../servicos/auth_servico.dart';

class TelaNovaProposta extends StatefulWidget {
  final Usuario prestador;

  const TelaNovaProposta({super.key, required this.prestador});

  @override
  State<TelaNovaProposta> createState() => _TelaNovaPropostaState();
}

class _TelaNovaPropostaState extends State<TelaNovaProposta> {
  final _formKey = GlobalKey<FormState>();

  final _tituloCtrl = TextEditingController();
  final _descricaoCtrl = TextEditingController();
  final _enderecoCtrl = TextEditingController();

  DateTime? _dataEscolhida;
  TimeOfDay? _horarioEscolhido;

  bool _enviando = false;

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descricaoCtrl.dispose();
    _enderecoCtrl.dispose();
    super.dispose();
  }

  Future<void> _escolherData() async {
    final agora = DateTime.now();
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _dataEscolhida ?? agora,
      firstDate: agora,
      lastDate: agora.add(const Duration(days: 365)),
    );
    if (escolhida != null) {
      setState(() => _dataEscolhida = escolhida);
    }
  }

  Future<void> _escolherHorario() async {
    final escolhido = await showTimePicker(
      context: context,
      initialTime: _horarioEscolhido ?? TimeOfDay.now(),
    );
    if (escolhido != null) {
      setState(() => _horarioEscolhido = escolhido);
    }
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }

  String _formatarHorario(TimeOfDay horario) {
    return '${horario.hour.toString().padLeft(2, '0')}:'
        '${horario.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthServico>(context, listen: false);
    final token = auth.token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sessão expirada. Faça login novamente.')),
      );
      return;
    }

    setState(() => _enviando = true);

    final resposta = await ApiServico.criarProposta(
      token: token,
      idPrestador: widget.prestador.uid,
      titulo: _tituloCtrl.text.trim(),
      valor: widget.prestador.valorHora ?? 0,
      descricao: _descricaoCtrl.text.trim(),
      data: _dataEscolhida != null ? _formatarData(_dataEscolhida!) : null,
      horario: _horarioEscolhido != null
          ? _formatarHorario(_horarioEscolhido!)
          : null,
      endereco: _enderecoCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _enviando = false);

    if (resposta['erro'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Proposta enviada para ${widget.prestador.nome}!'),
          backgroundColor: CoresApp.statusConcluida,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (r) => false,
        arguments: 1,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resposta['mensagem']?.toString() ?? 'Erro ao enviar proposta.',
          ),
          backgroundColor: CoresApp.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.surface,
      appBar: AppBar(
        title: Text('Contratar ${widget.prestador.nome}'),
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
                'Detalhes do serviço',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: CoresApp.primary,
                ),
              ),
              const SizedBox(height: 16),

              _campo(
                label: 'Título',
                ctrl: _tituloCtrl,
                icone: Icons.title_outlined,
                validador: (v) => (v == null || v.trim().length < 3)
                    ? 'Informe um título'
                    : null,
              ),
              const SizedBox(height: 14),

              _campo(
                label: 'Descrição',
                ctrl: _descricaoCtrl,
                icone: Icons.notes_outlined,
                maxLinhas: 3,
              ),
              const SizedBox(height: 14),

              _valorFixo(),
              const SizedBox(height: 24),

              Text(
                'Quando e onde',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: CoresApp.primary,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _seletor(
                      label: 'Data',
                      icone: Icons.calendar_today_outlined,
                      valor: _dataEscolhida != null
                          ? _formatarData(_dataEscolhida!)
                          : 'Selecionar',
                      aoTocar: _escolherData,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _seletor(
                      label: 'Horário',
                      icone: Icons.access_time_outlined,
                      valor: _horarioEscolhido != null
                          ? _formatarHorario(_horarioEscolhido!)
                          : 'Selecionar',
                      aoTocar: _escolherHorario,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              _campo(
                label: 'Endereço',
                ctrl: _enderecoCtrl,
                icone: Icons.location_on_outlined,
                validador: (v) => (v == null || v.trim().isEmpty)
                    ? 'Informe o endereço'
                    : null,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _enviando ? null : _enviar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CoresApp.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _enviando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Enviar proposta',
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

  Widget _valorFixo() {
    final valorHora = widget.prestador.valorHora;
    final valorFormatado = valorHora != null
        ? 'R\$ ${valorHora.toStringAsFixed(2).replaceAll('.', ',')} / hora'
        : 'A combinar';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CoresApp.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CoresApp.outlineVariant, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.attach_money, size: 20, color: CoresApp.outline),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Valor do prestador',
                  style: TextStyle(
                    fontSize: 11,
                    color: CoresApp.onSurfaceVariant,
                  ),
                ),
                Text(
                  valorFormatado,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Você poderá conversar com o prestador pelo WhatsApp após enviar a proposta para combinar detalhes e ajustar o valor.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CoresApp.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _campo({
    required String label,
    required TextEditingController ctrl,
    IconData icone = Icons.edit_outlined,
    TextInputType tipo = TextInputType.text,
    int maxLinhas = 1,
    String? Function(String?)? validador,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: tipo,
      maxLines: maxLinhas,
      validator: validador,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icone, size: 20),
        filled: true,
        fillColor: CoresApp.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: CoresApp.outlineVariant,
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: CoresApp.outlineVariant,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CoresApp.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CoresApp.error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _seletor({
    required String label,
    required IconData icone,
    required String valor,
    required VoidCallback aoTocar,
  }) {
    return InkWell(
      onTap: aoTocar,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: CoresApp.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CoresApp.outlineVariant, width: 0.5),
        ),
        child: Row(
          children: [
            Icon(icone, size: 20, color: CoresApp.outline),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: CoresApp.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    valor,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
