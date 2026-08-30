enum GameType {
  fraction('분수 비교', '자료해석 기본 훈련\n분수의 크기를 비교해 더 큰 값을 선택하세요.'),
  multiple('곱셈 비교', '자료해석 기본 훈련\n곱셈식을 계산하고 더 큰 값을 선택하세요.'),
  calculation('덧셈/뺄셈', '자료해석 기본 훈련\n덧셈과 뺄셈 계산 결과를 빠르게 입력하세요.'),
  table('표 빈칸 채우기', '자료해석 실전 훈련\n행과 열의 합계를 보고 빈칸을 채우세요.');

  const GameType(this.label, this.description);
  final String label;
  final String description;

  GameType get prev {
    return GameType.values[(index - 1 + GameType.values.length) %
        GameType.values.length];
  }

  GameType get next {
    final nextIndex = (index + 1) % GameType.values.length;
    return GameType.values[nextIndex];
  }
}

enum GameMode { practice, exam }

class GameConfig {
  final GameMode mode;
  final GameType type;
  final List<GameType> examTypes;
  final int level;
  final int count;
  final int timer;

  const GameConfig({
    this.mode = GameMode.practice,
    this.type = GameType.fraction,
    this.examTypes = const [],
    this.level = 1,
    this.count = 10,
    this.timer = 30,
  });

  List<GameType> get effectiveTypes {
    if (mode == GameMode.exam && examTypes.isNotEmpty) {
      return examTypes;
    }
    return [type];
  }

  GameConfig copyWith({
    GameMode? mode,
    GameType? type,
    List<GameType>? examTypes,
    int? level,
    int? count,
    int? timer,
  }) {
    return GameConfig(
      mode: mode ?? this.mode,
      type: type ?? this.type,
      examTypes: examTypes ?? this.examTypes,
      level: level ?? this.level,
      count: count ?? this.count,
      timer: timer ?? this.timer,
    );
  }

  static GameConfig examPreset({
    int count = 10,
    int timer = 15,
    int level = 2,
  }) {
    return GameConfig(
      mode: GameMode.exam,
      type: GameType.fraction,
      examTypes: [
        GameType.fraction,
        GameType.fraction,
        GameType.fraction,
        GameType.fraction,
        GameType.multiple,
        GameType.multiple,
        GameType.multiple,
        GameType.calculation,
        GameType.calculation,
        GameType.calculation,
      ],
      level: level,
      count: count,
      timer: timer,
    );
  }
}
