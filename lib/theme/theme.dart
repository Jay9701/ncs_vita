import 'package:flutter/material.dart';
import 'package:ncs_vita/theme/font.dart';

class AppTheme {
  static const _lightBg = Color(0xFFF6F8FB);
  static const _darkBg = Color(0xFF201F1E);

  static ThemeData light(double fontScale) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF60A5FA),
          brightness: Brightness.light,
        ).copyWith(
          primary: const Color(0xFF3B82F6),
          secondary: const Color(0xFFFACC15),
          error: const Color(0xFFF87171),
          surface: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF1F2937),
          shadow: const Color(0xFFCBE0F1),
          outline: const Color(0xFFA2ABC9),
        );

    final base = ThemeData.light();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: _lightBg,

      cardTheme: const CardThemeData(
        color: Color(0xFFFFFFFF),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),

      dividerColor: const Color(0x0F000000),

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
          foregroundColor: WidgetStateProperty.all(const Color(0xFF1F2937)),
        ),
      ),

      textTheme: buildTextTheme(base.textTheme, fontScale, dark: false),
      extensions: [AppFont.create(fontScale, false)],
    );
  }

  static ThemeData dark(double fontScale) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: const Color(0xFFEAB308),
          brightness: Brightness.dark,
        ).copyWith(
          primary: const Color(0xFFEAB308),
          secondary: const Color(0xFF3B82F6),
          error: const Color(0xFFEF4444),
          surface: const Color(0xFF302F2F),
          onSurface: const Color(0xFFE5E7EB),
          shadow: const Color(0xFF000000),
          outline: const Color(0xFF1F2937),
        );

    final base = ThemeData.dark();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: _darkBg,

      cardTheme: const CardThemeData(
        color: Color(0xFF171A21),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),

      dividerColor: const Color(0x1AFFFFFF),

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
          foregroundColor: WidgetStateProperty.all(const Color(0xFF111827)),
        ),
      ),

      // ⭐ 여기
      textTheme: buildTextTheme(base.textTheme, fontScale, dark: true),
      extensions: [AppFont.create(fontScale, true)],
    );
  }
}

TextTheme buildTextTheme(TextTheme base, double scale, {required bool dark}) {
  // 1. 기본 색상 정의
  final primaryText = dark ? const Color(0xFFE5E7EB) : const Color(0xFF1F2937);
  final secondaryText = dark
      ? const Color(0xFF9CA3AF)
      : const Color(0xFF6B7280);

  // 2. 포인트 색상 (앞서 설정하신 ColorScheme과 동기화)
  final primaryPoint = const Color(0xFF60A5FA); // Blue (Light Primary)
  final accentPoint = const Color(0xFFFACC15); // Yellow (Secondary)
  final errorPoint = const Color(0xFFF87171); // Red (Error)

  return base.copyWith(
    // [Display] 점수나 큰 숫자 (포인트 컬러 적용)
    displayLarge: TextStyle(
      fontSize: 57 * scale,
      fontWeight: FontWeight.bold,
      color: primaryPoint, // 메인 브랜드 컬러로 강조
      letterSpacing: -0.25,
    ),

    // [Headline] 섹션 제목
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

    // [Title] 카드 제목이나 강조 텍스트 (Secondary 컬러 활용)
    titleLarge: TextStyle(
      fontSize: 22 * scale,
      fontWeight: FontWeight.w600,
      color: primaryText,
    ),
    titleMedium: TextStyle(
      fontSize: 16 * scale,
      fontWeight: FontWeight.w600,
      color: accentPoint, // 노란색 계열로 시선 집중 (예: 'Level 1')
    ),

    // [Body] 일반 본문 및 설명
    bodyLarge: TextStyle(fontSize: 18 * scale, color: primaryText),
    bodyMedium: TextStyle(fontSize: 16 * scale, color: primaryText),
    bodySmall: TextStyle(
      fontSize: 14 * scale,
      color: secondaryText, // 연한 회색으로 부연 설명
    ),

    // [Label] 버튼 및 에러 메시지
    labelLarge: TextStyle(
      fontSize: 14 * scale,
      fontWeight: FontWeight.bold,
      color: primaryText,
    ),
    labelSmall: TextStyle(
      fontSize: 11 * scale,
      fontWeight: FontWeight.w500,
      color: errorPoint, // 작은 경고나 에러 문구용
    ),
  );
}
