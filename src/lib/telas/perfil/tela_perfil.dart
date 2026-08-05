// ============================================
// tela_perfil.dart — Perfil do usuário logado
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../servicos/auth_servico.dart';
import '../../widgets/botao_primario.dart';

class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

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
                            onPressed: () {},
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
                              const Icon(
                                Icons.work_outline,
                                color: CoresApp.primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${usuario?.totalServicos ?? 0}',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'SERVIÇOS',
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
                              const Icon(
                                Icons.star_outline,
                                color: CoresApp.secondaryContainer,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                (usuario?.avaliacao ?? 0).toStringAsFixed(1),
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
                  ),

                  const SizedBox(height: 24),

                  // ───── Tornar-se Prestador (só para clientes) ─────
                  if (usuario != null && usuario.isCliente) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00288E), Color(0xFF1565C0)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        leading: const Icon(
                          Icons.work_outline,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Tornar-se Prestador',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'Ofereça seus serviços sem perder sua conta atual',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/completar-prestador',
                        ),
                      ),
                    ),
                  ],

                  // ───── Menu de Opções ─────
                  _buildMenuItem(
                    context,
                    Icons.person_outline,
                    'Dados Pessoais',
                  ),
                  _buildMenuItem(
                    context,
                    Icons.payment_outlined,
                    'Métodos de Pagamento',
                  ),
                  _buildMenuItem(
                    context,
                    Icons.location_on_outlined,
                    'Endereços Salvos',
                  ),
                  _buildMenuItem(
                    context,
                    Icons.notifications_outlined,
                    'Notificações',
                  ),
                  _buildMenuItem(context, Icons.shield_outlined, 'Segurança'),

                  const SizedBox(height: 24),

                  // ───── Histórico de Serviços ─────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Histórico de Serviços',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Ver todos',
                          style: TextStyle(color: CoresApp.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Serviço exemplo 1
                  _buildServicoHistorico(
                    context,
                    icone: Icons.plumbing,
                    titulo: 'Conserto de Vazamento',
                    subtitulo: 'Hoje, 14:30 - R. das Flores, 123',
                    status: 'EM ANDAMENTO',
                    corStatus: CoresApp.statusEmAndamento,
                  ),
                  const SizedBox(height: 8),

                  // Serviço exemplo 2
                  _buildServicoHistorico(
                    context,
                    icone: Icons.cleaning_services,
                    titulo: 'Limpeza Residencial',
                    subtitulo: 'Ontem, 09:00 - Avaliado 5.0',
                    status: 'CONCLUÍDO',
                    corStatus: CoresApp.statusConcluida,
                  ),

                  const SizedBox(height: 32),

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

  Widget _buildMenuItem(BuildContext context, IconData icon, String titulo) {
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
        trailing: const Icon(Icons.chevron_right, color: CoresApp.outline),
        onTap: () {
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
