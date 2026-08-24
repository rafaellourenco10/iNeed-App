// ============================================
// usuario.dart — Modelo de Usuário (Cliente e Prestador)
// ============================================

class Usuario {
  final String uid;
  final String nome;
  final String email;
  final String? telefone;
  final String tipo; // 'cliente', 'prestador' ou '' (ainda não escolheu)
  final String? localizacao;
  final String? cpf;
  final String? cep;
  final String? cidade;
  final String? endereco;

  // Método de pagamento (referência, não processa transação)
  final String? chavePix; // prestador — chave pra receber
  final String? formaPagamentoPreferida; // cliente — dinheiro, pix ou cartao

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
    this.cpf,
    this.cep,
    this.cidade,
    this.endereco,
    this.chavePix,
    this.formaPagamentoPreferida,
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
  bool get semPapel => tipo.isEmpty;

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      uid: json['uid'] ?? '',
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'],
      tipo: json['tipo'] ?? 'cliente',
      localizacao: json['localizacao'],
      cpf: json['cpf'],
      cep: json['cep'],
      cidade: json['cidade'],
      endereco: json['endereco'],
      chavePix: json['chavePix'],
      formaPagamentoPreferida: json['formaPagamentoPreferida'],
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
