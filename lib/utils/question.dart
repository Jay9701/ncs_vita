import 'dart:math';

import 'package:flutter/foundation.dart';

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

FractionPair generateFractionPair({
  required double minDiff,
  required double maxDiff,
  int maxDen = 999,
  Random? random,
}) {
  final rnd = random ?? Random();

  while (true) {
    final diff = minDiff + rnd.nextDouble() * (maxDiff - minDiff);
    final sign = rnd.nextBool() ? 1 : -1;
    final a = rnd.nextInt(maxDen - 1) + 2; // [2, maxDen]
    final b = rnd.nextInt(maxDen - 1) + 2; // [2, maxDen]
    final d = rnd.nextInt(maxDen - 1) + 2; // [2, maxDen]
    final c = (a * d * (1 + diff * sign) / b).ceil();

    if (b == d) continue;
    if (c < 1 || c > 999) continue;

    final f1 = Fraction(a, b);
    final f2 = Fraction(c, d);

    if (kDebugMode) {
      if (sign == 1) {
        print("right");
      } else {
        print("left");
      }
      print(diff * sign);
    }

    return FractionPair(f1, f2);
  }
}
