// ============================================
// main.dart — Ponto de entrada do app iNeed
// ============================================
// Inicializa o tema, Provider e rotas do aplicativo.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tema/tema_app.dart';
import 'servicos/auth_servico.dart';
import 'servicos/tema_servico.dart';
import 'modelos/usuario.dart';
import 'modelos/proposta.dart';

import 'telas/onboarding/tela_onboarding.dart';
import 'telas/onboarding/tela_explicacao.dart';
import 'telas/autenticacao/tela_login.dart';
import 'telas/autenticacao/tela_cadastro.dart';
import 'telas/autenticacao/tela_completar_prestador.dart';
import 'telas/shell_navegacao.dart';
import 'telas/perfil/tela_perfil.dart';
import 'telas/perfil/tela_dados_pessoais.dart';
import 'telas/perfil/tela_metodos_pagamento.dart';
import 'telas/perfil/tela_notificacoes.dart';
import 'telas/perfil/tela_seguranca.dart';
import 'telas/perfil/tela_configuracoes.dart';
import 'telas/cliente/tela_perfil_prestador.dart';
import 'telas/cliente/tela_detalhes_servico.dart';
import 'telas/cliente/tela_avaliar_servico.dart';
import 'telas/cliente/tela_nova_proposta.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Captura erros de renderização e exibe na tela para debugar a tela em branco
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '⚠️ Erro de Renderização',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                details.exceptionAsString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(details.stack.toString()),
            ],
          ),
        ),
      ),
    );
  };

  runApp(const INeedApp());
}

class INeedApp extends StatelessWidget {
  const INeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthServico()..restaurarSessao()),
        ChangeNotifierProvider(
          create: (_) => TemaServico()..carregarPreferencia(),
        ),
      ],
      child: Consumer2<AuthServico, TemaServico>(
        builder: (context, auth, temaServico, _) {
          return MaterialApp(
            title: 'iNeed - Serviços sob Demanda',
            debugShowCheckedModeBanner: false,
            theme: TemaApp.tema,

            // ───── Rota inicial ─────
            initialRoute: auth.estaLogado
                ? (auth.usuarioAtual!.isPrestador ? '/home-prestador' : '/home')
                : auth.aguardandoPapel
                ? '/onboarding'
                : '/login',

            // ───── Rotas nomeadas ─────
            routes: {
              '/login': (_) => const TelaLogin(),
              '/explicacao': (_) => const TelaExplicacao(),
              '/onboarding': (_) => const TelaOnboarding(),
              '/cadastro': (_) => const TelaCadastro(),
              '/completar-prestador': (_) => const TelaCompletarPrestador(),
              '/perfil': (_) => const TelaPerfil(),
              '/dados-pessoais': (_) => const TelaDadosPessoais(),
              '/metodos-pagamento': (_) => const TelaMetodosPagamento(),
              '/notificacoes': (_) => const TelaNotificacoes(),
              '/seguranca': (_) => const TelaSeguranca(),
              '/configuracoes': (_) => const TelaConfiguracoes(),
            },

            // ───── Rotas com argumentos ─────
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/home':
                  final indice = (settings.arguments as int?) ?? 0;
                  return MaterialPageRoute(
                    builder: (_) => ShellNavegacao(
                      isPrestador: false,
                      indiceInicial: indice,
                    ),
                  );
                case '/home-prestador':
                  final indice = (settings.arguments as int?) ?? 0;
                  return MaterialPageRoute(
                    builder: (_) => ShellNavegacao(
                      isPrestador: true,
                      indiceInicial: indice,
                    ),
                  );
                case '/perfil-prestador':
                  final prestador = settings.arguments as Usuario;
                  return MaterialPageRoute(
                    builder: (_) => TelaPerfilPrestador(prestador: prestador),
                  );
                case '/nova-proposta':
                  final prestador = settings.arguments as Usuario;
                  return MaterialPageRoute(
                    builder: (_) => TelaNovaProposta(prestador: prestador),
                  );
                case '/detalhes-servico':
                  final proposta = settings.arguments as Proposta;
                  return MaterialPageRoute(
                    builder: (_) => TelaDetalhesServico(proposta: proposta),
                  );
                case '/avaliar-servico':
                  final proposta = settings.arguments as Proposta;
                  return MaterialPageRoute(
                    builder: (_) => TelaAvaliarServico(proposta: proposta),
                  );
                default:
                  return null;
              }
            },
          );
        },
      ),
    );
  }
}
