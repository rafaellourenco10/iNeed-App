// ============================================
// usuario.dart — Modelo de Usuário (Cliente e Prestador)
// ============================================

class Usuario {
  final String uid;
  final String nome;
  final String email;
  final String? telefone;
  final String tipo; // 'cliente' ou 'prestador'
  final String? localizacao;

  // Campos específicos do Prestador
  final String? especialidade;
  final double? valorHora;
  final String? biografia;
  final double? avaliacao;
  final int? totalServicos;
  final bool? disponivel;

  final String? criadoEm;
  final String? atualizadoEm;

  Usuario({
    required this.uid,
    required this.nome,
    required this.email,
    this.telefone,
    required this.tipo,
    this.localizacao,
    this.especialidade,
    this.valorHora,
    this.biografia,
    this.avaliacao,
    this.totalServicos,
    this.disponivel,
    this.criadoEm,
    this.atualizadoEm,
  });

  bool get isPrestador => tipo == 'prestador';
  bool get isCliente => tipo == 'cliente';

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      uid: json['uid'] ?? '',
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'],
      tipo: json['tipo'] ?? 'cliente',
      localizacao: json['localizacao'],
      especialidade: json['especialidade'],
      valorHora: json['valorHora'] != null
          ? (json['valorHora'] as num).toDouble()
          : null,
      biografia: json['biografia'],
      avaliacao: json['avaliacao'] != null
          ? (json['avaliacao'] as num).toDouble()
          : null,
      totalServicos: json['totalServicos'],
      disponivel: json['disponivel'],
      criadoEm: json['criadoEm'],
      atualizadoEm: json['atualizadoEm'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'tipo': tipo,
      'localizacao': localizacao,
      'especialidade': especialidade,
      'valorHora': valorHora,
      'biografia': biografia,
      'avaliacao': avaliacao,
      'totalServicos': totalServicos,
      'disponivel': disponivel,
    };
  }
}
