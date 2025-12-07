class GameConfig {
  final int level;
  final int count;

  const GameConfig({this.level = 1, this.count = 10});

  GameConfig set({int? level, int? count}) {
    return GameConfig(level: level ?? this.level, count: count ?? this.count);
  }
}
