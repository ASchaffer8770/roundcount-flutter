import 'package:flutter/material.dart';

class RoundCountTheme {
  // ── Light palette ──────────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF6F8F7);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightElevatedSurface = Color(0xFFEFF3F1);
  static const Color lightTextPrimary = Color(0xFF111816);
  static const Color lightTextSecondary = Color(0xFF5D6B66);
  static const Color lightBorder = Color(0xFFD9E1DD);

  // ── Dark palette (static aliases kept for backward compatibility) ──────────
  static const Color background = Color(0xFF0E1116);
  static const Color surface = Color(0xFF171B22);
  static const Color elevatedSurface = Color(0xFF202631);
  static const Color textPrimary = Color(0xFFF4F6F8);
  static const Color textSecondary = Color(0xFFAAB2BD);
  static const Color darkBorder = Color(0xFF2A303A);

  // ── Semantic / brand colors (theme-invariant) ──────────────────────────────
  // RoundCount brand green
  static const Color accent = Color(0xFF2DBE78);
  static const Color success = Color(0xFF3BB273);
  static const Color warning = Color(0xFFE6A23C);
  static const Color danger = Color(0xFFE5484D);

  // ── Context-aware helpers ──────────────────────────────────────────────────
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color backgroundFor(BuildContext context) =>
      isDark(context) ? background : lightBackground;

  static Color surfaceFor(BuildContext context) =>
      isDark(context) ? surface : lightSurface;

  static Color elevatedSurfaceFor(BuildContext context) =>
      isDark(context) ? elevatedSurface : lightElevatedSurface;

  static Color textPrimaryFor(BuildContext context) =>
      isDark(context) ? textPrimary : lightTextPrimary;

  static Color textSecondaryFor(BuildContext context) =>
      isDark(context) ? textSecondary : lightTextSecondary;

  static Color borderFor(BuildContext context) =>
      isDark(context) ? darkBorder : lightBorder;

  // ── Light theme ────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: accent,
        secondary: accent,
        surface: lightSurface,
        error: danger,
        onPrimary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: lightTextPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: lightBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        labelStyle: const TextStyle(color: lightTextSecondary),
        hintStyle:
            const TextStyle(color: lightTextSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lightSurface,
        indicatorColor: accent.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: lightTextPrimary,
              fontWeight: FontWeight.w700,
            );
          }
          return const TextStyle(
            color: lightTextSecondary,
            fontWeight: FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: accent);
          }
          return const IconThemeData(color: lightTextSecondary);
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
      ),
    );
  }

  // ── Dark theme ─────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accent,
        surface: surface,
        error: danger,
        onPrimary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: darkBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: accent.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w700,
            );
          }
          return const TextStyle(
            color: textSecondary,
            fontWeight: FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: accent);
          }
          return const IconThemeData(color: textSecondary);
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
      ),
    );
  }
}
