import 'package:flutter/material.dart';

class LightMode {
  static const background = Color(0xFFFEFDF8);
  static const surface = Color(0xFFFFFFFF);

  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);

  static const primary = Color(0xFFFACC15);
  static const secondary = Color(0xFF60A5FA);

  static const success = Color(0xFF34D399);
  static const error = Color(0xFFF87171);
  static const disabled = Color(0xFFD1D5DB);

  static const divider = Color(0x0F000000); // 6% black
}

class DarkMode {
  static const background = Color(0xFF0F1115);
  static const surface = Color(0xFF171A21);

  static const textPrimary = Color(0xFFE5E7EB);
  static const textSecondary = Color(0xFF9CA3AF);

  static const primary = Color(0xFFEAB308); // 노랑은 다크에서 눈부심 줄이기
  static const secondary = Color(0xFF3B82F6);

  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const disabled = Color(0xFF374151);

  static const divider = Color(0x1AFFFFFF); // 10% white
}
