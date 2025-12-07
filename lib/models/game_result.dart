import 'package:ncs_vita/models/game_config.dart';

class GameResult {
  final GameConfig config;
  final int currentIdx;
  final int correctCnt;

  // 정답률 (0.0 ~ 1.0)
  double get accuracy => currentIdx == 0 ? 0.0 : correctCnt / currentIdx;
  // 정답률 (%) 문자열
  String get accuracyStr => "${(accuracy * 100).toStringAsFixed(1)}%";
  // 오답 수
  int get wrongCnt => currentIdx - correctCnt;

  const GameResult({
    required this.config,
    required this.currentIdx,
    required this.correctCnt,
  });
}
