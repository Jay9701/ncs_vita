import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:ncs_vita/features/game/models/table_data.dart';

class Fraction {
  final int num;
  final int den;

  Fraction._internal(this.num, this.den);

  factory Fraction(int n, int d) {
    final g = _gcd(n.abs(), d.abs());
    return Fraction._internal(n ~/ g, d ~/ g);
  }

  static int _gcd(int a, int b) {
    while (b != 0) {
      final t = a % b;
      a = b;
      b = t;
    }
    return a;
  }

  double toDouble() => num / den;
}

class FractionPair {
  final Fraction first;
  final Fraction second;
  FractionPair(this.first, this.second);

  double diff() =>
      (first.toDouble() - second.toDouble()).abs() / first.toDouble();
}

class MultiplicationPair {
  final int a, b, c, d;
  MultiplicationPair(this.a, this.b, this.c, this.d);

  int get firstProduct => a * b;
  int get secondProduct => c * d;
}

class AdditionSet {
  final List<int> nums;
  final int sum;
  final int hIdx;

  AdditionSet(this.nums, this.sum, this.hIdx);
}

class TableHole {
  final int row;
  final int col;
  final int originalValue; // 정답
  int? userInput; // 사용자 입력값

  TableHole({
    required this.row,
    required this.col,
    required this.originalValue,
  });

  bool get isCorrect => originalValue == userInput;
}

class TableProblem {
  final GeneratedTable table; // 원본 표 데이터
  final List<TableHole> holes; // 가려진 칸들의 정보

  TableProblem({required this.table, required this.holes});

  // 모든 구멍이 다 채워졌고 정답인지 확인
  bool get isAllCorrect => holes.every((h) => h.isCorrect);
}
