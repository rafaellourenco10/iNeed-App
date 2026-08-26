// ============================================
// tela_metodos_pagamento.dart — Método de pagamento (referência)
// ============================================
// Não processa nenhuma transação — só guarda a chave Pix do prestador,
// pra ele receber. Tela exclusiva do perfil de prestador.

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
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    final usuario = Provider.of<AuthServico>(
      context,
      listen: false,
    ).usuarioAtual;
    _chavePixCtrl = TextEditingController(text: usuario?.chavePix ?? '');
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
                      'O pagamento é combinado diretamente com o cliente. Isso é só pra ele saber sua chave na hora de te pagar.',
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
