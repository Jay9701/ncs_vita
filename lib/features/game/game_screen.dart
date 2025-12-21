import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:ncs_vita/features/game/models/game_config.dart';
import 'package:ncs_vita/features/game/models/game_result.dart';
import 'package:ncs_vita/features/game/modals/pause_modal.dart';
import 'package:ncs_vita/features/game/widgets/fraction_widget.dart';
import 'package:ncs_vita/features/result/result_screen.dart';
import 'package:ncs_vita/features/game/controllers/timer_controller.dart';

class Game extends StatefulWidget {
  final GameConfig config;

  const Game({super.key, required this.config});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  TimerController? timer;
  bool? _isCorrect;
  int _currentIdx = 1;
  int _correctCnt = 0;
  double remainingSeconds = 0.0;

  bool _isPaused = false;

  @override
  void initState() {
    super.initState();

    if (widget.config.timer > 0) {
      timer = TimerController(
        totalTime: Duration(seconds: widget.config.timer),
        onTick: (remain) {
          setState(() {
            remainingSeconds = remain.inMilliseconds / 1000.0;
          });
        },
        onFinish: () {
          if (!mounted) return;
          _endGame();
        },
      );
      timer?.start();
    }
  }

  @override
  void dispose() {
    timer?.dispose();
    super.dispose();
  }

  bool get isFinished {
    final count = widget.config.count;
    if (count == 0) return false; // 무제한
    return _currentIdx >= count;
  }

  // ✅ 유형별 위젯이 정답/오답만 내려주면 Game은 이것만 처리
  void _onAnswered(bool isCorrect) async {
    if (isCorrect) _correctCnt++;

    // 0.5초(혹은 0.3초) 동안 사용자가 결과를 보게 함
    timer?.stop();
    await Future.delayed(const Duration(milliseconds: 1000));
    timer?.start();

    setState(() {
      _isCorrect = isCorrect;
    });

    if (isFinished) {
      _endGame();
    } else {
      _currentIdx++;
    }
  }

  void _pause() {
    timer?.stop();
    setState(() => _isPaused = true);
  }

  void _resume() {
    timer?.start();
    setState(() => _isPaused = false);
  }

  void _endGame() {
    final result = GameResult(
      config: widget.config,
      currentIdx: _currentIdx,
      correctCnt: _correctCnt,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Result(result: result)),
    );
  }

  // ✅ 모드별 위젯 스왑 자리 (지금은 분수만)
  Widget _buildModeWidget() {
    // 나중에 곱셈/덧뺄 위젯 생기면 switch(widget.config.mode)로 교체
    return FractionWidget(
      key: ValueKey(_currentIdx),
      level: widget.config.level,
      onAnswered: _onAnswered,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAdRemoved = false;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const Spacer(), // 상단 여백 확보 (A 영역 무시용)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ✅ 문제 영역: 이제 유형별 위젯이 담당
                      SizedBox(
                        height: 210, // ⭐ 모드 영역 고정 높이
                        child: Center(child: _buildModeWidget()),
                      ),
                      const SizedBox(height: 16),

                      //const SizedBox(height: 24),

                      // PASS: Game이 문제를 모르니까
                      // PASS는 "문제 위젯에게 다음 문제로 넘겨라" 신호가 필요함.
                      // 일단은 빼는 걸 추천. (아래에 대안 적어둠)
                      //ElevatedButton(onPressed: _pause, child: const Text("정지")),
                      //const SizedBox(height: 16),
                    ],
                  ),
                ),
                // ElevatedButton(onPressed: _pass, child: const Text("패스")),
                const Spacer(), // 문제와 광고 사이를 벌려줌
                SizedBox(height: 60),
              ],
            ),

            // ✅ [C 영역: 일시정지 버튼]
            Positioned(
              top: 5,
              left: 12,
              child: IconButton(
                icon: const Icon(Icons.pause, size: 32),
                onPressed: _pause, // 기존 pause 로직 연결
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

            if (_isPaused)
              Positioned.fill(
                child: BackdropFilter(
                  // ⭐ sigmaX, sigmaY 값이 높을수록 더 강하게 블러(모자이크) 처리가 됩니다.
                  filter: ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: Center(
                      child: Pause(
                        onResume: _resume,
                        onExit: () {
                          // 정지상태에서 종료시 현재 진행중이던 문제는 제외
                          _currentIdx--;
                          _endGame();
                        },
                      ),
                    ),
                  ),
                ),
              ),

            // ✅ [B 영역: 광고 배너]
            // 광고 제거 구매자라도 레이아웃이 튀지 않게 공간(SizedBox)은 유지합니다.
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: 60,
                color: isAdRemoved ? Colors.transparent : Colors.grey[200],
                child: isAdRemoved
                    ? null
                    : const Center(child: Text("광고 영역 (Banner)")),
              ),
            ),

            if (kDebugMode)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DefaultTextStyle(
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DEBUG',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                        ),
                        Text('level: ${widget.config.level}'),
                        Text('count: ${widget.config.count}'),
                        Text('currentIdx: $_currentIdx'),
                        Text('correctCnt: $_correctCnt'),
                        Text('isCorrect: $_isCorrect'),
                        Text('isFinished: $isFinished'),
                        Text('timer: ${timer?.remaining}'),
                        Text('paused: $_isPaused'),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
