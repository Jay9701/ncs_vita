// === lib/features/game/services/game_service.dart ===

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:ncs_vita/features/game/models/table_schema.dart';
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
    for (var attempt = 0; attempt < 5000; attempt++) {
      final diff = minDiff + _rnd.nextDouble() * (maxDiff - minDiff);
      final sign = _rnd.nextBool() ? 1 : -1;
      final a = _rnd.nextInt(maxVal - 1) + 2; // [2, maxVal]
      final b = _rnd.nextInt(maxVal - 1) + 2; // [2, maxVal]
      final d = _rnd.nextInt(maxVal - 1) + 2; // [2, maxVal]
      final c = (sign == 1)
          ? (a * d * (1 + diff * sign) / b).ceil()
          : (a * d * (1 + diff * sign) / b).floor();

      if (b == d) continue; // 두 분모가 같은 경우 다시추출 (비교가 너무 쉬움)
      if (c < 1 || c > maxVal) continue;
      if (a == b || c == d) continue; // 분자와 분모가 같은 경우 다시추출

      final f1 = Fraction(a, b);
      final f2 = Fraction(c, d);

      final fractionPair = FractionPair(f1, f2);
      final actualDiff = fractionPair.relativeDifference;
      if (actualDiff < minDiff || actualDiff > maxDiff) continue;

      if (kDebugMode) {
        if (sign == 1) {
          debugPrint('<');
        } else {
          debugPrint('>');
        }
      }

      return fractionPair;
    }

    throw StateError('Unable to generate a valid fraction comparison.');
  }

  // === 곱셈 문제 생성 ===
  static MultiplicationPair generateMultiplicationPair({
    required double minDiff,
    required double maxDiff,
    required int minBase,
    required int maxBase,
    required bool allowDecimal,
  }) {
    for (var attempt = 0; attempt < 5000; attempt++) {
      final diff = minDiff + _rnd.nextDouble() * (maxDiff - minDiff);
      final sign = _rnd.nextBool() ? 1 : -1;
      final firstBase = _rnd.nextInt(maxBase - minBase + 1) + minBase;
      final firstRateTenths = allowDecimal
          ? _rnd.nextInt(901) + 100
          : (_rnd.nextInt(91) + 10) * 10;
      final secondRateTenths = allowDecimal
          ? _rnd.nextInt(901) + 100
          : (_rnd.nextInt(91) + 10) * 10;
      final firstProduct = firstBase * firstRateTenths;
      final targetProduct = firstProduct * (1 + diff * sign);
      final secondBase = (targetProduct / secondRateTenths).round();

      if (secondBase < minBase || secondBase > maxBase) continue;
      if (firstBase == secondBase || firstRateTenths == secondRateTenths) {
        continue;
      }

      final secondProduct = secondBase * secondRateTenths;
      final actualDiff = (firstProduct - secondProduct).abs() / firstProduct;
      if (actualDiff < minDiff || actualDiff > maxDiff) continue;

      return MultiplicationPair(
        firstBase: firstBase,
        firstRateTenths: firstRateTenths,
        secondBase: secondBase,
        secondRateTenths: secondRateTenths,
      );
    }

    throw StateError('Unable to generate a valid multiplication comparison.');
  }

  // === 덧셈 문제 생성 ===
  static AdditionSet generateAddProblem({
    required int len,
    required int maxVal,
    required double sumBlankProbability,
  }) {
    final nums = List.generate(len, (_) => _rnd.nextInt(maxVal) + 1);
    final sum = nums.reduce((a, b) => a + b);
    final hIdx = _rnd.nextDouble() < sumBlankProbability
        ? len
        : _rnd.nextInt(len);

    return AdditionSet(nums, sum, hIdx);
  }

  static TableProblem generateTableProblem() {
    final schemaIds = masterDatasets.keys.toList();
    final schemaId = schemaIds[_rnd.nextInt(schemaIds.length)];
    final table = TableService.generate(schemaId, colCount: 3);
    final row = _rnd.nextInt(table.rows.length);
    final column = _rnd.nextInt(table.cols.length);
    final hole = TableHole(
      row: row,
      col: column,
      originalValue: table.data[row][column],
    );

    return TableProblem(table: table, holes: [hole]);
  }
}
