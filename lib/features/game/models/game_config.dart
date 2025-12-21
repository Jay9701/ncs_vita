class GameConfig {
  final int level;
  final int count;
  final int timer;

  const GameConfig({this.level = 1, this.count = 10, this.timer = 30});

  GameConfig copyWith({int? level, int? count, int? timer}) {
    return GameConfig(
      level: level ?? this.level,
      count: count ?? this.count,
      timer: timer ?? this.timer,
    );
  }
}
