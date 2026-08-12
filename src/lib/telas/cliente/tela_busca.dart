import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../modelos/usuario.dart';
import '../../servicos/api_servico.dart';
import '../../servicos/auth_servico.dart';
import '../../widgets/card_prestador.dart';
import '../../widgets/chip_categoria.dart';

class TelaBusca extends StatefulWidget {
  const TelaBusca({super.key});

  @override
  State<TelaBusca> createState() => _TelaBuscaState();
}

class _TelaBuscaState extends State<TelaBusca> {
  final TextEditingController _buscaController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<Usuario> _todos = [];
  List<Usuario> _resultado = [];
  bool _carregando = true;
  String? _categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarTodos();
    _buscaController.addListener(_filtrar);
  }

  @override
  void dispose() {
    _buscaController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _carregarTodos() async {
    setState(() => _carregando = true);
    try {
      final auth = Provider.of<AuthServico>(context, listen: false);
      final resposta = await ApiServico.listarPrestadores(
        excluirUid: auth.usuarioAtual?.uid,
      );
      if (resposta.containsKey('prestadores')) {
        final lista = (resposta['prestadores'] as List)
            .map((p) => Usuario.fromJson(p as Map<String, dynamic>))
            .toList();
        setState(() {
          _todos = lista;
          _resultado = lista;
          _carregando = false;
        });
      }
    } catch (_) {
      setState(() => _carregando = false);
    }
  }

  void _filtrar() {
    final query = _buscaController.text.toLowerCase();
    setState(() {
      _resultado = _todos.where((p) {
        final nomeOk = p.nome.toLowerCase().contains(query);
        final espOk = (p.especialidade ?? '').toLowerCase().contains(query);
        final categoriaOk =
            _categoriaSelecionada == null ||
            (p.especialidade ?? '').toLowerCase() ==
                _categoriaSelecionada!.toLowerCase();
        return (nomeOk || espOk) && categoriaOk;
      }).toList();
    });
  }

  void _selecionarCategoria(String nome) {
    setState(() {
      _categoriaSelecionada = _categoriaSelecionada == nome ? null : nome;
    });
    _filtrar();
  }

  @override
  Widget build(BuildContext context) {
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
                'Buscar',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 4),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                'Encontre o profissional ideal para você.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: CoresApp.onSurfaceVariant,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ───── Barra de Busca ─────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: CoresApp.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CoresApp.outlineVariant,
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _buscaController,
                  focusNode: _focusNode,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Nome ou especialidade...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: CoresApp.outline,
                    ),
                    suffixIcon: _buscaController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: CoresApp.outline,
                            ),
                            onPressed: () {
                              _buscaController.clear();
                              _filtrar();
                            },
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
            ),

            const SizedBox(height: 20),

            // ───── Chips de Categoria ─────
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: ChipCategoria.categoriasPadrao.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final cat = ChipCategoria.categoriasPadrao[index];
                  final nome = cat['nome'] as String;
                  return ChipCategoria(
                    nome: nome,
                    icone: cat['icone'] as IconData,
                    selecionado: _categoriaSelecionada == nome,
                    aoPresionar: () => _selecionarCategoria(nome),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // ───── Contagem de resultados ─────
            if (!_carregando)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Text(
                  '${_resultado.length} profissional(is) encontrado(s)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CoresApp.onSurfaceVariant,
                  ),
                ),
              ),

            // ───── Lista de Resultados ─────
            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : _resultado.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: CoresApp.outline.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhum profissional encontrado.',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: CoresApp.onSurfaceVariant),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tente outro nome ou categoria.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 100),
                      itemCount: _resultado.length,
                      itemBuilder: (context, index) {
                        return CardPrestador(
                          prestador: _resultado[index],
                          aoVerPerfil: () {
                            Navigator.pushNamed(
                              context,
                              '/perfil-prestador',
                              arguments: _resultado[index],
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
