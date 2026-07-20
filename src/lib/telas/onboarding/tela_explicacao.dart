import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
      video: 'assets/videos/encanador.mp4',
      icone: Icons.search_rounded,
      titulo: 'Encontre profissionais',
      descricao:
          'Busque eletricistas, encanadores, pintores e muito mais. Filtre por especialidade, preço e avaliação.',
    ),
    _Slide(
      video: 'assets/videos/pintor.mp4',
      icone: Icons.send_rounded,
      titulo: 'Envie uma proposta',
      descricao:
          'Escolha o profissional ideal e envie uma proposta diretamente pelo app, com data, horário e endereço.',
    ),
    _Slide(
      video: 'assets/videos/faxineira.mp4',
      icone: Icons.handshake_rounded,
      titulo: 'Serviço concluído',
      descricao:
          'O profissional aceita, realiza o serviço e você avalia. Simples, rápido e seguro.',
    ),
  ];

  late final List<VideoPlayerController> _videoControllers;
  bool _videosProntos = false;

  @override
  void initState() {
    super.initState();
    _videoControllers = _slides
        .map((s) => VideoPlayerController.asset(s.video))
        .toList();
    _inicializarVideos();
  }

  Future<void> _inicializarVideos() async {
    await Future.wait(_videoControllers.map((c) => c.initialize()));
    for (final c in _videoControllers) {
      c
        ..setLooping(true)
        ..setVolume(0);
    }
    if (!mounted) return;
    setState(() => _videosProntos = true);
    _videoControllers[_paginaAtual].play();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final c in _videoControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _mudarPagina(int indice) {
    setState(() => _paginaAtual = indice);
    if (!_videosProntos) return;
    for (var i = 0; i < _videoControllers.length; i++) {
      if (i == indice) {
        _videoControllers[i].play();
      } else {
        _videoControllers[i].pause();
      }
    }
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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ───── Vídeo full-bleed (atrás de tudo) ─────
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: _mudarPagina,
              itemBuilder: (context, index) => _SlidePage(
                slide: _slides[index],
                controller: _videoControllers[index],
              ),
            ),
          ),

          // ───── Controles flutuantes por cima do vídeo ─────
          SafeArea(
            child: Column(
              children: [
                // Pular
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 16, 0),
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/onboarding'),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        'Pular',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Indicadores
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
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Botão
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _proximo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF00288E),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlidePage extends StatelessWidget {
  final _Slide slide;
  final VideoPlayerController controller;
  const _SlidePage({required this.slide, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Fundo gradiente — base fixa (enquanto carrega)
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF00288E), Color(0xFF1565C0)],
            ),
          ),
        ),

        ValueListenableBuilder<VideoPlayerValue>(
          valueListenable: controller,
          builder: (context, valor, _) {
            if (!valor.isInitialized) return const SizedBox.shrink();
            return FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: valor.size.width,
                height: valor.size.height,
                child: VideoPlayer(controller),
              ),
            );
          },
        ),

        // Camada de cor por cima do vídeo (contraste do texto)
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.45),
                const Color(0xFF00288E).withValues(alpha: 0.35),
                Colors.black.withValues(alpha: 0.55),
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
        ),

        // Conteúdo
        Align(
          alignment: const Alignment(0, -0.15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.45),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(slide.icone, size: 42, color: Colors.white),
                ),

                const SizedBox(height: 32),

                Text(
                  slide.titulo,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  slide.descricao,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                    height: 1.6,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Slide {
  final String video;
  final IconData icone;
  final String titulo;
  final String descricao;
  const _Slide({
    required this.video,
    required this.icone,
    required this.titulo,
    required this.descricao,
  });
}
