// ============================================
// tipografia.dart — Estilos de texto do iNeed
// ============================================
// Baseado no Design System: fonte Inter com hierarquia definida.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TipografiaApp {
  TipografiaApp._();

  static TextStyle headlineXl = GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 44 / 36,
    letterSpacing: -0.72,
  );

  static TextStyle headlineLg = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 36 / 28,
    letterSpacing: -0.28,
  );

  static TextStyle headlineLgMobile = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
  );

  static TextStyle headlineMd = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
  );

  static TextStyle bodyLg = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
  );

  static TextStyle bodyMd = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static TextStyle bodySm = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );

  static TextStyle labelMd = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 16 / 14,
  );

  static TextStyle labelSm = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.6,
  );
}
