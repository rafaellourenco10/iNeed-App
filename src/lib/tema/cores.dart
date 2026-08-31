// ============================================
// cores.dart — Paleta de cores do iNeed (claro + escuro)
// ============================================
// Baseado no Design System (DESIGN.md) das telas.
//
// Cada token é um getter que responde ao brilho atual (definido por
// TemaServico), então toda tela que já usa `CoresApp.primary` etc.
// passa a reagir ao tema automaticamente, sem precisar editar cada
// tela uma por uma.

import 'package:flutter/material.dart';

class CoresApp {
  CoresApp._();

  static Brightness _brilho = Brightness.light;

  /// Definido pelo TemaServico quando o usuário troca de tema.
  static void definirBrilho(Brightness brilho) {
    _brilho = brilho;
  }

  static Brightness get brilho => _brilho;
  static bool get _escuro => _brilho == Brightness.dark;

  // ───── Primary (Azul Confiável) ─────
  static Color get primary =>
      _escuro ? const Color(0xFF8AA6FF) : const Color(0xFF00288E);
  static Color get onPrimary =>
      _escuro ? const Color(0xFF00194F) : const Color(0xFFFFFFFF);
  static Color get primaryContainer =>
      _escuro ? const Color(0xFF142759) : const Color(0xFF1E40AF);
  static Color get onPrimaryContainer =>
      _escuro ? const Color(0xFFD6E0FF) : const Color(0xFFA8B8FF);
  static Color get inversePrimary =>
      _escuro ? const Color(0xFF00288E) : const Color(0xFFB8C4FF);
  static const Color primaryFixed = Color(0xFFDDE1FF);
  static const Color primaryFixedDim = Color(0xFFB8C4FF);

  // ───── Secondary (Laranja Vibrante — CTA) ─────
  static Color get secondary =>
      _escuro ? const Color(0xFFFFB68C) : const Color(0xFF9D4300);
  static Color get onSecondary =>
      _escuro ? const Color(0xFF5C2400) : const Color(0xFFFFFFFF);
  static Color get secondaryContainer =>
      _escuro ? const Color(0xFF7A3300) : const Color(0xFFFD761A);
  static Color get onSecondaryContainer =>
      _escuro ? const Color(0xFFFFDBC4) : const Color(0xFF5C2400);

  // ───── Tertiary ─────
  static Color get tertiary =>
      _escuro ? const Color(0xFF7FD4FF) : const Color(0xFF003853);
  static Color get onTertiary =>
      _escuro ? const Color(0xFF00344C) : const Color(0xFFFFFFFF);
  static Color get tertiaryContainer =>
      _escuro ? const Color(0xFF004D6E) : const Color(0xFF005074);
  static Color get onTertiaryContainer =>
      _escuro ? const Color(0xFFBEE9FF) : const Color(0xFF68C4FF);

  // ───── Error ─────
  static Color get error =>
      _escuro ? const Color(0xFFFFB4AB) : const Color(0xFFBA1A1A);
  static Color get onError =>
      _escuro ? const Color(0xFF690005) : const Color(0xFFFFFFFF);
  static Color get errorContainer =>
      _escuro ? const Color(0xFF93000A) : const Color(0xFFFFDAD6);
  static Color get onErrorContainer =>
      _escuro ? const Color(0xFFFFDAD6) : const Color(0xFF93000A);

  // ───── Surface / Background ─────
  static Color get surface =>
      _escuro ? const Color(0xFF0E1420) : const Color(0xFFF8F9FF);
  static Color get surfaceDim =>
      _escuro ? const Color(0xFF0E1420) : const Color(0xFFCBDBF5);
  static Color get surfaceBright =>
      _escuro ? const Color(0xFF343B4C) : const Color(0xFFF8F9FF);
  static Color get surfaceContainerLowest =>
      _escuro ? const Color(0xFF090D16) : const Color(0xFFFFFFFF);
  static Color get surfaceContainerLow =>
      _escuro ? const Color(0xFF171D2C) : const Color(0xFFEFF4FF);
  static Color get surfaceContainer =>
      _escuro ? const Color(0xFF1B2233) : const Color(0xFFE5EEFF);
  static Color get surfaceContainerHigh =>
      _escuro ? const Color(0xFF262D40) : const Color(0xFFDCE9FF);
  static Color get surfaceContainerHighest =>
      _escuro ? const Color(0xFF313849) : const Color(0xFFD3E4FE);
  static Color get onSurface =>
      _escuro ? const Color(0xFFDCE2F9) : const Color(0xFF0B1C30);
  static Color get onSurfaceVariant =>
      _escuro ? const Color(0xFFB8BDD4) : const Color(0xFF444653);
  static Color get inverseSurface =>
      _escuro ? const Color(0xFFDCE2F9) : const Color(0xFF213145);
  static Color get inverseOnSurface =>
      _escuro ? const Color(0xFF0B1C30) : const Color(0xFFEAF1FF);
  static Color get surfaceTint =>
      _escuro ? const Color(0xFFAEC0FF) : const Color(0xFF3755C3);
  static Color get surfaceVariant =>
      _escuro ? const Color(0xFF454C5F) : const Color(0xFFD3E4FE);

  // ───── Outline ─────
  static Color get outline =>
      _escuro ? const Color(0xFF8E93A8) : const Color(0xFF757684);
  static Color get outlineVariant =>
      _escuro ? const Color(0xFF454C5F) : const Color(0xFFC4C5D5);

  // ───── Background ─────
  static Color get background =>
      _escuro ? const Color(0xFF0E1420) : const Color(0xFFF8F9FF);
  static Color get onBackground =>
      _escuro ? const Color(0xFFDCE2F9) : const Color(0xFF0B1C30);

  // ───── Cores de Status ─────
  static Color get statusPendente =>
      _escuro ? const Color(0xFFFFB68C) : const Color(0xFFFD761A);
  static Color get statusEmAndamento =>
      _escuro ? const Color(0xFF7FD4FF) : const Color(0xFF005074);
  static Color get statusConcluida =>
      _escuro ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
  static Color get statusRecusada =>
      _escuro ? const Color(0xFFFFB4AB) : const Color(0xFFBA1A1A);
}
