// ============================================
// api_servico.dart — Comunicação HTTP com o backend
// ============================================
// Centraliza todas as requisições para a API REST do iNeed.
// Regra: O app Flutter NÃO se conecta diretamente ao Firebase.

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServico {
  // URL base da API — apontar para o backend local ou remoto
  // Android Emulator usa 10.0.2.2 para acessar localhost da máquina host
  static const String _urlBase = 'http://10.0.2.2:3000/api';

  // Headers padrão
  static Map<String, String> _headers({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
    };
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
    String? localizacao,
  }) async {
    final resposta = await http.post(
      Uri.parse('$_urlBase/auth/cadastro-cliente'),
      headers: _headers(),
      body: jsonEncode({
        'nome': nome,
        'email': email,
        'senha': senha,
        'telefone': telefone,
        'localizacao': localizacao,
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

  /// Login — buscar dados do usuário pelo email
  static Future<Map<String, dynamic>> login({
    required String email,
  }) async {
    final resposta = await http.post(
      Uri.parse('$_urlBase/auth/login'),
      headers: _headers(),
      body: jsonEncode({'email': email}),
    );
    return jsonDecode(resposta.body) as Map<String, dynamic>;
  }

  // ───── Prestadores ─────

  /// Listar todos os prestadores (MOCK PARA TESTE DE UI)
  static Future<Map<String, dynamic>> listarPrestadores({
    String? especialidade,
    double? valorMaximo,
  }) async {
    // Simula tempo de rede
    await Future.delayed(const Duration(milliseconds: 800));

    final todosPrestadores = [
      {
        'uid': '1',
        'nome': 'João Silva',
        'email': 'joao@email.com',
        'especialidade': 'Eletricista',
        'biografia': 'Mais de 10 anos de experiência com instalações elétricas.',
        'avaliacao': 4.8,
        'totalServicos': 120,
        'valorHora': 80.0,
      },
      {
        'uid': '2',
        'nome': 'Maria Souza',
        'email': 'maria@email.com',
        'especialidade': 'Encanador',
        'biografia': 'Especialista em vazamentos e tubulações.',
        'avaliacao': 4.9,
        'totalServicos': 85,
        'valorHora': 90.0,
      },
      {
        'uid': '3',
        'nome': 'Carlos Eduardo',
        'email': 'carlos@email.com',
        'especialidade': 'Pintor',
        'biografia': 'Pintura residencial e comercial com ótimo acabamento.',
        'avaliacao': 4.7,
        'totalServicos': 45,
        'valorHora': 60.0,
      },
      {
        'uid': '4',
        'nome': 'Ana Clara',
        'email': 'ana@email.com',
        'especialidade': 'Faxina',
        'biografia': 'Limpeza pesada, pós-obra e diarista.',
        'avaliacao': 5.0,
        'totalServicos': 200,
        'valorHora': 50.0,
      },
    ];

    // Filtro mockado
    var filtrados = todosPrestadores;
    if (especialidade != null && especialidade.isNotEmpty) {
      filtrados = filtrados.where((p) => 
        (p['especialidade'] as String).toLowerCase() == especialidade.toLowerCase()
      ).toList();
    }

    return {
      'mensagem': '${filtrados.length} prestador(es) encontrado(s).',
      'prestadores': filtrados,
    };
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
        'descricao': 'Preciso de alguém para consertar uma tomada derretida na cozinha.',
        'valor': 150.0,
        'status': 'pendente',
        'data': '15/06/2026',
        'horario': '14:00',
        'endereco': 'Rua das Flores, 123 - Centro',
        'nomePrestador': 'Você',
        'criadoEm': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        'atualizadoEm': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
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
        'criadoEm': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'atualizadoEm': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
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
        'criadoEm': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        'atualizadoEm': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
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

  // ───── Health Check ─────

  /// Verificar se o servidor está online
  static Future<bool> verificarSaude() async {
    try {
      final resposta = await http.get(
        Uri.parse('$_urlBase/saude'),
        headers: _headers(),
      ).timeout(const Duration(seconds: 5));
      return resposta.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
