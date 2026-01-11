import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/foundation.dart';

import 'package:ncs_vita/features/game/models/game_config.dart';
import 'package:ncs_vita/features/game/models/game_result.dart';
import 'package:ncs_vita/features/game/controllers/game_controller.dart';
import 'package:ncs_vita/features/game/widgets/pause_modal.dart';
import 'package:ncs_vita/features/game/widgets/addition_widget.dart';
import 'package:ncs_vita/features/game/widgets/fraction_widget.dart';
import 'package:ncs_vita/features/game/widgets/multiple_widget.dart';
import 'package:ncs_vita/features/result/result_screen.dart';

class Game extends StatefulWidget {
  final GameConfig config;

  const Game({super.key, required this.config});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late GameController _controller;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    // 1. 컨트롤러 초기화 및 종료 콜백 연결
    _controller = GameController(config: widget.config);
    _controller.onGameEnd = _endGame;
  }

  @override
  void dispose() {
    _controller.dispose(); // 자원 해제
    super.dispose();
  }

  // 화면 이동은 UI의 영역이므로 Screen에 남깁니다.
  void _endGame() {
    final result = GameResult(
      config: widget.config,
      currentIdx: _controller.currentIdx,
      correctCnt: _controller.correctCnt,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Result(result: result)),
    );
  }

  void _pause() {
    _controller.pause();
    setState(() => _isPaused = true);
  }

  void _resume() {
    _controller.resume();
    setState(() => _isPaused = false);
  }

  // 어떤 위젯을 보여줄지는 UI의 영역입니다.
  Widget _buildModeWidget() {
    return switch (widget.config.type) {
      GameType.calculation => AdditionWidget(
        key: ValueKey(_controller.currentIdx),
        level: widget.config.level,
        onAnswered: _controller.handleAnswer,
      ),
      GameType.fraction => FractionWidget(
        key: ValueKey(_controller.currentIdx),
        level: widget.config.level,
        onAnswered: _controller.handleAnswer,
      ),
      GameType.multiple => MultipleWidget(
        key: ValueKey(_controller.currentIdx),
        level: widget.config.level,
        onAnswered: _controller.handleAnswer,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder가 컨트롤러의 notifyListeners()를 감시하여 여기만 다시 그립니다.
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    const Spacer(),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 문제 영역
                          SizedBox(
                            height: 210,
                            child: Center(child: _buildModeWidget()),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 60), // 광고 영역 확보
                  ],
                ),

                // 상단 일시정지 버튼
                Positioned(
                  top: 5,
                  left: 12,
                  child: IconButton(
                    icon: const Icon(Icons.pause, size: 32),
                    onPressed: _pause,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                // 일시정지 오버레이 (블러)
                if (_isPaused)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.3),
                        child: Center(
                          child: Pause(
                            onResume: _resume,
                            onExit: () {
                              _controller.currentIdx--; // 현재 문제 제외
                              _endGame();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                // 광고배너 영역
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    color: Colors.grey[200],
                    child: const Center(child: Text("광고 영역 (Banner)")),
                  ),
                ),

                // 디버그 정보
                if (kDebugMode) _buildDebugOverlay(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDebugOverlay() {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.yellow, width: 1),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'monospace',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'DEBUG MODE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                  fontSize: 14,
                ),
              ),
              const Divider(color: Colors.yellow, height: 10),

              // 설정 정보
              Text('Mode: ${widget.config.type.name}'),
              Text('Level: ${widget.config.level}'),
              Text('Total Count: ${widget.config.count}'),

              const SizedBox(height: 5),

              // 실시간 게임 상태 (Controller에서 가져옴)
              Text('currentIdx: ${_controller.currentIdx}'),
              Text('correctCnt: ${_controller.correctCnt}'),
              Text('isCorrect: ${_controller.isCorrect ?? "null"}'),
              Text('isFinished: ${_controller.isFinished}'),

              const SizedBox(height: 5),

              // 타이머 및 일시정지 상태
              Text(
                'Timer (Rem): ${_controller.timer?.remaining.toString().split('.').first}',
              ),
              Text(
                'Raw Seconds: ${_controller.remainingSeconds.toStringAsFixed(2)}s',
              ),
              Text('Paused: $_isPaused'),
            ],
          ),
        ),
      ),
    );
  }
}
