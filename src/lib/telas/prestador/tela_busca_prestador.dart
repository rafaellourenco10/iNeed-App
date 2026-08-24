// ============================================
// tela_busca_prestador.dart — Busca nas propostas pendentes do prestador
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../modelos/proposta.dart';
import '../../servicos/api_servico.dart';
import '../../servicos/auth_servico.dart';
import '../../widgets/card_proposta.dart';

class TelaBuscaPrestador extends StatefulWidget {
  const TelaBuscaPrestador({super.key});

  @override
  State<TelaBuscaPrestador> createState() => _TelaBuscaPrestadorState();
}

class _TelaBuscaPrestadorState extends State<TelaBuscaPrestador> {
  final TextEditingController _buscaCtrl = TextEditingController();
  List<Proposta> _todas = [];
  List<Proposta> _resultado = [];
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _buscaCtrl.addListener(_filtrar);
    _carregarPendentes();
  }

  @override
  void dispose() {
    _buscaCtrl.dispose();
    super.dispose();
  }

  Future<void> _carregarPendentes() async {
    final auth = Provider.of<AuthServico>(context, listen: false);
    if (auth.usuarioAtual == null) return;

    setState(() => _carregando = true);
    try {
      final resp = await ApiServico.listarPropostas(
        token: auth.token ?? '',
        idPrestador: auth.usuarioAtual!.uid,
        status: 'pendente',
      );
      if (!mounted) return;
      if (resp.containsKey('propostas')) {
        final lista = (resp['propostas'] as List)
            .map((p) => Proposta.fromJson(p as Map<String, dynamic>))
            .toList();
        setState(() {
          _todas = lista;
          _resultado = lista;
          _carregando = false;
        });
      } else {
        setState(() => _carregando = false);
      }
    } catch (_) {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _filtrar() {
    final q = _buscaCtrl.text.toLowerCase().trim();
    if (q.isEmpty) {
      setState(() => _resultado = _todas);
      return;
    }
    setState(() {
      _resultado = _todas.where((p) {
        return p.titulo.toLowerCase().contains(q) ||
            p.nomeCliente.toLowerCase().contains(q) ||
            (p.endereco?.toLowerCase().contains(q) ?? false);
      }).toList();
    });
  }

  Future<void> _atualizarStatus(String idProposta, String novoStatus) async {
    final auth = Provider.of<AuthServico>(context, listen: false);
    try {
      await ApiServico.atualizarProposta(
        token: auth.token ?? '',
        id: idProposta,
        status: novoStatus,
      );
      await _carregarPendentes();
      _filtrar();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              novoStatus == 'aceita'
                  ? 'Proposta aceita com sucesso!'
                  : 'Proposta recusada.',
            ),
            backgroundColor: novoStatus == 'aceita'
                ? CoresApp.statusConcluida
                : CoresApp.outline,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao atualizar proposta.'),
            backgroundColor: CoresApp.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'Buscar Propostas',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Text(
                'Encontre entre suas propostas pendentes.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: CoresApp.onSurfaceVariant,
                ),
              ),
            ),

            // ── Campo de busca ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: TextField(
                controller: _buscaCtrl,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Buscar por título, cliente ou endereço...',
                  prefixIcon: const Icon(Icons.search, color: CoresApp.outline),
                  suffixIcon: _buscaCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: CoresApp.outline,
                          ),
                          onPressed: () => _buscaCtrl.clear(),
                        )
                      : null,
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
            ),

            const SizedBox(height: 12),

            // ── Resultados ────────────────────────────────────────────
            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : _resultado.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: CoresApp.outline.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _todas.isEmpty
                                ? 'Nenhuma proposta pendente no momento.'
                                : 'Nenhum resultado encontrado.',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: CoresApp.onSurfaceVariant),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _carregarPendentes,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                            child: Text(
                              '${_resultado.length} proposta${_resultado.length > 1 ? 's' : ''} pendente${_resultado.length > 1 ? 's' : ''}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: CoresApp.onSurfaceVariant),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: _resultado.length,
                              itemBuilder: (ctx, i) {
                                final proposta = _resultado[i];
                                return CardProposta(
                                  proposta: proposta,
                                  aoAceitar: () =>
                                      _atualizarStatus(proposta.id, 'aceita'),
                                  aoRecusar: () =>
                                      _atualizarStatus(proposta.id, 'recusada'),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
