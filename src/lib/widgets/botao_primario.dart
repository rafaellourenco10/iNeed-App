// ============================================
// botao_primario.dart — Botões reutilizáveis do iNeed
// ============================================

import 'package:flutter/material.dart';
import '../tema/cores.dart';

enum TipoBotao { primario, secundario, contorno, perigo }

class BotaoPrimario extends StatelessWidget {
  final String texto;
  final VoidCallback? aoPresionar;
  final TipoBotao tipo;
  final bool carregando;
  final IconData? icone;

  const BotaoPrimario({
    super.key,
    required this.texto,
    this.aoPresionar,
    this.tipo = TipoBotao.primario,
    this.carregando = false,
    this.icone,
  });

  @override
  Widget build(BuildContext context) {
    switch (tipo) {
      case TipoBotao.secundario:
        return _buildBotao(
          context,
          corFundo: CoresApp.secondaryContainer,
          corTexto: CoresApp.onSecondaryContainer,
        );
      case TipoBotao.contorno:
        return _buildBotaoContorno(context);
      case TipoBotao.perigo:
        return _buildBotaoContorno(
          context,
          corBorda: CoresApp.error,
          corTexto: CoresApp.error,
        );
      default:
        return _buildBotao(
          context,
          corFundo: CoresApp.primary,
          corTexto: CoresApp.onPrimary,
        );
    }
  }

  Widget _buildBotao(
    BuildContext context, {
    required Color corFundo,
    required Color corTexto,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: carregando ? null : aoPresionar,
        style: ElevatedButton.styleFrom(
          backgroundColor: corFundo,
          foregroundColor: corTexto,
          disabledBackgroundColor: corFundo.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: carregando
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(corTexto),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icone != null) ...[
                    Icon(icone, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    texto,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildBotaoContorno(
    BuildContext context, {
    Color? corBorda,
    Color? corTexto,
  }) {
    final borda = corBorda ?? CoresApp.outlineVariant;
    final texto_ = corTexto ?? CoresApp.primary;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: carregando ? null : aoPresionar,
        style: OutlinedButton.styleFrom(
          foregroundColor: texto_,
          side: BorderSide(color: borda),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: carregando
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(texto_),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icone != null) ...[
                    Icon(icone, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    texto,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: texto_,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
