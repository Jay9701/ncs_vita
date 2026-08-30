import 'package:flutter/material.dart';

class AppFont extends ThemeExtension<AppFont> {
  final double scale;
  final TextStyle fraction;
  final TextStyle title1;

  AppFont({required this.scale, required this.fraction, required this.title1});

  factory AppFont.create(double scale, bool isDark) {
    final baseColor = isDark
        ? const Color(0xFFE5E7EB)
        : const Color(0xFF1F2937);

    return AppFont(
      scale: scale,
      fraction: TextStyle(
        fontSize: 32 * scale,
        fontWeight: FontWeight.bold,
        color: baseColor,
        fontFamily: 'Pretendard',
      ),
      title1: TextStyle(
        fontSize: 18 * scale,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
    );
  }

  @override
  ThemeExtension<AppFont> copyWith() => this;

  @override
  ThemeExtension<AppFont> lerp(ThemeExtension<AppFont>? other, double t) {
    if (other is! AppFont) return this;
    return AppFont(
      scale: scale,
      fraction: TextStyle.lerp(fraction, other.fraction, t)!,
      title1: TextStyle.lerp(title1, other.title1, t)!,
    );
  }
}

extension AppTextsTheme on BuildContext {
  AppFont get fonts => Theme.of(this).extension<AppFont>()!;

  double get effectiveTextScale {
    final systemScale = MediaQuery.textScalerOf(this).scale(1.0);
    return fonts.scale * systemScale;
  }

  double scaleText(double size) => size * effectiveTextScale;
}
