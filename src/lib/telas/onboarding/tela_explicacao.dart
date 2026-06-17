import 'package:flutter/material.dart';
import '../../tema/cores.dart';

class TelaExplicacao extends StatefulWidget {
  const TelaExplicacao({super.key});

  @override
  State<TelaExplicacao> createState() => _TelaExplicacaoState();
}

class _TelaExplicacaoState extends State<TelaExplicacao> {
  final PageController _pageController = PageController();
  int _paginaAtual = 0;

  final List<_Slide> _slides = const [
    _Slide(
      icone: Icons.search_rounded,
      titulo: 'Encontre profissionais',
      descricao:
          'Busque eletricistas, encanadores, pintores e muito mais. Filtre por especialidade, preço e avaliação.',
    ),
    _Slide(
      icone: Icons.send_rounded,
      titulo: 'Envie uma proposta',
      descricao:
          'Escolha o profissional ideal e envie uma proposta diretamente pelo app, com data, horário e endereço.',
    ),
    _Slide(
      icone: Icons.handshake_rounded,
      titulo: 'Serviço concluído',
      descricao:
          'O profissional aceita, realiza o serviço e você avalia. Simples, rápido e seguro.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _proximo() {
    if (_paginaAtual < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUltima = _paginaAtual == _slides.length - 1;

    return Scaffold(
      backgroundColor: CoresApp.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ───── Pular ─────
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/onboarding'),
                  child: Text(
                    'Pular',
                    style: TextStyle(
                      color: CoresApp.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // ───── PageView ─────
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _paginaAtual = i),
                itemBuilder: (context, index) =>
                    _SlidePage(slide: _slides[index]),
              ),
            ),

            // ───── Indicadores ─────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _paginaAtual == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _paginaAtual == i
                        ? CoresApp.primary
                        : CoresApp.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ───── Botão ─────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _proximo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CoresApp.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isUltima ? 'Começar' : 'Próximo',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SlidePage extends StatelessWidget {
  final _Slide slide;
  const _SlidePage({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ícone
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: CoresApp.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(
              slide.icone,
              size: 56,
              color: CoresApp.primary,
            ),
          ),

          const SizedBox(height: 40),

          Text(
            slide.titulo,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: CoresApp.onSurface,
                ),
          ),

          const SizedBox(height: 16),

          Text(
            slide.descricao,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: CoresApp.onSurfaceVariant,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}

class _Slide {
  final IconData icone;
  final String titulo;
  final String descricao;
  const _Slide({
    required this.icone,
    required this.titulo,
    required this.descricao,
  });
}
