import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../servicos/api_servico.dart';
import '../../servicos/auth_servico.dart';

class TelaHomePrestador extends StatefulWidget {
  const TelaHomePrestador({super.key});

  @override
  State<TelaHomePrestador> createState() => _TelaHomePrestadorState();
}

class _TelaHomePrestadorState extends State<TelaHomePrestador> {
  final TextEditingController _buscaCtrl = TextEditingController();
  List<Map<String, dynamic>> _todas = [];
  List<Map<String, dynamic>> _solicitacoes = [];
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
    setState(() => _carregando = true);
    try {
      final resp = await ApiServico.listarSolicitacoes();
      if (!mounted) return;
      if (resp.containsKey('solicitacoes')) {
        final lista = List<Map<String, dynamic>>.from(
            resp['solicitacoes'] as List);
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
          : _todas.where((s) {
              final titulo = (s['titulo'] as String).toLowerCase();
              final esp = (s['especialidade'] as String).toLowerCase();
              final bairro = (s['bairro'] as String).toLowerCase();
              return titulo.contains(q) || esp.contains(q) || bairro.contains(q);
            }).toList();
    });
  }

  int get _urgentes =>
      _solicitacoes.where((s) => s['urgente'] == true).length;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthServico>(context, listen: false);
    final nome = auth.usuarioAtual?.nome.split(' ').first ?? 'Prestador';
    final especialidade = auth.usuarioAtual?.especialidade ?? '';

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
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _disponivel
                                      ? const Color(0xFF4CAF50).withValues(alpha: 0.2)
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
                                            : Colors.white.withValues(alpha: 0.6),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _disponivel ? 'Disponível' : 'Indisponível',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _disponivel
                                            ? const Color(0xFF4CAF50)
                                            : Colors.white.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/perfil'),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white.withValues(alpha: 0.2),
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
                          ? 'Veja as solicitações de $especialidade na sua área.'
                          : 'Veja as solicitações abertas na sua área.',
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
                          hintText: 'Buscar por serviço ou bairro...',
                          prefixIcon: const Icon(Icons.search,
                              color: CoresApp.outline),
                          suffixIcon: _buscaCtrl.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: CoresApp.outline),
                                  onPressed: () => _buscaCtrl.clear(),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
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
                    valor: '$_urgentes',
                    label: 'Urgentes',
                    icone: Icons.bolt_outlined,
                    cor: const Color(0xFFFF6B35),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: _StatCard(
                    valor: '—',
                    label: 'Avaliação',
                    icone: Icons.star_outline,
                    cor: Color(0xFFFFC107),
                  ),
                ),
              ],
            ),
          ),

          // ── Título da seção ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Solicitações em Destaque',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                if (_urgentes > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFFF6B35).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$_urgentes urgente${_urgentes > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF6B35),
                      ),
                    ),
                  ),
              ],
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
                              'Nenhuma solicitação encontrada.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color: CoresApp.onSurfaceVariant),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding:
                            const EdgeInsets.only(top: 4, bottom: 100),
                        itemCount: _solicitacoes.length,
                        itemBuilder: (ctx, i) => _CardSolicitacao(
                            solicitacao: _solicitacoes[i]),
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

// ─── Card de Solicitação ─────────────────────────────────────────────────────

class _CardSolicitacao extends StatelessWidget {
  final Map<String, dynamic> solicitacao;

  const _CardSolicitacao({required this.solicitacao});

  @override
  Widget build(BuildContext context) {
    final urgente = solicitacao['urgente'] as bool;
    final valor = (solicitacao['valor'] as num).toDouble();
    final negociavel = solicitacao['valorNegociavel'] as bool;
    final nomeCliente = solicitacao['nomeCliente'] as String;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: CoresApp.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: urgente
            ? Border.all(
                color: const Color(0xFFFF6B35).withValues(alpha: 0.4),
                width: 1.5)
            : Border.all(color: CoresApp.outlineVariant, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tags + tempo
            Row(
              children: [
                if (urgente) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.bolt, size: 12, color: Color(0xFFFF6B35)),
                        SizedBox(width: 3),
                        Text(
                          'Urgente',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: CoresApp.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    solicitacao['especialidade'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: CoresApp.primary,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  solicitacao['criadoEm'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CoresApp.onSurfaceVariant,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Título
            Text(
              solicitacao['titulo'] as String,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              solicitacao['descricao'] as String,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CoresApp.onSurfaceVariant,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Cliente info
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: CoresApp.surfaceContainerHigh,
                  child: Text(
                    nomeCliente[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: CoresApp.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        nomeCliente,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${solicitacao['bairro']}, ${solicitacao['cidade']}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: CoresApp.onSurfaceVariant),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star,
                        color: Color(0xFFFFC107), size: 13),
                    const SizedBox(width: 2),
                    Text(
                      '${solicitacao['avaliacaoCliente']}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Valor + Botões
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      valor > 0
                          ? 'R\$ ${valor.toStringAsFixed(0)}'
                          : 'A combinar',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: CoresApp.primary,
                          ),
                    ),
                    if (negociavel && valor > 0)
                      Text(
                        'Negociável',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: CoresApp.onSurfaceVariant),
                      ),
                  ],
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Detalhes em desenvolvimento.')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CoresApp.primary,
                    side: const BorderSide(color: CoresApp.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Detalhes',
                      style: TextStyle(fontSize: 13)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Proposta enviada para $nomeCliente!'),
                        backgroundColor: const Color(0xFF4CAF50),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CoresApp.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child:
                      const Text('Aceitar', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
