// ============================================
// proposta.dart — Modelo de Proposta de Serviço
// ============================================

class Proposta {
  final String id;
  final String idCliente;
  final String nomeCliente;
  final String? emailCliente;
  final String idPrestador;
  final String? nomePrestador;
  final String titulo;
  final String? descricao;
  final double valor;
  final String? data;
  final String? horario;
  final String? endereco;
  final String status; // pendente, aceita, recusada, em_andamento, concluida
  final String? criadaEm;
  final String? atualizadaEm;

  Proposta({
    required this.id,
    required this.idCliente,
    required this.nomeCliente,
    this.emailCliente,
    required this.idPrestador,
    this.nomePrestador,
    required this.titulo,
    this.descricao,
    required this.valor,
    this.data,
    this.horario,
    this.endereco,
    required this.status,
    this.criadaEm,
    this.atualizadaEm,
  });

  bool get isPendente => status == 'pendente';
  bool get isAceita => status == 'aceita';
  bool get isRecusada => status == 'recusada';
  bool get isEmAndamento => status == 'em_andamento';
  bool get isConcluida => status == 'concluida';

  factory Proposta.fromJson(Map<String, dynamic> json) {
    return Proposta(
      id: json['id'] ?? '',
      idCliente: json['idCliente'] ?? '',
      nomeCliente: json['nomeCliente'] ?? '',
      emailCliente: json['emailCliente'],
      idPrestador: json['idPrestador'] ?? '',
      nomePrestador: json['nomePrestador'],
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'],
      valor: json['valor'] != null
          ? (json['valor'] as num).toDouble()
          : 0.0,
      data: json['data'],
      horario: json['horario'],
      endereco: json['endereco'],
      status: json['status'] ?? 'pendente',
      criadaEm: json['criadaEm'],
      atualizadaEm: json['atualizadaEm'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCliente': idCliente,
      'nomeCliente': nomeCliente,
      'idPrestador': idPrestador,
      'titulo': titulo,
      'descricao': descricao,
      'valor': valor,
      'data': data,
      'horario': horario,
      'endereco': endereco,
    };
  }
}
