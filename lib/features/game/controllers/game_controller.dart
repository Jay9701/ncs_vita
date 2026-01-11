// lib/features/game/controllers/game_controller.dart

import 'package:flutter/material.dart';
import '../models/game_config.dart';
import 'timer_controller.dart';

class GameController extends ChangeNotifier {
  final GameConfig config;

  // 상태 변수들
  int currentIdx = 1;
  int correctCnt = 0;
  bool? isCorrect;
  TimerController? timer;
  double remainingSeconds = 0.0;

  GameController({required this.config}) {
    _initTimer();
  }

  void _initTimer() {
    if (config.timer > 0) {
      timer = TimerController(
        totalTime: Duration(seconds: config.timer),
        onTick: (remain) {
          remainingSeconds = remain.inMilliseconds / 1000.0;
          notifyListeners(); // UI 갱신 신호
        },
        onFinish: () => onGameEnd?.call(),
      );
      timer?.start();
    }
  }

  // 종료 시 콜백 (Screen에서 Navigator 처리를 위해)
  VoidCallback? onGameEnd;

  bool get isFinished {
    if (config.count == 0) return false;
    return currentIdx >= config.count;
  }

  void handleAnswer(bool correct) async {
    if (correct) correctCnt++;
    isCorrect = correct;

    timer?.stop();
    notifyListeners();

    // 결과 확인 시간 1초 대기
    await Future.delayed(const Duration(milliseconds: 1000));

    if (isFinished) {
      onGameEnd?.call();
    } else {
      currentIdx++;
      isCorrect = null;
      timer?.start();
      notifyListeners();
    }
  }

  void pause() {
    timer?.stop();
    notifyListeners();
  }

  void resume() {
    timer?.start();
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.dispose();
    super.dispose();
  }
}
