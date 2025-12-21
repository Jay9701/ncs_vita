import 'package:flutter/material.dart';

class AppFont extends ThemeExtension<AppFont> {
  final TextStyle fraction;
  final TextStyle title1;
  // 추가하고 싶은 이름들...

  AppFont({required this.fraction, required this.title1});

  factory AppFont.create(double scale, bool isDark) {
    final baseColor = isDark
        ? const Color(0xFFE5E7EB)
        : const Color(0xFF1F2937);

    return AppFont(
      fraction: TextStyle(
        fontSize: 32 * scale, // 요청하신 32px 기준
        fontWeight: FontWeight.bold,
        color: baseColor,
        fontFamily: 'Pretendard', // 사용하는 폰트가 있다면 지정
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
      fraction: TextStyle.lerp(fraction, other.fraction, t)!,
      title1: TextStyle.lerp(title1, other.title1, t)!,
    );
  }
}

// 편리한 사용을 위한 Extension
extension AppTextsTheme on BuildContext {
  AppFont get fonts => Theme.of(this).extension<AppFont>()!;
}
