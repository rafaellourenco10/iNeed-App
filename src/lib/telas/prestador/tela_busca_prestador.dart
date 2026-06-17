import 'package:flutter/material.dart';
import '../../tema/cores.dart';
import '../../servicos/api_servico.dart';

class TelaBuscaPrestador extends StatefulWidget {
  const TelaBuscaPrestador({super.key});

  @override
  State<TelaBuscaPrestador> createState() => _TelaBuscaPrestadorState();
}

class _TelaBuscaPrestadorState extends State<TelaBuscaPrestador> {
  final TextEditingController _buscaCtrl = TextEditingController();
  List<Map<String, dynamic>> _todas = [];
  List<Map<String, dynamic>> _resultado = [];
  bool _carregando = false;
  bool _buscou = false;
  String? _filtroEsp;

  static const _especialidades = [
    'Eletricista',
    'Encanador',
    'Pintor',
    'Faxineiro',
    'Marceneiro',
    'Jardineiro',
    'Pedreiro',
    'Outros',
  ];

  @override
  void initState() {
    super.initState();
    _buscaCtrl.addListener(_filtrar);
    _carregarTodas();
  }

  @override
  void dispose() {
    _buscaCtrl.dispose();
    super.dispose();
  }

  Future<void> _carregarTodas() async {
    setState(() => _carregando = true);
    try {
      final resp = await ApiServico.listarSolicitacoes();
      if (!mounted) return;
      if (resp.containsKey('solicitacoes')) {
        final lista = List<Map<String, dynamic>>.from(
            resp['solicitacoes'] as List);
        setState(() {
          _todas = lista;
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
    if (q.isEmpty && _filtroEsp == null) {
      setState(() {
        _resultado = [];
        _buscou = false;
      });
      return;
    }
    setState(() {
      _buscou = true;
      _resultado = _todas.where((s) {
        final titulo = (s['titulo'] as String).toLowerCase();
        final esp = (s['especialidade'] as String).toLowerCase();
        final bairro = (s['bairro'] as String).toLowerCase();
        final matchQ = q.isEmpty ||
            titulo.contains(q) ||
            esp.contains(q) ||
            bairro.contains(q);
        final matchEsp = _filtroEsp == null ||
            (s['especialidade'] as String) == _filtroEsp;
        return matchQ && matchEsp;
      }).toList();
    });
  }

  void _selecionarEsp(String esp) {
    setState(() {
      _filtroEsp = _filtroEsp == esp ? null : esp;
    });
    _filtrar();
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
                'Buscar Serviços',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Text(
                'Encontre solicitações de clientes na sua área.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: CoresApp.onSurfaceVariant),
              ),
            ),

            // ── Campo de busca ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: TextField(
                controller: _buscaCtrl,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Buscar por serviço, especialidade ou bairro...',
                  prefixIcon:
                      const Icon(Icons.search, color: CoresApp.outline),
                  suffixIcon: _buscaCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear,
                              color: CoresApp.outline),
                          onPressed: () => _buscaCtrl.clear(),
                        )
                      : null,
                  filled: true,
                  fillColor: CoresApp.surfaceContainerLowest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: CoresApp.outlineVariant, width: 0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: CoresApp.outlineVariant, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: CoresApp.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),

            // ── Chips de especialidade ────────────────────────────────
            SizedBox(
              height: 44,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                scrollDirection: Axis.horizontal,
                itemCount: _especialidades.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final esp = _especialidades[i];
                  final sel = _filtroEsp == esp;
                  return GestureDetector(
                    onTap: () => _selecionarEsp(esp),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel
                            ? CoresApp.primary
                            : CoresApp.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              sel ? CoresApp.primary : CoresApp.outlineVariant,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        esp,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: sel ? Colors.white : CoresApp.onSurface,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ── Resultados ────────────────────────────────────────────
            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : !_buscou
                      ? _buildSugestoes()
                      : _resultado.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.search_off,
                                      size: 64,
                                      color: CoresApp.outline
                                          .withValues(alpha: 0.4)),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Nenhum resultado encontrado.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: CoresApp.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                                  child: Text(
                                    '${_resultado.length} resultado${_resultado.length > 1 ? 's' : ''} encontrado${_resultado.length > 1 ? 's' : ''}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: CoresApp.onSurfaceVariant),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 100),
                                    itemCount: _resultado.length,
                                    itemBuilder: (ctx, i) =>
                                        _CardResultado(solicitacao: _resultado[i]),
                                  ),
                                ),
                              ],
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSugestoes() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categorias populares',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _especialidades.map((esp) {
              return GestureDetector(
                onTap: () => _selecionarEsp(esp),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: CoresApp.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: CoresApp.outlineVariant, width: 0.5),
                  ),
                  child: Text(
                    esp,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: CoresApp.primary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          Text(
            'Dica',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CoresApp.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: CoresApp.primary.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline,
                    color: CoresApp.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Filtre por especialidade ou busque pelo tipo de serviço para encontrar pedidos compatíveis com seu perfil.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: CoresApp.onSurface,
                          height: 1.5,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Card de resultado ────────────────────────────────────────────────────────

class _CardResultado extends StatelessWidget {
  final Map<String, dynamic> solicitacao;

  const _CardResultado({required this.solicitacao});

  @override
  Widget build(BuildContext context) {
    final urgente = solicitacao['urgente'] as bool;
    final valor = (solicitacao['valor'] as num).toDouble();
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
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tags
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
                        Icon(Icons.bolt, size: 11, color: Color(0xFFFF6B35)),
                        SizedBox(width: 3),
                        Text('Urgente',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFF6B35))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
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
            const SizedBox(height: 8),
            Text(
              solicitacao['titulo'] as String,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 13, color: CoresApp.outline),
                const SizedBox(width: 3),
                Text(
                  '${solicitacao['bairro']}, ${solicitacao['cidade']}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CoresApp.onSurfaceVariant,
                      ),
                ),
                const Spacer(),
                Text(
                  valor > 0 ? 'R\$ ${valor.toStringAsFixed(0)}' : 'A combinar',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: CoresApp.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: CoresApp.surfaceContainerHigh,
                  child: Text(
                    nomeCliente[0].toUpperCase(),
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: CoresApp.primary),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    nomeCliente,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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
                        horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Aceitar',
                      style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
