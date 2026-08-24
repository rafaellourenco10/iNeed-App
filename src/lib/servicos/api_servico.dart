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

  /// Listar propostas recebidas por um prestador (requer token — só o
  /// próprio prestador pode ver as próprias propostas)
  static Future<Map<String, dynamic>> listarPropostas({
    required String token,
    required String idPrestador,
    String? status,
  }) async {
    final query = <String, String>{};
    if (status != null && status.isNotEmpty) {
      query['status'] = status;
    }
    final uri = Uri.parse(
      '$_urlBase/propostas/$idPrestador',
    ).replace(queryParameters: query.isEmpty ? null : query);

    final resposta = await http.get(uri, headers: _headers(token: token));
    return jsonDecode(resposta.body) as Map<String, dynamic>;
  }

  /// Listar propostas enviadas pelo cliente autenticado (requer token)
  static Future<Map<String, dynamic>> listarPropostasCliente({
    required String token,
  }) async {
    final resposta = await http.get(
      Uri.parse('$_urlBase/propostas/cliente/minhas'),
      headers: _headers(token: token),
    );
    return jsonDecode(resposta.body) as Map<String, dynamic>;
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

  // ───── Avaliações ─────

  /// Avaliar um serviço concluído (requer token — só o cliente dono)
  static Future<Map<String, dynamic>> criarAvaliacao({
    required String token,
    required String idProposta,
    required int estrelas,
    String? comentario,
    List<String>? elogios,
  }) async {
    final resposta = await http.post(
      Uri.parse('$_urlBase/avaliacoes'),
      headers: _headers(token: token),
      body: jsonEncode({
        'idProposta': idProposta,
        'estrelas': estrelas,
        'comentario': comentario,
        'elogios': elogios ?? [],
      }),
    );
    return jsonDecode(resposta.body) as Map<String, dynamic>;
  }

  /// Listar avaliações recebidas por um prestador (pública)
  static Future<Map<String, dynamic>> listarAvaliacoesPrestador(
    String idPrestador,
  ) async {
    final resposta = await http.get(
      Uri.parse('$_urlBase/avaliacoes/prestador/$idPrestador'),
      headers: _headers(),
    );
    return jsonDecode(resposta.body) as Map<String, dynamic>;
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
