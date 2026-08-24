import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../tema/cores.dart';
import '../../servicos/api_servico.dart';
import '../../servicos/auth_servico.dart';

class TelaPedidos extends StatefulWidget {
  const TelaPedidos({super.key});

  @override
  State<TelaPedidos> createState() => _TelaPedidosState();
}

class _TelaPedidosState extends State<TelaPedidos>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _pedidos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carregar();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    final auth = Provider.of<AuthServico>(context, listen: false);
    setState(() => _carregando = true);
    try {
      final resposta = await ApiServico.listarPropostasCliente(
        token: auth.token ?? '',
      );
      if (resposta.containsKey('propostas')) {
        setState(() {
          _pedidos = List<Map<String, dynamic>>.from(
            resposta['propostas'] as List,
          );
          _carregando = false;
        });
      } else {
        setState(() => _carregando = false);
      }
    } catch (_) {
      setState(() => _carregando = false);
    }
  }

  Future<void> _cancelar(String idProposta) async {
    final auth = Provider.of<AuthServico>(context, listen: false);
    await ApiServico.atualizarProposta(
      token: auth.token ?? '',
      id: idProposta,
      status: 'recusada',
    );
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Pedido cancelado.')));
    _carregar();
  }

  Future<void> _concluir(String idProposta) async {
    final auth = Provider.of<AuthServico>(context, listen: false);
    await ApiServico.atualizarProposta(
      token: auth.token ?? '',
      id: idProposta,
      status: 'concluida',
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Serviço marcado como concluído!')),
    );
    _carregar();
  }

  List<Map<String, dynamic>> _filtrar(List<String> status) {
    return _pedidos.where((p) => status.contains(p['status'])).toList();
  }

  @override
  Widget build(BuildContext context) {
    final emAberto = _filtrar(['pendente']);
    final emAndamento = _filtrar(['em_andamento', 'aceita']);
    final historico = _filtrar(['concluida', 'recusada']);

    return Scaffold(
      backgroundColor: CoresApp.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───── Header ─────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'Meus Pedidos',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Text(
                'Acompanhe seus serviços contratados.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: CoresApp.onSurfaceVariant,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ───── Tabs ─────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Em Aberto (${emAberto.length})'),
                  Tab(text: 'Andamento (${emAndamento.length})'),
                  const Tab(text: 'Histórico'),
                ],
              ),
            ),

            // ───── Conteúdo ─────
            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildLista(
                          emAberto,
                          mostrarCancelar: true,
                          mostrarWhatsApp: true,
                          aoCancelar: _cancelar,
                        ),
                        _buildLista(
                          emAndamento,
                          mostrarWhatsApp: true,
                          mostrarConcluir: true,
                          aoConcluir: _concluir,
                        ),
                        _buildLista(historico),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLista(
    List<Map<String, dynamic>> lista, {
    bool mostrarCancelar = false,
    bool mostrarWhatsApp = false,
    bool mostrarConcluir = false,
    void Function(String idProposta)? aoCancelar,
    void Function(String idProposta)? aoConcluir,
  }) {
    if (lista.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: CoresApp.outline.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum pedido aqui.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: CoresApp.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 100),
        itemCount: lista.length,
        itemBuilder: (context, index) => _CardPedido(
          pedido: lista[index],
          mostrarCancelar: mostrarCancelar,
          mostrarWhatsApp: mostrarWhatsApp,
          mostrarConcluir: mostrarConcluir,
          aoCancelar: aoCancelar,
          aoConcluir: aoConcluir,
        ),
      ),
    );
  }
}

class _CardPedido extends StatelessWidget {
  final Map<String, dynamic> pedido;
  final bool mostrarCancelar;
  final bool mostrarWhatsApp;
  final bool mostrarConcluir;
  final void Function(String idProposta)? aoCancelar;
  final void Function(String idProposta)? aoConcluir;

  const _CardPedido({
    required this.pedido,
    this.mostrarCancelar = false,
    this.mostrarWhatsApp = false,
    this.mostrarConcluir = false,
    this.aoCancelar,
    this.aoConcluir,
  });

  Future<void> _abrirWhatsApp(BuildContext context) async {
    final telefone = pedido['telefonePrestador'] as String?;
    final nome = pedido['nomePrestador'] as String? ?? 'prestador';
    final titulo = pedido['titulo'] as String? ?? 'serviço';
    final mensagem = Uri.encodeComponent(
      'Olá $nome! Entro em contato pelo app iNeed sobre o pedido: "$titulo".',
    );

    final url = telefone != null
        ? Uri.parse('https://wa.me/$telefone?text=$mensagem')
        : Uri.parse('https://wa.me/?text=$mensagem');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o WhatsApp.')),
        );
      }
    }
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'pendente':
        return CoresApp.statusPendente;
      case 'aceita':
      case 'em_andamento':
        return CoresApp.statusEmAndamento;
      case 'concluida':
        return CoresApp.statusConcluida;
      case 'recusada':
        return CoresApp.statusRecusada;
      default:
        return CoresApp.outline;
    }
  }

  String _textoStatus(String status) {
    switch (status) {
      case 'pendente':
        return 'Aguardando confirmação';
      case 'aceita':
        return 'Aceito';
      case 'em_andamento':
        return 'Em Andamento';
      case 'concluida':
        return 'Concluído';
      case 'recusada':
        return 'Recusado';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = pedido['status'] as String;
    final cor = _corStatus(status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: CoresApp.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───── Status + Valor ─────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: cor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _textoStatus(status),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cor,
                    ),
                  ),
                ),
                Text(
                  'R\$ ${(pedido['valor'] as num).toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: CoresApp.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ───── Título ─────
            Text(
              pedido['titulo'] as String,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),

            if ((pedido['descricao'] as String?)?.isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Text(
                pedido['descricao'] as String,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: CoresApp.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 12),

            // ───── Prestador ─────
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: CoresApp.surfaceContainerHigh,
                  child: Text(
                    ((pedido['nomePrestador'] as String?) ?? '?')
                        .substring(0, 1)
                        .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: CoresApp.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (pedido['nomePrestador'] as String?) ?? 'Prestador',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      (pedido['especialidadePrestador'] as String?) ??
                          'Serviço',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: CoresApp.primary),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ───── Data e Endereço ─────
            if (pedido['data'] != null)
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: CoresApp.outline,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${pedido['data']}  •  ${pedido['horario'] ?? ''}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),

            if (pedido['endereco'] != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: CoresApp.outline,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      pedido['endereco'] as String,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            // ───── Botões de ação ─────
            if (mostrarCancelar || mostrarConcluir || mostrarWhatsApp) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  // Cancelar (só em aberto)
                  if (mostrarCancelar) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            aoCancelar?.call(pedido['id'] as String),
                        icon: const Icon(Icons.cancel_outlined, size: 18),
                        label: const Text('Cancelar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: CoresApp.error,
                          side: const BorderSide(color: CoresApp.error),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    if (mostrarConcluir || mostrarWhatsApp)
                      const SizedBox(width: 10),
                  ],
                  // Concluir (só em andamento)
                  if (mostrarConcluir) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            aoConcluir?.call(pedido['id'] as String),
                        icon: const Icon(Icons.check_circle_outline, size: 18),
                        label: const Text('Concluir'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: CoresApp.statusConcluida,
                          side: const BorderSide(
                            color: CoresApp.statusConcluida,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    if (mostrarWhatsApp) const SizedBox(width: 10),
                  ],
                  // WhatsApp
                  if (mostrarWhatsApp)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _abrirWhatsApp(context),
                        icon: const Icon(Icons.chat, size: 18),
                        label: const Text('WhatsApp'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
