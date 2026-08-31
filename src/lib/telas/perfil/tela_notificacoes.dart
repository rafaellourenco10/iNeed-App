// ============================================
// tela_notificacoes.dart — Central de notificações in-app
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../modelos/notificacao.dart';
import '../../servicos/api_servico.dart';
import '../../servicos/auth_servico.dart';

class TelaNotificacoes extends StatefulWidget {
  const TelaNotificacoes({super.key});

  @override
  State<TelaNotificacoes> createState() => _TelaNotificacoesState();
}

class _TelaNotificacoesState extends State<TelaNotificacoes> {
  List<Notificacao> _notificacoes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final auth = Provider.of<AuthServico>(context, listen: false);
    if (auth.token == null) {
      setState(() => _carregando = false);
      return;
    }

    setState(() => _carregando = true);
    try {
      final resposta = await ApiServico.listarNotificacoes(token: auth.token!);
      if (!mounted) return;
      if (resposta.containsKey('notificacoes')) {
        setState(() {
          _notificacoes = (resposta['notificacoes'] as List)
              .map((n) => Notificacao.fromJson(n as Map<String, dynamic>))
              .toList();
          _carregando = false;
        });
      } else {
        setState(() => _carregando = false);
      }
    } catch (_) {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _marcarComoLida(Notificacao notificacao) async {
    if (notificacao.lida) return;
    final auth = Provider.of<AuthServico>(context, listen: false);
    setState(() {
      _notificacoes = _notificacoes
          .map(
            (n) => n.id == notificacao.id
                ? Notificacao(
                    id: n.id,
                    tipo: n.tipo,
                    titulo: n.titulo,
                    mensagem: n.mensagem,
                    idProposta: n.idProposta,
                    lida: true,
                    criadaEm: n.criadaEm,
                  )
                : n,
          )
          .toList();
    });
    await ApiServico.marcarNotificacaoLida(
      token: auth.token ?? '',
      id: notificacao.id,
    );
  }

  Future<void> _marcarTodasLidas() async {
    final auth = Provider.of<AuthServico>(context, listen: false);
    setState(() {
      _notificacoes = _notificacoes
          .map(
            (n) => Notificacao(
              id: n.id,
              tipo: n.tipo,
              titulo: n.titulo,
              mensagem: n.mensagem,
              idProposta: n.idProposta,
              lida: true,
              criadaEm: n.criadaEm,
            ),
          )
          .toList();
    });
    await ApiServico.marcarTodasNotificacoesLidas(token: auth.token ?? '');
  }

  IconData _iconePara(String tipo) {
    switch (tipo) {
      case 'proposta_criada':
        return Icons.assignment_outlined;
      case 'proposta_aceita':
        return Icons.check_circle_outline;
      case 'proposta_recusada':
      case 'proposta_cancelada':
        return Icons.cancel_outlined;
      case 'proposta_concluida':
        return Icons.task_alt_outlined;
      case 'avaliacao_recebida':
        return Icons.star_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  String _formatarData(String? iso) {
    if (iso == null) return '';
    final data = DateTime.tryParse(iso);
    if (data == null) return '';
    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inMinutes < 1) return 'Agora';
    if (diferenca.inMinutes < 60) return 'Há ${diferenca.inMinutes} min';
    if (diferenca.inHours < 24) return 'Há ${diferenca.inHours}h';
    if (diferenca.inDays < 7) return 'Há ${diferenca.inDays} dia(s)';
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    final temNaoLidas = _notificacoes.any((n) => !n.lida);

    return Scaffold(
      backgroundColor: CoresApp.surface,
      appBar: AppBar(
        title: const Text('Notificações'),
        elevation: 0,
        backgroundColor: CoresApp.surface,
        actions: [
          if (temNaoLidas)
            TextButton(
              onPressed: _marcarTodasLidas,
              child: Text(
                'Marcar todas',
                style: TextStyle(color: CoresApp.primary),
              ),
            ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _notificacoes.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.notifications_none_outlined,
                    size: 64,
                    color: CoresApp.outline.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma notificação ainda.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: CoresApp.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _carregar,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _notificacoes.length,
                itemBuilder: (context, index) {
                  final n = _notificacoes[index];
                  return InkWell(
                    onTap: () => _marcarComoLida(n),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: n.lida
                            ? CoresApp.surface
                            : CoresApp.primary.withValues(alpha: 0.05),
                        border: Border(
                          bottom: BorderSide(
                            color: CoresApp.outlineVariant.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: CoresApp.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              _iconePara(n.tipo),
                              color: CoresApp.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  n.titulo,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: n.lida
                                            ? FontWeight.w500
                                            : FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  n.mensagem,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: CoresApp.onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatarData(n.criadaEm),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: CoresApp.outline,
                                        fontSize: 11,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          if (!n.lida)
                            Container(
                              margin: const EdgeInsets.only(top: 4, left: 8),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: CoresApp.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
