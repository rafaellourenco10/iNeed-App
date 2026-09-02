// ============================================
// tela_home.dart — Home do Cliente
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../widgets/card_prestador.dart';
import '../../widgets/chip_categoria.dart';
import '../../modelos/usuario.dart';
import '../../servicos/api_servico.dart';
import '../../servicos/auth_servico.dart';

class TelaHome extends StatefulWidget {
  final VoidCallback? aoAbrirPerfil;

  const TelaHome({super.key, this.aoAbrirPerfil});

  @override
  State<TelaHome> createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  final TextEditingController _buscaController = TextEditingController();
  List<Usuario> _todos = [];
  List<Usuario> _prestadores = [];
  bool _carregando = true;
  String? _categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarPrestadores();
    _buscaController.addListener(_filtrar);
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarPrestadores() async {
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
          _prestadores = lista;
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
      _prestadores = _todos.where((p) {
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

  void _limparCategoria() {
    setState(() => _categoriaSelecionada = null);
    _filtrar();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthServico>(context);
    final nomeUsuario = auth.usuarioAtual?.nome.split(' ').first ?? 'Usuário';

    return Scaffold(
      backgroundColor: CoresApp.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ───── Header Gradiente (Logo + Avatar + Saudação + Busca) ─────
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF00288E), Color(0xFF1565C0)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo + Avatar
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
                        GestureDetector(
                          onTap: widget.aoAbrirPerfil,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                            child: Text(
                              nomeUsuario[0].toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Saudação
                    Text(
                      'Olá, $nomeUsuario',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Encontre os melhores profissionais para o que você precisa.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Barra de busca dentro do gradiente
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
                        controller: _buscaController,
                        decoration: InputDecoration(
                          hintText: 'Buscar serviços (ex: encanador)',
                          prefixIcon: Icon(
                            Icons.search,
                            color: CoresApp.outline,
                          ),
                          suffixIcon: _buscaController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: CoresApp.outline,
                                  ),
                                  onPressed: () => _buscaController.clear(),
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

            // ───── Categorias ─────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categorias',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: _limparCategoria,
                      child: Text(
                        'Ver todas',
                        style: TextStyle(color: CoresApp.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: ChipCategoria.categoriasPadrao.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
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
            ),

            // ───── Profissionais em Destaque ─────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profissionais em Destaque',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Perto de você',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: CoresApp.onSurfaceVariant),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildNavButton(Icons.arrow_back_ios, () {}),
                        const SizedBox(width: 8),
                        _buildNavButton(Icons.arrow_forward_ios, () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ───── Lista de Prestadores ─────
            if (_carregando)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
            else if (_prestadores.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: CoresApp.outline.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum profissional encontrado.',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: CoresApp.onSurfaceVariant),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tente outra categoria ou volte mais tarde.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return CardPrestador(
                    prestador: _prestadores[index],
                    aoVerPerfil: () {
                      Navigator.pushNamed(
                        context,
                        '/perfil-prestador',
                        arguments: _prestadores[index],
                      );
                    },
                  );
                }, childCount: _prestadores.length),
              ),

            // Espaço para a bottom nav
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: CoresApp.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: CoresApp.onSurface),
      ),
    );
  }
}
