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

  bool get isFirstGreater => first.num * second.den > second.num * first.den;

  double get relativeDifference {
    final firstScaled = first.num * second.den;
    final secondScaled = second.num * first.den;
    return (firstScaled - secondScaled).abs() / firstScaled;
  }
}

class MultiplicationPair {
  final int firstBase;
  final int firstRateTenths;
  final int secondBase;
  final int secondRateTenths;

  const MultiplicationPair({
    required this.firstBase,
    required this.firstRateTenths,
    required this.secondBase,
    required this.secondRateTenths,
  });

  int get firstProduct => firstBase * firstRateTenths;
  int get secondProduct => secondBase * secondRateTenths;

  String get firstRateLabel => _formatRate(firstRateTenths);
  String get secondRateLabel => _formatRate(secondRateTenths);

  static String _formatRate(int tenths) {
    final whole = tenths ~/ 10;
    final decimal = tenths % 10;
    return decimal == 0 ? '$whole' : '$whole.$decimal';
  }
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
