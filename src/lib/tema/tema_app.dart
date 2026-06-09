// ============================================
// tema_app.dart — ThemeData do iNeed
// ============================================
// Tema Material 3 completo usando as cores e tipografia do Design System.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cores.dart';

class TemaApp {
  TemaApp._();

  static ThemeData get claro {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // ───── Color Scheme ─────
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: CoresApp.primary,
        onPrimary: CoresApp.onPrimary,
        primaryContainer: CoresApp.primaryContainer,
        onPrimaryContainer: CoresApp.onPrimaryContainer,
        secondary: CoresApp.secondary,
        onSecondary: CoresApp.onSecondary,
        secondaryContainer: CoresApp.secondaryContainer,
        onSecondaryContainer: CoresApp.onSecondaryContainer,
        tertiary: CoresApp.tertiary,
        onTertiary: CoresApp.onTertiary,
        tertiaryContainer: CoresApp.tertiaryContainer,
        onTertiaryContainer: CoresApp.onTertiaryContainer,
        error: CoresApp.error,
        onError: CoresApp.onError,
        errorContainer: CoresApp.errorContainer,
        onErrorContainer: CoresApp.onErrorContainer,
        surface: CoresApp.surface,
        onSurface: CoresApp.onSurface,
        onSurfaceVariant: CoresApp.onSurfaceVariant,
        inverseSurface: CoresApp.inverseSurface,
        onInverseSurface: CoresApp.inverseOnSurface,
        inversePrimary: CoresApp.inversePrimary,
        outline: CoresApp.outline,
        outlineVariant: CoresApp.outlineVariant,
        surfaceContainerHighest: CoresApp.surfaceContainerHighest,
        surfaceTint: CoresApp.surfaceTint,
      ),

      // ───── Scaffold ─────
      scaffoldBackgroundColor: CoresApp.surface,

      // ───── AppBar ─────
      appBarTheme: AppBarTheme(
        backgroundColor: CoresApp.surfaceContainerLowest,
        foregroundColor: CoresApp.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: CoresApp.onSurface,
        ),
      ),

      // ───── Text Theme ─────
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineLarge: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: CoresApp.onSurface,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: CoresApp.onSurface,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: CoresApp.onSurface,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: CoresApp.onSurface,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: CoresApp.onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: CoresApp.onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: CoresApp.onSurface,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: CoresApp.onSurfaceVariant,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: CoresApp.onSurface,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: CoresApp.onSurfaceVariant,
        ),
      ),

      // ───── Input Decoration ─────
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CoresApp.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CoresApp.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CoresApp.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CoresApp.error),
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: CoresApp.outline,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: CoresApp.onSurfaceVariant,
        ),
      ),

      // ───── Elevated Button ─────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CoresApp.primary,
          foregroundColor: CoresApp.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),

      // ───── Outlined Button ─────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CoresApp.primary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(color: CoresApp.outlineVariant),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ───── Card ─────
      cardTheme: CardThemeData(
        color: CoresApp.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: CoresApp.outlineVariant, width: 0.5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // ───── Chip ─────
      chipTheme: ChipThemeData(
        backgroundColor: CoresApp.surfaceContainerLow,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: CoresApp.onSurface,
        ),
        shape: const StadiumBorder(),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // ───── Bottom Navigation Bar ─────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: CoresApp.surfaceContainerLowest,
        selectedItemColor: CoresApp.primary,
        unselectedItemColor: CoresApp.outline,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // ───── Tab Bar ─────
      tabBarTheme: TabBarThemeData(
        labelColor: CoresApp.primary,
        unselectedLabelColor: CoresApp.outline,
        indicatorColor: CoresApp.primary,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      // ───── Divider ─────
      dividerTheme: const DividerThemeData(
        color: CoresApp.outlineVariant,
        thickness: 0.5,
        space: 0,
      ),
    );
  }
}
