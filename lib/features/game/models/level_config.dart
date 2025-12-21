class DiffRange {
  final double minDiff;
  final double maxDiff;
  final int maxDen;

  const DiffRange(this.minDiff, this.maxDiff, this.maxDen);
}

DiffRange getLevelConfig(int level) {
  return levelDiffTable[level] ?? const DiffRange(0.3, 0.5, 999);
}

const Map<int, DiffRange> levelDiffTable = {
  1: DiffRange(0.9, 1.0, 99),
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
