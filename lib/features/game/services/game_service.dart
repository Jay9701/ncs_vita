// === lib/features/game/services/game_service.dart ===

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:ncs_vita/features/game/models/table_data.dart';
import 'package:ncs_vita/features/game/services/table_service.dart';
import '../models/game_question.dart';

class GameService {
  static final Random _rnd = Random();

  // === 분수 문제 생성 ===
  static FractionPair generateFractionPair({
    required double minDiff, // 최소 변화율 ex) 0.1
    required double maxDiff, // 최대 변화율 ex) 1.0
    required int maxVal, // 최대 자릿수 ex) 999
  }) {
    while (true) {
      final diff = minDiff + _rnd.nextDouble() * (maxDiff - minDiff);
      final sign = _rnd.nextBool() ? 1 : -1;
      final a = _rnd.nextInt(maxVal - 1) + 2; // [2, maxVal]
      final b = _rnd.nextInt(maxVal - 1) + 2; // [2, maxVal]
      final d = _rnd.nextInt(maxVal - 1) + 2; // [2, maxVal]
      final c = (sign == 1)
          ? (a * d * (1 + diff * sign) / b).ceil()
          : (a * d * (1 + diff * sign) / b).floor();

      if (b == d) continue; // 두 분모가 같은 경우 다시추출 (비교가 너무 쉬움)
      if (c < 1 || c > 999) continue; // 비교대상 분자 범위가 기준을 넘어간경우 다시추출
      if (a == b || c == d) continue; // 분자와 분모가 같은 경우 다시추출

      final f1 = Fraction(a, b);
      final f2 = Fraction(c, d);

      FractionPair fractionPair = FractionPair(f1, f2);

      if (kDebugMode) {
        if (sign == 1) {
          debugPrint('<');
        } else {
          debugPrint('>');
        }
      }

      return fractionPair;
    }
  }

  // === 곱셈 문제 생성 ===
  static MultiplicationPair generateMultiplicationPair({
    required double minDiff,
    required double maxDiff,
    required int maxVal, // 한 숫자의 최대 크기 (예: 99)
  }) {
    while (true) {
      // 1. 설정된 범위 내에서 변화율과 부호 결정
      final diff = minDiff + _rnd.nextDouble() * (maxDiff - minDiff);
      final sign = _rnd.nextBool() ? 1 : -1;

      // 2. A, B, D를 먼저 랜덤으로 결정 (두 자릿수 연산 기준: 11~maxVal)
      final a = _rnd.nextInt(maxVal - 10) + 11;
      final b = _rnd.nextInt(maxVal - 10) + 11;
      final d = _rnd.nextInt(maxVal - 10) + 11;

      // 3. 목표값 계산 (A * B 대비 의도한 변화율 적용)
      final double targetVal = (a * b * (1 + diff * sign)) / d;

      // 4. [핵심] 방향성 올림/내림 적용 (부호 뒤집힘 완벽 차단)
      int c = (sign == 1) ? targetVal.ceil() : targetVal.floor();

      // 5. [안전장치] 정수값이 딱 떨어져서 같아지는 경우 보정
      if (a * b == c * d) {
        c += sign;
      }

      // 6. 필터링 (바른 자세: 결과값이 유효한 범위인지 확인)
      if (a == c || b == d) continue; // 숫자가 너무 중복되면 다시 추출
      if (c < 11 || c > maxVal) continue; // 결과값 C가 범위를 벗어나면 다시 추출

      return MultiplicationPair(a, b, c, d);
    }
  }

  // === 덧셈 문제 생성 ===
  static AdditionSet generateAddProblem({
    required int len,
    required int maxVal,
  }) {
    final nums = List.generate(len, (_) => _rnd.nextInt(maxVal));
    final sum = nums.reduce((a, b) => a + b);

    final hIdx = _rnd.nextInt(len + 1);

    return AdditionSet(nums, sum, hIdx);
  }

  static TableProblem generateTableProblem(int holeCount) {
    final random = Random();
    GeneratedTable table = TableService.generate('IP001', colCount: 3);
    List<TableHole> holes = [];

    // 중복되지 않게 구멍 뚫기
    Set<String> chosen = {};
    while (holes.length < holeCount) {
      int r = random.nextInt(table.rows.length);
      int c = random.nextInt(table.cols.length);
      String key = '$r-$c';

      if (!chosen.contains(key)) {
        chosen.add(key);
        holes.add(TableHole(row: r, col: c, originalValue: table.data[r][c]));
      }
    }

    return TableProblem(table: table, holes: holes);
  }
}
