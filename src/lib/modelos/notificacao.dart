// ============================================
// notificacao.dart — Modelo de Notificação
// ============================================

class Notificacao {
  final String id;
  final String tipo;
  final String titulo;
  final String mensagem;
  final String? idProposta;
  final bool lida;
  final String? criadaEm;

  Notificacao({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.mensagem,
    this.idProposta,
    required this.lida,
    this.criadaEm,
  });

  factory Notificacao.fromJson(Map<String, dynamic> json) {
    return Notificacao(
      id: json['id'] ?? '',
      tipo: json['tipo'] ?? '',
      titulo: json['titulo'] ?? '',
      mensagem: json['mensagem'] ?? '',
      idProposta: json['idProposta'],
      lida: json['lida'] == true,
      criadaEm: json['criadaEm'],
    );
  }
}
