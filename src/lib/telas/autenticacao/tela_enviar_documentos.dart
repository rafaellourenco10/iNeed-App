// ============================================
// tela_enviar_documentos.dart — Verificação de perfil do prestador
// ============================================
// Etapa depois de completar o cadastro de prestador. Por enquanto só a
// interface — envio e validação pelo admin ainda não estão implementados.

import 'package:flutter/material.dart';
import '../../tema/cores.dart';

class TelaEnviarDocumentos extends StatelessWidget {
  const TelaEnviarDocumentos({super.key});

  void _emBreve(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Envio de documentos em breve!')),
    );
  }

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
        child: SingleChildScrollView(
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
                  Icons.verified_outlined,
                  color: CoresApp.primary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Envie seus documentos',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Valide que você é um profissional qualificado pra gerar '
                'mais confiança pros clientes na hora de contratar.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: CoresApp.onSurfaceVariant,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              _cartaoDocumento(
                context,
                icone: Icons.badge_outlined,
                titulo: 'Documento com foto',
                subtitulo: 'RG, CNH ou outro documento oficial',
              ),
              const SizedBox(height: 12),
              _cartaoDocumento(
                context,
                icone: Icons.workspace_premium_outlined,
                titulo: 'Comprovante de qualificação',
                subtitulo: 'Certificado, diploma ou registro profissional',
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: CoresApp.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CoresApp.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: CoresApp.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Depois de enviados, nossa equipe analisa os documentos. '
                        'Se aprovado, seu perfil ganha um selo de verificado, '
                        'visível pros clientes.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: CoresApp.onSurface,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home-prestador',
                    (r) => false,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CoresApp.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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

  Widget _cartaoDocumento(
    BuildContext context, {
    required IconData icone,
    required String titulo,
    required String subtitulo,
  }) {
    return InkWell(
      onTap: () => _emBreve(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CoresApp.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CoresApp.outlineVariant, width: 0.5),
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
                    subtitulo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: CoresApp.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.upload_outlined, color: CoresApp.outline),
          ],
        ),
      ),
    );
  }
}
