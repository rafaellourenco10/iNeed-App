// ============================================
// cores.dart — Paleta de cores do iNeed
// ============================================
// Baseado no Design System (DESIGN.md) das telas.

import 'package:flutter/material.dart';

class CoresApp {
  CoresApp._();

  // ───── Primary (Azul Confiável) ─────
  static const Color primary = Color(0xFF00288E);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF1E40AF);
  static const Color onPrimaryContainer = Color(0xFFA8B8FF);
  static const Color inversePrimary = Color(0xFFB8C4FF);
  static const Color primaryFixed = Color(0xFFDDE1FF);
  static const Color primaryFixedDim = Color(0xFFB8C4FF);

  // ───── Secondary (Laranja Vibrante — CTA) ─────
  static const Color secondary = Color(0xFF9D4300);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFD761A);
  static const Color onSecondaryContainer = Color(0xFF5C2400);

  // ───── Tertiary ─────
  static const Color tertiary = Color(0xFF003853);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF005074);
  static const Color onTertiaryContainer = Color(0xFF68C4FF);

  // ───── Error ─────
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ───── Surface / Background ─────
  static const Color surface = Color(0xFFF8F9FF);
  static const Color surfaceDim = Color(0xFFCBDBF5);
  static const Color surfaceBright = Color(0xFFF8F9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFEFF4FF);
  static const Color surfaceContainer = Color(0xFFE5EEFF);
  static const Color surfaceContainerHigh = Color(0xFFDCE9FF);
  static const Color surfaceContainerHighest = Color(0xFFD3E4FE);
  static const Color onSurface = Color(0xFF0B1C30);
  static const Color onSurfaceVariant = Color(0xFF444653);
  static const Color inverseSurface = Color(0xFF213145);
  static const Color inverseOnSurface = Color(0xFFEAF1FF);
  static const Color surfaceTint = Color(0xFF3755C3);
  static const Color surfaceVariant = Color(0xFFD3E4FE);

  // ───── Outline ─────
  static const Color outline = Color(0xFF757684);
  static const Color outlineVariant = Color(0xFFC4C5D5);

  // ───── Background ─────
  static const Color background = Color(0xFFF8F9FF);
  static const Color onBackground = Color(0xFF0B1C30);

  // ───── Cores de Status ─────
  static const Color statusPendente = Color(0xFFFD761A);
  static const Color statusEmAndamento = Color(0xFF005074);
  static const Color statusConcluida = Color(0xFF16A34A);
  static const Color statusRecusada = Color(0xFFBA1A1A);
}
