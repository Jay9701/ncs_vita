class DiffRange {
  final double minDiff;
  final double maxDiff;
  final int maxVal;

  const DiffRange(this.minDiff, this.maxDiff, this.maxVal);
}

class CalculationConfig {
  final int termCount;
  final int maxValue;
  final double sumBlankProbability;

  const CalculationConfig({
    required this.termCount,
    required this.maxValue,
    required this.sumBlankProbability,
  });
}

class MultiplicationConfig {
  final int minBase;
  final int maxBase;
  final double minDiff;
  final double maxDiff;
  final bool allowDecimal;

  const MultiplicationConfig({
    required this.minBase,
    required this.maxBase,
    required this.minDiff,
    required this.maxDiff,
    required this.allowDecimal,
  });
}

class FractionConfig {
  final int maxValue;
  final double minDiff;
  final double maxDiff;

  const FractionConfig({
    required this.maxValue,
    required this.minDiff,
    required this.maxDiff,
  });
}

DiffRange getLevelConfig(int level) {
  return levelDiffTable[level] ?? const DiffRange(0.3, 0.5, 999);
}

const Map<int, DiffRange> levelDiffTable = {
  1: DiffRange(0.9, 0.99, 99),
  2: DiffRange(0.8, 0.9, 99),
  3: DiffRange(0.7, 0.8, 999),
  4: DiffRange(0.6, 0.7, 999),
  5: DiffRange(0.5, 0.6, 999),
  6: DiffRange(0.4, 0.5, 999),
  7: DiffRange(0.3, 0.4, 999),
  8: DiffRange(0.2, 0.3, 999),
  9: DiffRange(0.1, 0.2, 999),
  10: DiffRange(0.05, 0.1, 999),
  11: DiffRange(0.01, 0.05, 999),
  // ...
};

FractionConfig getFractionConfig(int level) {
  return fractionLevelTable[level] ?? fractionLevelTable[10]!;
}

const Map<int, FractionConfig> fractionLevelTable = {
  1: FractionConfig(maxValue: 9, minDiff: 0.70, maxDiff: 0.90),
  2: FractionConfig(maxValue: 20, minDiff: 0.55, maxDiff: 0.75),
  3: FractionConfig(maxValue: 99, minDiff: 0.40, maxDiff: 0.60),
  4: FractionConfig(maxValue: 99, minDiff: 0.30, maxDiff: 0.50),
  5: FractionConfig(maxValue: 199, minDiff: 0.20, maxDiff: 0.35),
  6: FractionConfig(maxValue: 399, minDiff: 0.15, maxDiff: 0.25),
  7: FractionConfig(maxValue: 999, minDiff: 0.12, maxDiff: 0.20),
  8: FractionConfig(maxValue: 999, minDiff: 0.08, maxDiff: 0.15),
  9: FractionConfig(maxValue: 999, minDiff: 0.04, maxDiff: 0.08),
  10: FractionConfig(maxValue: 999, minDiff: 0.02, maxDiff: 0.05),
};

MultiplicationConfig getMultiplicationConfig(int level) {
  return multiplicationLevelTable[level] ?? multiplicationLevelTable[10]!;
}

const Map<int, MultiplicationConfig> multiplicationLevelTable = {
  1: MultiplicationConfig(
    minBase: 11,
    maxBase: 99,
    minDiff: 0.50,
    maxDiff: 0.80,
    allowDecimal: false,
  ),
  2: MultiplicationConfig(
    minBase: 11,
    maxBase: 99,
    minDiff: 0.35,
    maxDiff: 0.60,
    allowDecimal: false,
  ),
  3: MultiplicationConfig(
    minBase: 11,
    maxBase: 99,
    minDiff: 0.25,
    maxDiff: 0.45,
    allowDecimal: false,
  ),
  4: MultiplicationConfig(
    minBase: 100,
    maxBase: 999,
    minDiff: 0.20,
    maxDiff: 0.35,
    allowDecimal: true,
  ),
  5: MultiplicationConfig(
    minBase: 100,
    maxBase: 999,
    minDiff: 0.15,
    maxDiff: 0.30,
    allowDecimal: true,
  ),
  6: MultiplicationConfig(
    minBase: 100,
    maxBase: 999,
    minDiff: 0.10,
    maxDiff: 0.25,
    allowDecimal: true,
  ),
  7: MultiplicationConfig(
    minBase: 1000,
    maxBase: 9999,
    minDiff: 0.15,
    maxDiff: 0.25,
    allowDecimal: true,
  ),
  8: MultiplicationConfig(
    minBase: 1000,
    maxBase: 9999,
    minDiff: 0.10,
    maxDiff: 0.20,
    allowDecimal: true,
  ),
  9: MultiplicationConfig(
    minBase: 1000,
    maxBase: 9999,
    minDiff: 0.04,
    maxDiff: 0.08,
    allowDecimal: true,
  ),
  10: MultiplicationConfig(
    minBase: 1000,
    maxBase: 9999,
    minDiff: 0.02,
    maxDiff: 0.05,
    allowDecimal: true,
  ),
};

CalculationConfig getCalculationConfig(int level) {
  return calculationLevelTable[level] ?? calculationLevelTable[10]!;
}

const Map<int, CalculationConfig> calculationLevelTable = {
  1: CalculationConfig(termCount: 2, maxValue: 9, sumBlankProbability: 0.6),
  2: CalculationConfig(termCount: 2, maxValue: 50, sumBlankProbability: 0.6),
  3: CalculationConfig(termCount: 2, maxValue: 99, sumBlankProbability: 0.6),
  4: CalculationConfig(termCount: 3, maxValue: 9, sumBlankProbability: 0.4),
  5: CalculationConfig(termCount: 3, maxValue: 99, sumBlankProbability: 0.4),
  6: CalculationConfig(termCount: 3, maxValue: 99, sumBlankProbability: 0.4),
  7: CalculationConfig(termCount: 4, maxValue: 99, sumBlankProbability: 0.2),
  8: CalculationConfig(termCount: 4, maxValue: 299, sumBlankProbability: 0.2),
  9: CalculationConfig(termCount: 4, maxValue: 999, sumBlankProbability: 0.1),
  10: CalculationConfig(termCount: 5, maxValue: 99, sumBlankProbability: 0.1),
};
