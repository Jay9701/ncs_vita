import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ncs_vita/models/game_config.dart';
import 'package:ncs_vita/models/game_result.dart';
import 'package:ncs_vita/screens/modal/pause.dart';
import 'package:ncs_vita/screens/result.dart';
import 'package:ncs_vita/utils/question.dart';

class Game extends StatefulWidget {
  final GameConfig config;

  const Game({super.key, required this.config});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late FractionPair _question; // 현재 문제정보
  bool? _isCorrect; // 최근 결과 (null: 아직 선택 안 함)
  int _currentIdx = 0; // 현재 문항 수
  int _correctCnt = 0; // 정답 갯수

  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  void _newQuestion() {
    setState(() {
      _currentIdx++;
      _question = generateFractionPair(minDiff: 0.3, maxDiff: 2);
    });
  }

  bool get isFinished {
    final count = widget.config.count;
    if (count == null) return false; // 무제한
    return _currentIdx >= count;
  }

  void _onSelect(int index) {
    final first = _question.first;
    final second = _question.second;

    // 분수 크기 비교 (double 캐스팅)
    final firstValue = first.num / first.den;
    final secondValue = second.num / second.den;

    final answer = firstValue > secondValue ? 0 : 1;
    final selectedCorrect = index == answer;
    if (selectedCorrect) _correctCnt++;
    if (isFinished) return _endGame();

    setState(() {
      _isCorrect = selectedCorrect;
    });

    _newQuestion();
  }

  void _pause() {
    setState(() {
      _isPaused = true;
    });
  }

  void _resume() {
    setState(() {
      _isPaused = false;
    });
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

  Widget _buildFractionButton({
    required int index,
    required int numerator,
    required int denominator,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _onSelect(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$numerator',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 2, height: 8),
            Text(
              '$denominator',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final first = _question.first;
    final second = _question.second;

    return Scaffold(
      appBar: AppBar(title: Text('level::: ${widget.config.level}')),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 문제 영역
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFractionButton(
                      index: 0,
                      numerator: first.num,
                      denominator: first.den,
                    ),
                    const SizedBox(width: 16),
                    _buildFractionButton(
                      index: 1,
                      numerator: second.num,
                      denominator: second.den,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_isCorrect != null)
                  Text(
                    _isCorrect! ? '정답 ✅' : '오답 ❌',
                    style: TextStyle(
                      fontSize: 18,
                      color: _isCorrect! ? Colors.green : Colors.red,
                    ),
                  ),
                const SizedBox(height: 24),
                // 다음 문제 버튼 (디버깅용 / 수동)
                ElevatedButton(
                  onPressed: () {
                    _isCorrect = null;
                    _newQuestion();
                  },
                  child: const Text("다음 문제"),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    _pause();
                  },
                  child: Text("정지"),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          // 2) 일시정지 오버레이
          if (_isPaused)
            Positioned.fill(
              child: Container(
                color: Colors.black54, // 배경 dim
                child: Center(
                  child: Pause(
                    onResume: _resume,
                    onExit: () {
                      // 정지상태에서 종료시 현재 진행중이던 문제는 제외하고 결과처리
                      _currentIdx--;
                      _endGame();
                    },
                  ),
                ),
              ),
            ),
          // 3) 디버그 오버레이
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
                      Text('first: ${first.num}/${first.den}'),
                      Text('second: ${second.num}/${second.den}'),
                      Text('isCorrect: $_isCorrect'),
                      Text('isFinished: $isFinished'),
                      // 타이머 쓰면 여기에 남은 시간 같은 것도 추가
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
