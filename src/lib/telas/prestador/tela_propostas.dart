// ============================================
// tela_propostas.dart — Dashboard de propostas do prestador
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../widgets/card_proposta.dart';
import '../../modelos/proposta.dart';
import '../../servicos/api_servico.dart';
import '../../servicos/auth_servico.dart';

class TelaPropostas extends StatefulWidget {
  const TelaPropostas({super.key});

  @override
  State<TelaPropostas> createState() => _TelaPropostasState();
}

class _TelaPropostasState extends State<TelaPropostas>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Proposta> _propostas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _carregarPropostas();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _carregarPropostas() async {
    final auth = Provider.of<AuthServico>(context, listen: false);
    if (auth.usuarioAtual == null) return;

    setState(() => _carregando = true);
    try {
      final resposta = await ApiServico.listarPropostas(
        token: auth.token ?? '',
        idPrestador: auth.usuarioAtual!.uid,
      );
      if (resposta.containsKey('propostas')) {
        final lista = (resposta['propostas'] as List)
            .map((p) => Proposta.fromJson(p as Map<String, dynamic>))
            .toList();
        setState(() {
          _propostas = lista;
          _carregando = false;
        });
      }
    } catch (_) {
      setState(() => _carregando = false);
    }
  }

  List<Proposta> _filtrarPropostas(String status) {
    if (status == 'pendente') {
      return _propostas.where((p) => p.isPendente).toList();
    } else if (status == 'em_andamento') {
      return _propostas.where((p) => p.isEmAndamento || p.isAceita).toList();
    } else {
      return _propostas.where((p) => p.isConcluida).toList();
    }
  }

  Future<void> _atualizarStatus(String idProposta, String novoStatus) async {
    final auth = Provider.of<AuthServico>(context, listen: false);
    try {
      await ApiServico.atualizarProposta(
        token: auth.token ?? '',
        id: idProposta,
        status: novoStatus,
      );
      _carregarPropostas();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Proposta ${novoStatus == 'aceita' ? 'aceita' : 'recusada'} com sucesso!',
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
    final pendentes = _filtrarPropostas('pendente');
    final emAndamento = _filtrarPropostas('em_andamento');
    final concluidas = _filtrarPropostas('concluida');

    return Scaffold(
      backgroundColor: CoresApp.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───── Header ─────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      'assets/images/logo_ineed.jpeg',
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/perfil'),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: CoresApp.surfaceContainerHigh,
                      child: Consumer<AuthServico>(
                        builder: (_, auth, __) => Text(
                          (auth.usuarioAtual?.nome ?? 'P')[0].toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: CoresApp.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ───── Título ─────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Propostas',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gerencie suas solicitações de serviços.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CoresApp.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // ───── Tabs ─────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Pendentes (${pendentes.length})'),
                  const Tab(text: 'Em Andamento'),
                  const Tab(text: 'Concluídas'),
                ],
              ),
            ),

            // ───── Conteúdo das Tabs ─────
            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildListaPropostas(pendentes),
                        _buildListaPropostas(emAndamento),
                        _buildListaPropostas(concluidas),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaPropostas(List<Proposta> propostas) {
    if (propostas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: CoresApp.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma proposta encontrada.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: CoresApp.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarPropostas,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 100),
        itemCount: propostas.length,
        itemBuilder: (context, index) {
          final proposta = propostas[index];
          return CardProposta(
            proposta: proposta,
            aoAceitar: () => _atualizarStatus(proposta.id, 'aceita'),
            aoRecusar: () => _atualizarStatus(proposta.id, 'recusada'),
          );
        },
      ),
    );
  }
}
