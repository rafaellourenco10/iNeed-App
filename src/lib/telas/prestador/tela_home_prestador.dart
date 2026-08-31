import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../modelos/proposta.dart';
import '../../servicos/api_servico.dart';
import '../../servicos/auth_servico.dart';
import '../../widgets/card_proposta.dart';

class TelaHomePrestador extends StatefulWidget {
  final VoidCallback? aoAbrirPerfil;

  const TelaHomePrestador({super.key, this.aoAbrirPerfil});

  @override
  State<TelaHomePrestador> createState() => _TelaHomePrestadorState();
}

class _TelaHomePrestadorState extends State<TelaHomePrestador> {
  final TextEditingController _buscaCtrl = TextEditingController();
  List<Proposta> _todas = [];
  List<Proposta> _solicitacoes = [];
  bool _carregando = true;
  bool _disponivel = true;

  @override
  void initState() {
    super.initState();
    _buscaCtrl.addListener(_filtrar);
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregar());
  }

  @override
  void dispose() {
    _buscaCtrl.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    if (!mounted) return;
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
          _solicitacoes = lista;
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
    final q = _buscaCtrl.text.toLowerCase();
    setState(() {
      _solicitacoes = q.isEmpty
          ? List.of(_todas)
          : _todas.where((p) {
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
      await _carregar();
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
          SnackBar(
            content: Text('Erro ao atualizar proposta.'),
            backgroundColor: CoresApp.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthServico>(context);
    final nome = auth.usuarioAtual?.nome.split(' ').first ?? 'Prestador';
    final especialidade = auth.usuarioAtual?.especialidade ?? '';
    final avaliacao = auth.usuarioAtual?.avaliacao;

    return Scaffold(
      backgroundColor: CoresApp.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header Gradiente (Logo + Badge disponível + Avatar + Saudação) ──
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF00288E), Color(0xFF1565C0)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo + badge disponível + avatar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/logo_ineed.jpeg',
                            width: 36,
                            height: 36,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _disponivel = !_disponivel),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _disponivel
                                      ? const Color(
                                          0xFF4CAF50,
                                        ).withValues(alpha: 0.2)
                                      : Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _disponivel
                                        ? const Color(0xFF4CAF50)
                                        : Colors.white.withValues(alpha: 0.4),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _disponivel
                                            ? const Color(0xFF4CAF50)
                                            : Colors.white.withValues(
                                                alpha: 0.6,
                                              ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _disponivel
                                          ? 'Disponível'
                                          : 'Indisponível',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _disponivel
                                            ? const Color(0xFF4CAF50)
                                            : Colors.white.withValues(
                                                alpha: 0.8,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: widget.aoAbrirPerfil,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                                child: Text(
                                  nome[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Saudação
                    Text(
                      'Olá, $nome!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      especialidade.isNotEmpty
                          ? 'Veja suas propostas de $especialidade pendentes.'
                          : 'Veja suas propostas pendentes.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Busca dentro do gradiente
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _buscaCtrl,
                        decoration: InputDecoration(
                          hintText: 'Buscar por título, cliente ou endereço...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: CoresApp.outline,
                          ),
                          suffixIcon: _buscaCtrl.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: CoresApp.outline,
                                  ),
                                  onPressed: () => _buscaCtrl.clear(),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Stats ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    valor: '${_solicitacoes.length}',
                    label: 'Disponíveis',
                    icone: Icons.list_alt_outlined,
                    cor: CoresApp.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    valor: '${_todas.length}',
                    label: 'Pendentes',
                    icone: Icons.pending_actions_outlined,
                    cor: const Color(0xFFFF6B35),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    valor: avaliacao != null
                        ? avaliacao.toStringAsFixed(1)
                        : '—',
                    label: 'Avaliação',
                    icone: Icons.star_outline,
                    cor: const Color(0xFFFFC107),
                  ),
                ),
              ],
            ),
          ),

          // ── Título da seção ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              'Propostas Pendentes',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),

          // ── Lista ─────────────────────────────────────────────────
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : _solicitacoes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
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
                    onRefresh: _carregar,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 100),
                      itemCount: _solicitacoes.length,
                      itemBuilder: (ctx, i) {
                        final proposta = _solicitacoes[i];
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
          ),
        ],
      ),
    );
  }
}

// ─── Stat Card ───────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String valor;
  final String label;
  final IconData icone;
  final Color cor;

  const _StatCard({
    required this.valor,
    required this.label,
    required this.icone,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: CoresApp.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CoresApp.outlineVariant, width: 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, color: cor, size: 20),
          const SizedBox(height: 4),
          Text(
            valor,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: cor,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: CoresApp.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
