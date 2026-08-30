import 'package:flutter_test/flutter_test.dart';
import 'package:ncs_vita/features/game/models/level_config.dart';
import 'package:ncs_vita/features/game/services/game_service.dart';

void main() {
  group('addition problem generation', () {
    test('uses the configured term count and number range', () {
      for (final level in [1, 5, 10]) {
        final config = getCalculationConfig(level);

        for (var index = 0; index < 100; index++) {
          final problem = GameService.generateAddProblem(
            len: config.termCount,
            maxVal: config.maxValue,
            sumBlankProbability: config.sumBlankProbability,
          );

          expect(problem.nums, hasLength(config.termCount));
          expect(
            problem.nums.every(
              (value) => value >= 1 && value <= config.maxValue,
            ),
            isTrue,
          );
          expect(problem.sum, problem.nums.reduce((sum, value) => sum + value));
          expect(problem.hIdx, inInclusiveRange(0, config.termCount));
        }
      }
    });

    test('uses the configured sum-blank probability direction', () {
      final lowLevel = getCalculationConfig(1);
      final highLevel = getCalculationConfig(10);
      var lowLevelSumBlanks = 0;
      var highLevelSumBlanks = 0;

      for (var index = 0; index < 500; index++) {
        final lowProblem = GameService.generateAddProblem(
          len: lowLevel.termCount,
          maxVal: lowLevel.maxValue,
          sumBlankProbability: lowLevel.sumBlankProbability,
        );
        final highProblem = GameService.generateAddProblem(
          len: highLevel.termCount,
          maxVal: highLevel.maxValue,
          sumBlankProbability: highLevel.sumBlankProbability,
        );

        if (lowProblem.hIdx == lowLevel.termCount) lowLevelSumBlanks++;
        if (highProblem.hIdx == highLevel.termCount) highLevelSumBlanks++;
      }

      expect(lowLevelSumBlanks, greaterThan(highLevelSumBlanks));
    });
  });

  group('multiplication comparison generation', () {
    test('uses the configured number ranges and exact comparison values', () {
      for (final level in [1, 4, 7, 10]) {
        final config = getMultiplicationConfig(level);

        for (var index = 0; index < 100; index++) {
          final problem = GameService.generateMultiplicationPair(
            minDiff: config.minDiff,
            maxDiff: config.maxDiff,
            minBase: config.minBase,
            maxBase: config.maxBase,
            allowDecimal: config.allowDecimal,
          );
          final difference =
              (problem.firstProduct - problem.secondProduct).abs() /
              problem.firstProduct;

          expect(problem.firstRateTenths, inInclusiveRange(100, 1000));
          expect(problem.secondRateTenths, inInclusiveRange(100, 1000));
          expect(
            problem.firstBase,
            inInclusiveRange(config.minBase, config.maxBase),
          );
          expect(
            problem.secondBase,
            inInclusiveRange(config.minBase, config.maxBase),
          );
          if (!config.allowDecimal) {
            expect(problem.firstRateTenths % 10, 0);
            expect(problem.secondRateTenths % 10, 0);
          }
          expect(problem.firstProduct, isNot(problem.secondProduct));
          expect(difference, inInclusiveRange(config.minDiff, config.maxDiff));
        }
      }
    });
  });

  group('fraction comparison generation', () {
    test('uses the configured ranges and actual relative difference', () {
      for (final level in [1, 4, 7, 8, 10]) {
        final config = getFractionConfig(level);

        for (var index = 0; index < 100; index++) {
          final problem = GameService.generateFractionPair(
            minDiff: config.minDiff,
            maxDiff: config.maxDiff,
            maxVal: config.maxValue,
          );

          expect(problem.first.num, inInclusiveRange(1, config.maxValue));
          expect(problem.first.den, inInclusiveRange(1, config.maxValue));
          expect(problem.second.num, inInclusiveRange(1, config.maxValue));
          expect(problem.second.den, inInclusiveRange(1, config.maxValue));
          expect(problem.isFirstGreater, isNotNull);
          expect(
            problem.relativeDifference,
            inInclusiveRange(config.minDiff, config.maxDiff),
          );
        }
      }
    });
  });

  group('table problem generation', () {
    test('creates one answerable cell hole with consistent totals', () {
      for (var index = 0; index < 100; index++) {
        final problem = GameService.generateTableProblem();
        final table = problem.table;
        final hole = problem.holes.single;

        expect(table.rowSummaries, hasLength(table.rows.length));
        expect(table.columnSummaries, hasLength(table.cols.length));
        expect(hole.originalValue, table.data[hole.row][hole.col]);
        final visibleRowSum = table.data[hole.row]
            .asMap()
            .entries
            .where((entry) => entry.key != hole.col)
            .fold(0, (sum, entry) => sum + entry.value);
        if (table.rowSummaryLabel == '합') {
          expect(
            table.rowSummaries[hole.row] - visibleRowSum,
            hole.originalValue,
          );
        }
        expect(
          table.data.expand((row) => row).reduce((sum, value) => sum + value),
          table.grandSummary,
        );
      }
    });
  });
}
