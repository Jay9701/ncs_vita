enum GameType {
  calculation('덧셈/뺄셈'), // 분수 비교
  multiple('곱셈 비교'), // 곱셈 비교
  fraction('분수 비교'); // 분수 비교

  // 생성자와 필드 추가
  const GameType(this.label);
  final String label;

  GameType get prev {
    return GameType.values[(index - 1 + GameType.values.length) %
        GameType.values.length];
  }

  GameType get next {
    // 현재 타입의 인덱스 + 1을 전체 길이로 나눈 나머지값 사용
    final nextIndex = (index + 1) % GameType.values.length;
    return GameType.values[nextIndex];
  }
}

class GameConfig {
  final GameType type;
  final int level;
  final int count;
  final int timer;

  const GameConfig({
    this.type = GameType.fraction,
    this.level = 1,
    this.count = 10,
    this.timer = 30,
  });

  GameConfig copyWith({GameType? type, int? level, int? count, int? timer}) {
    return GameConfig(
      type: type ?? this.type,
      level: level ?? this.level,
      count: count ?? this.count,
      timer: timer ?? this.timer,
    );
  }
}
