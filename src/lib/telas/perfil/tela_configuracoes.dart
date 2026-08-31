// ============================================
// tela_configuracoes.dart — Configurações do app
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../servicos/tema_servico.dart';

class TelaConfiguracoes extends StatelessWidget {
  const TelaConfiguracoes({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<TemaServico>(context);

    return Scaffold(
      backgroundColor: CoresApp.surface,
      appBar: AppBar(
        title: const Text('Configurações'),
        elevation: 0,
        backgroundColor: CoresApp.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aparência',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: CoresApp.primary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: CoresApp.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CoresApp.outlineVariant, width: 0.5),
              ),
              child: SwitchListTile(
                value: tema.escuro,
                onChanged: (valor) => tema.alternar(valor),
                activeThumbColor: CoresApp.primary,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                secondary: Icon(
                  tema.escuro
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                  color: CoresApp.primary,
                ),
                title: const Text('Tema escuro'),
                subtitle: Text(
                  tema.escuro ? 'Ativado' : 'Desativado',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CoresApp.onSurfaceVariant,
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
