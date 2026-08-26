// ============================================
// tela_metodos_pagamento.dart — Método de pagamento (referência)
// ============================================
// Não processa nenhuma transação — só guarda a chave Pix do prestador
// (pra receber) e quais formas de pagamento ele aceita. Tela exclusiva
// do perfil de prestador.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../servicos/auth_servico.dart';

class TelaMetodosPagamento extends StatefulWidget {
  const TelaMetodosPagamento({super.key});

  @override
  State<TelaMetodosPagamento> createState() => _TelaMetodosPagamentoState();
}

class _TelaMetodosPagamentoState extends State<TelaMetodosPagamento> {
  late final TextEditingController _chavePixCtrl;
  String? _formaSelecionada;
  bool _escolhendoForma = false;
  bool _salvando = false;

  static const _formasPagamento = [
    {
      'valor': 'dinheiro',
      'label': 'Dinheiro',
      'icone': Icons.payments_outlined,
    },
    {'valor': 'pix', 'label': 'Pix', 'icone': Icons.qr_code},
    {'valor': 'cartao', 'label': 'Cartão', 'icone': Icons.credit_card},
    {
      'valor': 'todas',
      'label': 'Todas as formas',
      'icone': Icons.all_inclusive,
    },
  ];

  @override
  void initState() {
    super.initState();
    final usuario = Provider.of<AuthServico>(
      context,
      listen: false,
    ).usuarioAtual;
    _chavePixCtrl = TextEditingController(text: usuario?.chavePix ?? '');
    _formaSelecionada = usuario?.formaPagamentoAceita;
    _escolhendoForma = _formaSelecionada == null;
  }

  @override
  void dispose() {
    _chavePixCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final auth = Provider.of<AuthServico>(context, listen: false);
    setState(() => _salvando = true);

    final sucesso = await auth.atualizarMetodoPagamento(
      chavePix: _chavePixCtrl.text.trim().isEmpty
          ? null
          : _chavePixCtrl.text.trim(),
      formaPagamentoAceita: _formaSelecionada,
    );

    if (!mounted) return;
    setState(() => _salvando = false);

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Método de pagamento atualizado!'),
          backgroundColor: CoresApp.statusConcluida,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.erro ?? 'Erro ao atualizar.'),
          backgroundColor: CoresApp.error,
        ),
      );
    }
  }

  Widget _resumoFormaEscolhida() {
    final forma = _formasPagamento.firstWhere(
      (f) => f['valor'] == _formaSelecionada,
      orElse: () => _formasPagamento.first,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: CoresApp.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CoresApp.primary, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(forma['icone'] as IconData, size: 20, color: CoresApp.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              forma['label'] as String,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: CoresApp.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _escolhendoForma = true),
            child: const Text('Escolher outra'),
          ),
        ],
      ),
    );
  }

  Widget _listaFormasPagamento() {
    return Column(
      children: _formasPagamento.map((forma) {
        final selecionada = _formaSelecionada == forma['valor'];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () => setState(() {
              _formaSelecionada = forma['valor'] as String;
              _escolhendoForma = false;
            }),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: selecionada
                    ? CoresApp.primary.withValues(alpha: 0.08)
                    : CoresApp.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selecionada
                      ? CoresApp.primary
                      : CoresApp.outlineVariant,
                  width: selecionada ? 1.5 : 0.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    forma['icone'] as IconData,
                    size: 20,
                    color: selecionada ? CoresApp.primary : CoresApp.outline,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    forma['label'] as String,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: selecionada
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: selecionada
                          ? CoresApp.primary
                          : CoresApp.onSurface,
                    ),
                  ),
                  const Spacer(),
                  if (selecionada)
                    const Icon(
                      Icons.check_circle,
                      color: CoresApp.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.surface,
      appBar: AppBar(
        title: const Text('Métodos de Pagamento'),
        elevation: 0,
        backgroundColor: CoresApp.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: CoresApp.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: CoresApp.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: CoresApp.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'O pagamento é combinado diretamente com o cliente. Isso é só pra ele saber sua chave e as formas que você aceita.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CoresApp.onSurface,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Chave Pix',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: CoresApp.primary,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _chavePixCtrl,
              decoration: InputDecoration(
                labelText: 'CPF, telefone, e-mail ou chave aleatória',
                prefixIcon: const Icon(Icons.qr_code, size: 20),
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
                  borderSide: const BorderSide(
                    color: CoresApp.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Formas de pagamento aceitas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: CoresApp.primary,
              ),
            ),
            const SizedBox(height: 16),
            if (!_escolhendoForma && _formaSelecionada != null)
              _resumoFormaEscolhida()
            else
              _listaFormasPagamento(),

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
                        'Salvar',
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
    );
  }
}
