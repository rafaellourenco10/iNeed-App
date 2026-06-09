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
  const TelaHome({super.key});

  @override
  State<TelaHome> createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  List<Usuario> _prestadores = [];
  bool _carregando = true;
  String? _categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarPrestadores();
  }

  Future<void> _carregarPrestadores({String? especialidade}) async {
    setState(() => _carregando = true);
    try {
      final resposta = await ApiServico.listarPrestadores(
        especialidade: especialidade,
      );
      if (resposta.containsKey('prestadores')) {
        final lista = (resposta['prestadores'] as List)
            .map((p) => Usuario.fromJson(p as Map<String, dynamic>))
            .toList();
        setState(() {
          _prestadores = lista;
          _carregando = false;
        });
      }
    } catch (_) {
      setState(() => _carregando = false);
    }
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
            // ───── Header ─────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.menu, color: CoresApp.onSurface),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/logo_ineed.jpeg',
                        width: 36,
                        height: 36,
                        fit: BoxFit.contain,
                      ),
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: CoresApp.surfaceContainerHigh,
                      child: Text(
                        nomeUsuario[0].toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: CoresApp.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ───── Saudação ─────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, $nomeUsuario 👋',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Encontre os melhores profissionais para o que você precisa.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: CoresApp.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            // ───── Barra de Busca ─────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: CoresApp.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CoresApp.outlineVariant, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar serviços (ex: encanador)',
                      prefixIcon: const Icon(Icons.search, color: CoresApp.outline),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: CoresApp.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.tune, color: Colors.white, size: 20),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
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
                      onPressed: () {},
                      child: const Text(
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
                      aoPresionar: () {
                        setState(() {
                          if (_categoriaSelecionada == nome) {
                            _categoriaSelecionada = null;
                            _carregarPrestadores();
                          } else {
                            _categoriaSelecionada = nome;
                            _carregarPrestadores(especialidade: nome);
                          }
                        });
                      },
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
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Perto de você',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: CoresApp.onSurfaceVariant,
                              ),
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
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: CoresApp.onSurfaceVariant,
                              ),
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
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
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
                  },
                  childCount: _prestadores.length,
                ),
              ),

            // Espaço para a bottom nav
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
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
