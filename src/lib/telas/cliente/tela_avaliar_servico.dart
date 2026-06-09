// ============================================
// tela_avaliar_servico.dart — Avaliar um serviço concluído
// ============================================

import 'package:flutter/material.dart';
import '../../tema/cores.dart';
import '../../modelos/proposta.dart';
import '../../widgets/botao_primario.dart';

class TelaAvaliarServico extends StatefulWidget {
  final Proposta proposta;

  const TelaAvaliarServico({super.key, required this.proposta});

  @override
  State<TelaAvaliarServico> createState() => _TelaAvaliarServicoState();
}

class _TelaAvaliarServicoState extends State<TelaAvaliarServico> {
  int _estrelas = 0;
  final Set<String> _elogiosSelecionados = {};
  final _comentarioController = TextEditingController();

  static const List<String> _elogios = [
    'Pontual',
    'Eficiente',
    'Amigável',
    'Excelente Trabalho',
    'Preço Justo',
  ];

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.surface,
      appBar: AppBar(
        title: const Text('Avaliar Serviço'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ───── Card do Prestador ─────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    CoresApp.surfaceContainerLow,
                    CoresApp.surfaceContainerLowest,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CoresApp.outlineVariant, width: 0.5),
              ),
              child: Column(
                children: [
                  // Logo iNeed
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/logo_ineed.jpeg',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.proposta.nomePrestador ?? 'Prestador',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.proposta.titulo,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CoresApp.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ───── Estrelas ─────
            Text(
              'Como foi o serviço?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _estrelas = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      i < _estrelas ? Icons.star : Icons.star_border,
                      size: 44,
                      color: i < _estrelas
                          ? CoresApp.secondaryContainer
                          : CoresApp.outlineVariant,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 32),

            // ───── Elogios Rápidos ─────
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ELOGIO RÁPIDO',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: CoresApp.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _elogios.map((e) {
                final selecionado = _elogiosSelecionados.contains(e);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selecionado) {
                        _elogiosSelecionados.remove(e);
                      } else {
                        _elogiosSelecionados.add(e);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selecionado
                          ? CoresApp.primary
                          : CoresApp.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selecionado
                            ? CoresApp.primary
                            : CoresApp.outlineVariant,
                      ),
                    ),
                    child: Text(
                      e,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: selecionado
                            ? Colors.white
                            : CoresApp.onSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // ───── Comentário ─────
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Comentário Adicional',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _comentarioController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Conte mais sobre sua experiência (opcional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ───── Botão Enviar ─────
            BotaoPrimario(
              texto: 'Enviar Avaliação',
              icone: Icons.send,
              aoPresionar: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Avaliação enviada com sucesso! Obrigado.'),
                    backgroundColor: CoresApp.statusConcluida,
                  ),
                );
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
