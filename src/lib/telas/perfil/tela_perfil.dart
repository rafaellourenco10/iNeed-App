// ============================================
// tela_perfil.dart — Perfil do usuário logado
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../modelos/proposta.dart';
import '../../modelos/notificacao.dart';
import '../../servicos/api_servico.dart';
import '../../servicos/auth_servico.dart';
import '../../widgets/botao_primario.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  List<Proposta> _historico = [];
  int _totalContratados = 0;
  int _notificacoesNaoLidas = 0;
  bool _carregando = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carregarHistorico();
    _carregarNotificacoes();
  }

  Future<void> _carregarNotificacoes() async {
    final auth = Provider.of<AuthServico>(context, listen: false);
    if (auth.token == null) return;
    try {
      final resposta = await ApiServico.listarNotificacoes(token: auth.token!);
      if (!mounted) return;
      if (resposta.containsKey('notificacoes')) {
        final lista = (resposta['notificacoes'] as List)
            .map((n) => Notificacao.fromJson(n as Map<String, dynamic>))
            .toList();
        setState(() {
          _notificacoesNaoLidas = lista.where((n) => !n.lida).length;
        });
      }
    } catch (_) {
      // Contador é só um detalhe visual — falha silenciosa
    }
  }

  Future<void> _carregarHistorico() async {
    final auth = Provider.of<AuthServico>(context, listen: false);
    final usuario = auth.usuarioAtual;
    if (usuario == null || auth.token == null) {
      setState(() => _carregando = false);
      return;
    }

    setState(() => _carregando = true);
    try {
      final resposta = usuario.isPrestador
          ? await ApiServico.listarPropostas(
              token: auth.token!,
              idPrestador: usuario.uid,
            )
          : await ApiServico.listarPropostasCliente(token: auth.token!);

      if (!mounted) return;
      if (resposta.containsKey('propostas')) {
        final lista = (resposta['propostas'] as List)
            .map((p) => Proposta.fromJson(p as Map<String, dynamic>))
            .toList();
        setState(() {
          _historico = lista.take(3).toList();
          _totalContratados = lista
              .where((p) => p.isAceita || p.isEmAndamento || p.isConcluida)
              .length;
          _carregando = false;
        });
      } else {
        setState(() => _carregando = false);
      }
    } catch (_) {
      if (mounted) setState(() => _carregando = false);
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
        return 'PENDENTE';
      case 'aceita':
        return 'ACEITA';
      case 'em_andamento':
        return 'EM ANDAMENTO';
      case 'concluida':
        return 'CONCLUÍDO';
      case 'recusada':
        return 'RECUSADO';
      default:
        return status.toUpperCase();
    }
  }

  String _subtitulo(Proposta p, bool souPrestador) {
    final contraparte = souPrestador
        ? p.nomeCliente
        : (p.nomePrestador ?? 'Prestador');
    final quando = p.data != null
        ? '${p.data}${p.horario != null ? ' às ${p.horario}' : ''}'
        : _formatarDataIso(p.criadaEm);
    return '$contraparte • $quando';
  }

  String _formatarDataIso(String? iso) {
    if (iso == null) return '';
    final data = DateTime.tryParse(iso);
    if (data == null) return '';
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthServico>(context);
    final usuario = auth.usuarioAtual;

    return Scaffold(
      backgroundColor: CoresApp.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ───── Hero Header com gradiente ─────
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00288E), Color(0xFF1565C0)],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                  child: Column(
                    children: [
                      // Linha superior com botão de configurações
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/configuracoes'),
                            icon: const Icon(
                              Icons.settings_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Avatar
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white,
                        child: Text(
                          (usuario?.nome ?? 'U')[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF00288E),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        usuario?.nome ?? 'Usuário',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        usuario?.email ?? '',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ───── Conteúdo abaixo do hero ─────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ───── Stats ─────
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: CoresApp.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: CoresApp.outlineVariant,
                              width: 0.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.work_outline, color: CoresApp.primary),
                              const SizedBox(height: 8),
                              Text(
                                '${usuario != null && usuario.isPrestador ? (usuario.totalServicos ?? 0) : _totalContratados}',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                usuario != null && usuario.isPrestador
                                    ? 'SERVIÇOS'
                                    : 'CONTRATADOS',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: CoresApp.onSurfaceVariant,
                                      letterSpacing: 1,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Avaliação só faz sentido pra quem presta serviço —
                      // um cliente não é avaliado por ninguém.
                      if (usuario != null && usuario.isPrestador) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: CoresApp.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: CoresApp.outlineVariant,
                                width: 0.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.star_outline,
                                  color: CoresApp.secondaryContainer,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  (usuario.avaliacao ?? 0).toStringAsFixed(1),
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'AVALIAÇÃO',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: CoresApp.onSurfaceVariant,
                                        letterSpacing: 1,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ───── Menu de Opções ─────
                  _buildMenuItem(
                    context,
                    Icons.person_outline,
                    'Dados Pessoais',
                    aoTocar: () =>
                        Navigator.pushNamed(context, '/dados-pessoais'),
                  ),
                  if (usuario != null && usuario.isPrestador)
                    _buildMenuItem(
                      context,
                      Icons.payment_outlined,
                      'Métodos de Pagamento',
                      aoTocar: () =>
                          Navigator.pushNamed(context, '/metodos-pagamento'),
                    ),
                  _buildMenuItem(
                    context,
                    Icons.notifications_outlined,
                    'Notificações',
                    contador: _notificacoesNaoLidas,
                    aoTocar: () async {
                      await Navigator.pushNamed(context, '/notificacoes');
                      _carregarNotificacoes();
                    },
                  ),
                  _buildMenuItem(
                    context,
                    Icons.shield_outlined,
                    'Segurança',
                    aoTocar: () => Navigator.pushNamed(context, '/seguranca'),
                  ),

                  const SizedBox(height: 24),

                  // ───── Histórico de Serviços ─────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        usuario != null && usuario.isPrestador
                            ? 'Últimos Serviços Prestados'
                            : 'Últimos Serviços Contratados',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          usuario != null && usuario.isPrestador
                              ? '/home-prestador'
                              : '/home',
                          (r) => false,
                          arguments: usuario != null && usuario.isPrestador
                              ? 2
                              : 1,
                        ),
                        child: Text(
                          'Ver todos',
                          style: TextStyle(color: CoresApp.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (_carregando)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_historico.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Nenhum serviço ainda.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CoresApp.onSurfaceVariant,
                        ),
                      ),
                    )
                  else
                    ..._historico.map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _buildServicoHistorico(
                          context,
                          icone: Icons.build_outlined,
                          titulo: p.titulo,
                          subtitulo: _subtitulo(
                            p,
                            usuario != null && usuario.isPrestador,
                          ),
                          status: _textoStatus(p.status),
                          corStatus: _corStatus(p.status),
                        ),
                      ),
                    ),

                  const SizedBox(height: 32),

                  // ───── Trocar de Perfil (sem deslogar) ─────
                  BotaoPrimario(
                    texto: 'Trocar de Perfil',
                    tipo: TipoBotao.contorno,
                    icone: Icons.swap_horiz,
                    aoPresionar: () =>
                        Navigator.pushNamed(context, '/onboarding'),
                  ),

                  const SizedBox(height: 12),

                  // ───── Sair ─────
                  BotaoPrimario(
                    texto: 'Sair da Conta',
                    tipo: TipoBotao.perigo,
                    icone: Icons.logout,
                    aoPresionar: () async {
                      await auth.logout();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (r) => false,
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  // ───── Logo footer ─────
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/logo_ineed.jpeg',
                      width: 48,
                      height: 48,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String titulo, {
    VoidCallback? aoTocar,
    int contador = 0,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        color: CoresApp.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: CoresApp.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: CoresApp.primary, size: 22),
        title: Text(titulo, style: Theme.of(context).textTheme.bodyLarge),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (contador > 0) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: CoresApp.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$contador',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(Icons.chevron_right, color: CoresApp.outline),
          ],
        ),
        onTap:
            aoTocar ??
            () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$titulo - Em breve!')));
            },
      ),
    );
  }

  Widget _buildServicoHistorico(
    BuildContext context, {
    required IconData icone,
    required String titulo,
    required String subtitulo,
    required String status,
    required Color corStatus,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CoresApp.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CoresApp.outlineVariant, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: CoresApp.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icone, color: CoresApp.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(subtitulo, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: corStatus.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: corStatus,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
