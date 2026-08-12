// ============================================
// api_servico.dart — Comunicação HTTP com o backend
// ============================================
// Centraliza todas as requisições para a API REST do iNeed.
// Regra: O app Flutter NÃO se conecta diretamente ao Firebase.

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServico {
  // URL base da API — backend publicado no Render
  static const String _urlBase = 'https://ineed-app-9lzp.onrender.com/api';

  // Headers padrão
  static Map<String, String> _headers({String? token}) {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ───── Autenticação ─────

  /// Cadastrar um novo cliente
  static Future<Map<String, dynamic>> cadastrarCliente({
    required String nome,
    required String email,
    required String senha,
    String? telefone,
    String? cpf,
    String? cep,
    String? endereco,
    String? cidade,
  }) async {
    final resposta = await http.post(
      Uri.parse('$_urlBase/auth/cadastro-cliente'),
      headers: _headers(),
      body: jsonEncode({
        'nome': nome,
        'email': email,
        'senha': senha,
        'telefone': telefone,
        'cpf': cpf,
        'cep': cep,
        'endereco': endereco,
        'cidade': cidade,
      }),
    );
    return jsonDecode(resposta.body) as Map<String, dynamic>;
  }

  /// Adiciona informações de prestador a uma conta já cadastrada (requer token)
  static Future<Map<String, dynamic>> tornarPrestador({
    required String token,
    required String especialidade,
    required double valorHora,
    String? biografia,
  }) async {
    final resposta = await http.patch(
      Uri.parse('$_urlBase/auth/tornar-prestador'),
      headers: _headers(token: token),
      body: jsonEncode({
        'especialidade': especialidade,
        'valorHora': valorHora,
        'biografia': biografia,
      }),
    );
    return jsonDecode(resposta.body) as Map<String, dynamic>;
  }

  /// Cadastrar um novo prestador
  static Future<Map<String, dynamic>> cadastrarPrestador({
    required String nome,
    required String email,
    required String senha,
    required String especialidade,
    String? telefone,
    double? valorHora,
    String? biografia,
  }) async {
    final resposta = await http.post(
      Uri.parse('$_urlBase/auth/cadastro-prestador'),
      headers: _headers(),
      body: jsonEncode({
        'nome': nome,
        'email': email,
        'senha': senha,
        'especialidade': especialidade,
        'telefone': telefone,
        'valorHora': valorHora,
        'biografia': biografia,
      }),
    );
    return jsonDecode(resposta.body) as Map<String, dynamic>;
  }

  /// Login — valida email + senha no backend e retorna token + dados do usuário
  static Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    final resposta = await http.post(
      Uri.parse('$_urlBase/auth/login'),
      headers: _headers(),
      body: jsonEncode({'email': email, 'senha': senha}),
    );
    return jsonDecode(resposta.body) as Map<String, dynamic>;
  }

  // ───── Prestadores ─────

  /// Listar prestadores cadastrados de verdade (Firestore, via backend)
  static Future<Map<String, dynamic>> listarPrestadores({
    String? especialidade,
    double? valorMaximo,
    String? excluirUid,
  }) async {
    final query = <String, String>{};
    if (especialidade != null && especialidade.isNotEmpty) {
      query['especialidade'] = especialidade;
    }
    if (valorMaximo != null) {
      query['valorMaximo'] = valorMaximo.toString();
    }
    if (excluirUid != null && excluirUid.isNotEmpty) {
      query['excluirUid'] = excluirUid;
    }

    final uri = Uri.parse(
      '$_urlBase/prestadores',
    ).replace(queryParameters: query.isEmpty ? null : query);

    final resposta = await http.get(uri, headers: _headers());
    return jsonDecode(resposta.body) as Map<String, dynamic>;
  }

  /// Obter detalhes de um prestador específico
  static Future<Map<String, dynamic>> obterPrestador(String id) async {
    final resposta = await http.get(
      Uri.parse('$_urlBase/prestadores/$id'),
      headers: _headers(),
    );
    return jsonDecode(resposta.body) as Map<String, dynamic>;
  }

  // ───── Propostas ─────

  /// Criar uma nova proposta (requer token)
  static Future<Map<String, dynamic>> criarProposta({
    required String token,
    required String idPrestador,
    required String titulo,
    required double valor,
    String? descricao,
    String? data,
    String? horario,
    String? endereco,
  }) async {
    final resposta = await http.post(
      Uri.parse('$_urlBase/propostas'),
      headers: _headers(token: token),
      body: jsonEncode({
        'idPrestador': idPrestador,
        'titulo': titulo,
        'valor': valor,
        'descricao': descricao,
        'data': data,
        'horario': horario,
        'endereco': endereco,
      }),
    );
    return jsonDecode(resposta.body) as Map<String, dynamic>;
  }

  /// Listar propostas de um prestador (MOCK PARA TESTE DE UI)
  static Future<Map<String, dynamic>> listarPropostas({
    required String idPrestador,
    String? status,
  }) async {
    // Simula tempo de rede
    await Future.delayed(const Duration(milliseconds: 800));

    final todasPropostas = [
      {
        'id': 'prop1',
        'idPrestador': idPrestador,
        'idCliente': 'cliente1',
        'titulo': 'Conserto de Tomada 220v',
        'descricao':
            'Preciso de alguém para consertar uma tomada derretida na cozinha.',
        'valor': 150.0,
        'status': 'pendente',
        'data': '15/06/2026',
        'horario': '14:00',
        'endereco': 'Rua das Flores, 123 - Centro',
        'nomePrestador': 'Você',
        'criadoEm': DateTime.now()
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
        'atualizadoEm': DateTime.now()
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
      },
      {
        'id': 'prop2',
        'idPrestador': idPrestador,
        'idCliente': 'cliente2',
        'titulo': 'Instalação de Chuveiro',
        'descricao': 'Instalação de chuveiro elétrico novo no banheiro social.',
        'valor': 80.0,
        'status': 'em_andamento',
        'data': '16/06/2026',
        'horario': '09:00',
        'endereco': 'Av. Paulista, 1500 - Apto 42',
        'nomePrestador': 'Você',
        'criadoEm': DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
        'atualizadoEm': DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
      },
      {
        'id': 'prop3',
        'idPrestador': idPrestador,
        'idCliente': 'cliente3',
        'titulo': 'Troca de Fiação Completa',
        'descricao': 'Substituição de fios antigos do quadro de luz.',
        'valor': 850.0,
        'status': 'concluida',
        'data': '10/06/2026',
        'horario': '08:00',
        'endereco': 'Rua Augusta, 500',
        'nomePrestador': 'Você',
        'criadoEm': DateTime.now()
            .subtract(const Duration(days: 5))
            .toIso8601String(),
        'atualizadoEm': DateTime.now()
            .subtract(const Duration(days: 2))
            .toIso8601String(),
      },
    ];

    var filtradas = todasPropostas;
    if (status != null && status.isNotEmpty) {
      filtradas = filtradas.where((p) => p['status'] == status).toList();
    }

    return {
      'mensagem': '${filtradas.length} proposta(s) encontrada(s).',
      'propostas': filtradas,
    };
  }

  /// Atualizar status de uma proposta (requer token)
  static Future<Map<String, dynamic>> atualizarProposta({
    required String token,
    required String id,
    required String status,
  }) async {
    final resposta = await http.patch(
      Uri.parse('$_urlBase/propostas/$id'),
      headers: _headers(token: token),
      body: jsonEncode({'status': status}),
    );
    return jsonDecode(resposta.body) as Map<String, dynamic>;
  }

  // Lista em memória dos serviços contratados dinamicamente
  static final List<Map<String, dynamic>> _pedidosContratados = [];

  /// Adiciona um novo pedido quando o cliente contrata um serviço
  static void contratarServico({
    required String idCliente,
    required String idPrestador,
    required String nomePrestador,
    required String especialidade,
  }) {
    _pedidosContratados.add({
      'id': 'ped_${DateTime.now().millisecondsSinceEpoch}',
      'idCliente': idCliente,
      'idPrestador': idPrestador,
      'nomePrestador': nomePrestador,
      'especialidadePrestador': especialidade,
      'titulo': 'Contratação — $especialidade',
      'descricao': 'Serviço contratado diretamente pelo app.',
      'valor': 0.0,
      'status': 'pendente',
      'data': null,
      'horario': null,
      'endereco': null,
    });
  }

  /// Listar pedidos do cliente (MOCK PARA TESTE DE UI)
  static Future<Map<String, dynamic>> listarPedidosCliente({
    required String idCliente,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final pedidos = [
      {
        'id': 'ped1',
        'idCliente': idCliente,
        'idPrestador': '1',
        'nomePrestador': 'João Silva',
        'especialidadePrestador': 'Eletricista',
        'telefonePrestador': '5511991110001',
        'titulo': 'Conserto de Tomada 220v',
        'descricao': 'Tomada derretida na cozinha precisa de reparo.',
        'valor': 150.0,
        'status': 'pendente',
        'data': '20/06/2026',
        'horario': '14:00',
        'endereco': 'Rua das Flores, 123 - Centro',
      },
      {
        'id': 'ped2',
        'idCliente': idCliente,
        'idPrestador': '2',
        'nomePrestador': 'Maria Souza',
        'especialidadePrestador': 'Encanador',
        'telefonePrestador': '5511991110002',
        'titulo': 'Vazamento na Pia do Banheiro',
        'descricao': 'Pia com vazamento constante há 3 dias.',
        'valor': 200.0,
        'status': 'em_andamento',
        'data': '17/06/2026',
        'horario': '09:00',
        'endereco': 'Av. Brasil, 500 - Apto 12',
      },
      {
        'id': 'ped3',
        'idCliente': idCliente,
        'idPrestador': '4',
        'nomePrestador': 'Ana Clara',
        'especialidadePrestador': 'Faxina',
        'telefonePrestador': '5511991110004',
        'titulo': 'Limpeza Pós-Obra',
        'descricao': 'Limpeza completa após reforma do quarto.',
        'valor': 350.0,
        'status': 'concluida',
        'data': '10/06/2026',
        'horario': '08:00',
        'endereco': 'Rua Augusta, 200',
      },
      {
        'id': 'ped4',
        'idCliente': idCliente,
        'idPrestador': '3',
        'nomePrestador': 'Carlos Eduardo',
        'especialidadePrestador': 'Pintor',
        'telefonePrestador': '5511991110003',
        'titulo': 'Pintura da Sala',
        'descricao': 'Pintura completa da sala de estar.',
        'valor': 800.0,
        'status': 'recusada',
        'data': '05/06/2026',
        'horario': '10:00',
        'endereco': 'Rua das Palmeiras, 77',
      },
    ];

    final extras = _pedidosContratados
        .where((p) => p['idCliente'] == idCliente)
        .toList();

    final todos = [...pedidos, ...extras];

    return {
      'mensagem': '${todos.length} pedido(s) encontrado(s).',
      'pedidos': todos,
    };
  }

  // ───── Solicitações (visão do Prestador) ─────

  /// Lista solicitações abertas de clientes para o prestador navegar
  static Future<Map<String, dynamic>> listarSolicitacoes({
    String? especialidade,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final todas = [
      {
        'id': 'sol1',
        'idCliente': 'cli1',
        'nomeCliente': 'Fernando Oliveira',
        'titulo': 'Instalação de pontos de luz',
        'descricao':
            'Preciso instalar 3 pontos de luz no quarto e na sala. Fio já passado, só precisa do ponto.',
        'especialidade': 'Eletricista',
        'valor': 150.0,
        'valorNegociavel': false,
        'cidade': 'São Paulo',
        'bairro': 'Pinheiros',
        'urgente': false,
        'criadoEm': 'Há 1 hora',
        'avaliacaoCliente': 4.9,
      },
      {
        'id': 'sol2',
        'idCliente': 'cli2',
        'nomeCliente': 'Carla Mendes',
        'titulo': 'Chuveiro elétrico sem aquecimento',
        'descricao':
            'Chuveiro parou de aquecer ontem. Pode ser resistência ou fiação.',
        'especialidade': 'Eletricista',
        'valor': 80.0,
        'valorNegociavel': true,
        'cidade': 'São Paulo',
        'bairro': 'Vila Madalena',
        'urgente': true,
        'criadoEm': 'Há 2 horas',
        'avaliacaoCliente': 4.7,
      },
      {
        'id': 'sol3',
        'idCliente': 'cli3',
        'nomeCliente': 'Roberto Santos',
        'titulo': 'Disjuntor caindo frequentemente',
        'descricao':
            'O disjuntor do quadro cai toda vez que ligo o ar condicionado. Preciso de solução urgente.',
        'especialidade': 'Eletricista',
        'valor': 200.0,
        'valorNegociavel': false,
        'cidade': 'São Paulo',
        'bairro': 'Moema',
        'urgente': true,
        'criadoEm': 'Há 3 horas',
        'avaliacaoCliente': 5.0,
      },
      {
        'id': 'sol4',
        'idCliente': 'cli4',
        'nomeCliente': 'Ana Beatriz Costa',
        'titulo': 'Iluminação externa do jardim',
        'descricao':
            'Quero instalar luminárias de jardim na entrada e no fundo do terreno.',
        'especialidade': 'Eletricista',
        'valor': 0.0,
        'valorNegociavel': true,
        'cidade': 'São Paulo',
        'bairro': 'Perdizes',
        'urgente': false,
        'criadoEm': 'Há 5 horas',
        'avaliacaoCliente': 4.8,
      },
      {
        'id': 'sol5',
        'idCliente': 'cli5',
        'nomeCliente': 'Marcos Ferreira',
        'titulo': 'Instalação de 4 ventiladores de teto',
        'descricao':
            'Apartamento novo, preciso instalar 4 ventiladores com controle remoto.',
        'especialidade': 'Eletricista',
        'valor': 120.0,
        'valorNegociavel': false,
        'cidade': 'São Paulo',
        'bairro': 'Lapa',
        'urgente': false,
        'criadoEm': 'Há 6 horas',
        'avaliacaoCliente': 4.6,
      },
      {
        'id': 'sol6',
        'idCliente': 'cli6',
        'nomeCliente': 'Juliana Ramos',
        'titulo': 'Vazamento embaixo da pia',
        'descricao':
            'Pia da cozinha com vazamento no sifão. Precisa trocar conexão.',
        'especialidade': 'Encanador',
        'valor': 90.0,
        'valorNegociavel': true,
        'cidade': 'São Paulo',
        'bairro': 'Brooklin',
        'urgente': false,
        'criadoEm': 'Há 1 hora',
        'avaliacaoCliente': 4.9,
      },
      {
        'id': 'sol7',
        'idCliente': 'cli7',
        'nomeCliente': 'Pedro Alves',
        'titulo': 'Pintura completa da sala',
        'descricao':
            'Sala de 40m², paredes claras. Tinta por conta do cliente.',
        'especialidade': 'Pintor',
        'valor': 600.0,
        'valorNegociavel': true,
        'cidade': 'São Paulo',
        'bairro': 'Tatuapé',
        'urgente': false,
        'criadoEm': 'Há 4 horas',
        'avaliacaoCliente': 4.5,
      },
    ];

    var resultado = todas;
    if (especialidade != null && especialidade.isNotEmpty) {
      resultado = todas
          .where(
            (s) => (s['especialidade'] as String).toLowerCase().contains(
              especialidade.toLowerCase(),
            ),
          )
          .toList();
    }

    return {
      'mensagem': '${resultado.length} solicitação(ões) encontrada(s).',
      'solicitacoes': resultado,
    };
  }

  // ───── Health Check ─────

  /// Verificar se o servidor está online
  static Future<bool> verificarSaude() async {
    try {
      final resposta = await http
          .get(Uri.parse('$_urlBase/saude'), headers: _headers())
          .timeout(const Duration(seconds: 5));
      return resposta.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
