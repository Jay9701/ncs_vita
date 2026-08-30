import 'package:flutter/material.dart';
import 'package:ncs_vita/theme/colors.dart';
import 'package:ncs_vita/theme/font.dart';

class AppTheme {
  static ThemeData light(double fontScale) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: LightMode.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: LightMode.primary,
          onPrimary: Colors.white,
          secondary: LightMode.secondary,
          onSecondary: LightMode.textPrimary,
          error: LightMode.error,
          onError: Colors.white,
          surface: LightMode.surface,
          onSurface: LightMode.textPrimary,
          shadow: LightMode.disabled,
          outline: LightMode.disabled,
        );

    final base = ThemeData.light();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: LightMode.background,

      cardTheme: const CardThemeData(
        color: LightMode.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),

      dividerColor: LightMode.divider,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return scheme.primary.withValues(alpha: 0.4);
            }
            if (states.contains(WidgetState.pressed)) {
              return Color.alphaBlend(const Color(0x14000000), scheme.primary);
            }
            return scheme.primary;
          }),
          foregroundColor: WidgetStateProperty.all(Colors.white),
        ),
      ),

      textTheme: buildTextTheme(base.textTheme, fontScale, isDark: false),
      extensions: [AppFont.create(fontScale, false)],
    );
  }

  static ThemeData dark(double fontScale) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: DarkMode.primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: DarkMode.primary,
          onPrimary: DarkMode.background,
          secondary: DarkMode.secondary,
          onSecondary: DarkMode.background,
          error: DarkMode.error,
          onError: Colors.white,
          surface: DarkMode.surface,
          onSurface: DarkMode.textPrimary,
          shadow: Colors.black,
          outline: DarkMode.disabled,
        );

    final base = ThemeData.dark();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: DarkMode.background,

      cardTheme: const CardThemeData(
        color: DarkMode.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),

      dividerColor: DarkMode.divider,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return scheme.primary.withValues(alpha: 0.4);
            }
            if (states.contains(WidgetState.pressed)) {
              return Color.alphaBlend(const Color(0x1A000000), scheme.primary);
            }
            return scheme.primary;
          }),
          foregroundColor: WidgetStateProperty.all(DarkMode.background),
        ),
      ),

      textTheme: buildTextTheme(base.textTheme, fontScale, isDark: true),
      extensions: [AppFont.create(fontScale, true)],
    );
  }
}

TextTheme buildTextTheme(TextTheme base, double scale, {required bool isDark}) {
  final primaryText = isDark ? DarkMode.textPrimary : LightMode.textPrimary;
  final secondaryText = isDark
      ? DarkMode.textSecondary
      : LightMode.textSecondary;
  final primaryPoint = isDark ? DarkMode.primary : LightMode.primary;
  final accentPoint = isDark ? DarkMode.secondary : LightMode.secondary;
  final errorPoint = isDark ? DarkMode.error : LightMode.error;

  return base.copyWith(
    // [Display] 점수나 큰 숫자 (포인트 컬러 적용)
    displayLarge: TextStyle(
      fontSize: 57 * scale,
      fontWeight: FontWeight.bold,
      color: primaryPoint,
      letterSpacing: 0,
    ),

    headlineMedium: TextStyle(
      fontSize: 28 * scale,
      fontWeight: FontWeight.bold,
      color: primaryText,
    ),
    headlineSmall: TextStyle(
      fontSize: 24 * scale,
      fontWeight: FontWeight.bold,
      color: primaryText,
    ),

    titleLarge: TextStyle(
      fontSize: 22 * scale,
      fontWeight: FontWeight.w600,
      color: primaryText,
    ),
    titleMedium: TextStyle(
      fontSize: 16 * scale,
      fontWeight: FontWeight.w600,
      color: accentPoint,
    ),

    bodyLarge: TextStyle(fontSize: 18 * scale, color: primaryText),
    bodyMedium: TextStyle(fontSize: 16 * scale, color: primaryText),
    bodySmall: TextStyle(fontSize: 14 * scale, color: secondaryText),

    labelLarge: TextStyle(
      fontSize: 14 * scale,
      fontWeight: FontWeight.bold,
      color: primaryText,
    ),
    labelSmall: TextStyle(
      fontSize: 11 * scale,
      fontWeight: FontWeight.w500,
      color: errorPoint,
    ),
  );
}
