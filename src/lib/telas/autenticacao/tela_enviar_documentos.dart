// ============================================
// tela_enviar_documentos.dart — Verificação de perfil do prestador
// ============================================
// Etapa depois de completar o cadastro de prestador (e acessível pelo
// perfil). O prestador fotografa um documento com foto e um comprovante
// de qualificação; a equipe analisa pela página /admin do backend.
// Aprovado → perfil ganha o selo de verificado.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../servicos/api_servico.dart';
import '../../servicos/auth_servico.dart';
import '../../tema/cores.dart';

class TelaEnviarDocumentos extends StatefulWidget {
  const TelaEnviarDocumentos({super.key});

  @override
  State<TelaEnviarDocumentos> createState() => _TelaEnviarDocumentosState();
}

class _TelaEnviarDocumentosState extends State<TelaEnviarDocumentos> {
  bool _carregando = true;
  bool _enviando = false;
  String? _status; // null (nunca enviou), pendente, aprovado, recusado
  String? _motivoRecusa;

  XFile? _documentoFoto;
  XFile? _comprovante;

  @override
  void initState() {
    super.initState();
    _carregarStatus();
  }

  Future<void> _carregarStatus() async {
    final auth = Provider.of<AuthServico>(context, listen: false);
    try {
      final resposta = await ApiServico.minhaVerificacao(
        token: auth.token ?? '',
      );
      if (!mounted) return;
      setState(() {
        _status = resposta['status'];
        _motivoRecusa = resposta['motivoRecusa'];
      });
    } catch (_) {
      // Sem conexão — mostra o formulário normalmente.
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<XFile?> _escolherFoto() async {
    final origem = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Tirar foto'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Escolher da galeria'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (origem == null) return null;

    // Comprime no aparelho — o backend aceita até ~600 KB por imagem
    return ImagePicker().pickImage(
      source: origem,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 70,
    );
  }

  Future<void> _enviar() async {
    final auth = Provider.of<AuthServico>(context, listen: false);
    setState(() => _enviando = true);

    try {
      final resposta = await ApiServico.enviarVerificacao(
        token: auth.token ?? '',
        documentoFoto: base64Encode(await _documentoFoto!.readAsBytes()),
        comprovante: base64Encode(await _comprovante!.readAsBytes()),
      );
      if (!mounted) return;

      if (resposta.containsKey('erro')) {
        _mostrarMensagem(resposta['mensagem'] ?? 'Erro ao enviar documentos.');
      } else {
        setState(() {
          _status = 'pendente';
          _motivoRecusa = null;
        });
        _mostrarMensagem(resposta['mensagem'] ?? 'Documentos enviados!');
      }
    } catch (_) {
      if (mounted) {
        _mostrarMensagem('Sem conexão. Tente novamente.');
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  bool get _podeEnviar => _status == null || _status == 'recusado';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.surface,
      appBar: AppBar(
        backgroundColor: CoresApp.surface,
        elevation: 0,
        title: const Text('Verificação de Perfil'),
      ),
      body: SafeArea(
        child: _carregando
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: CoresApp.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        _status == 'aprovado'
                            ? Icons.verified
                            : Icons.verified_outlined,
                        color: CoresApp.primary,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      _titulo,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _subtitulo,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CoresApp.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),

                    if (_status == 'recusado' && _motivoRecusa != null) ...[
                      const SizedBox(height: 20),
                      _aviso(
                        icone: Icons.error_outline,
                        cor: CoresApp.error,
                        texto: 'Motivo da recusa: $_motivoRecusa',
                      ),
                    ],

                    if (_podeEnviar) ...[
                      const SizedBox(height: 32),
                      _cartaoDocumento(
                        icone: Icons.badge_outlined,
                        titulo: 'Documento com foto',
                        subtitulo: 'RG, CNH ou outro documento oficial',
                        arquivo: _documentoFoto,
                        aoEscolher: (f) => setState(() => _documentoFoto = f),
                      ),
                      const SizedBox(height: 12),
                      _cartaoDocumento(
                        icone: Icons.workspace_premium_outlined,
                        titulo: 'Comprovante de qualificação',
                        subtitulo:
                            'Certificado, diploma ou registro profissional',
                        arquivo: _comprovante,
                        aoEscolher: (f) => setState(() => _comprovante = f),
                      ),
                      const SizedBox(height: 24),
                      _aviso(
                        icone: Icons.info_outline,
                        cor: CoresApp.primary,
                        texto:
                            'Depois de enviados, nossa equipe analisa os documentos. '
                            'Se aprovado, seu perfil ganha um selo de verificado, '
                            'visível pros clientes.',
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _documentoFoto != null &&
                                  _comprovante != null &&
                                  !_enviando
                              ? _enviar
                              : null,
                          style: _estiloBotao,
                          child: _enviando
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Enviar para análise',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: _podeEnviar
                          ? TextButton(
                              onPressed: _irParaHome,
                              child: const Text('Fazer depois'),
                            )
                          : ElevatedButton(
                              onPressed: _irParaHome,
                              style: _estiloBotao,
                              child: const Text(
                                'Continuar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  String get _titulo => switch (_status) {
    'pendente' => 'Documentos em análise',
    'aprovado' => 'Perfil verificado',
    'recusado' => 'Envie novamente',
    _ => 'Envie seus documentos',
  };

  String get _subtitulo => switch (_status) {
    'pendente' =>
      'Recebemos seus documentos. Assim que a equipe analisar, '
          'você recebe uma notificação.',
    'aprovado' => 'Seu perfil tem o selo de verificado, visível pros clientes.',
    'recusado' =>
      'Seus documentos não foram aprovados. Confira o motivo abaixo '
          'e envie fotos novas.',
    _ =>
      'Valide que você é um profissional qualificado pra gerar '
          'mais confiança pros clientes na hora de contratar.',
  };

  void _irParaHome() => Navigator.pushNamedAndRemoveUntil(
    context,
    '/home-prestador',
    (r) => false,
  );

  ButtonStyle get _estiloBotao => ElevatedButton.styleFrom(
    backgroundColor: CoresApp.primary,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  Widget _aviso({
    required IconData icone,
    required Color cor,
    required String texto,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(icone, color: cor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: CoresApp.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartaoDocumento({
    required IconData icone,
    required String titulo,
    required String subtitulo,
    required XFile? arquivo,
    required ValueChanged<XFile> aoEscolher,
  }) {
    final escolhido = arquivo != null;
    return InkWell(
      onTap: _enviando
          ? null
          : () async {
              final foto = await _escolherFoto();
              if (foto != null) aoEscolher(foto);
            },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CoresApp.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: escolhido ? CoresApp.primary : CoresApp.outlineVariant,
            width: escolhido ? 1 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icone, color: CoresApp.primary, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    escolhido
                        ? 'Foto selecionada — toque pra trocar'
                        : subtitulo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: CoresApp.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              escolhido ? Icons.check_circle : Icons.upload_outlined,
              color: escolhido ? CoresApp.primary : CoresApp.outline,
            ),
          ],
        ),
      ),
    );
  }
}
