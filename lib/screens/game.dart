import 'package:flutter/material.dart';
import 'package:ncs_vita/screens/pause.dart';
import 'package:ncs_vita/screens/result.dart';
import 'package:ncs_vita/utils/question.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late FractionPair currentProblem;
  bool? isCorrect; // 최근 결과 (null: 아직 선택 안 함)

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  void _newQuestion() {
    setState(() {
      currentProblem = generateFractionPair(minDiff: 0.3, maxDiff: 2);
    });
  }

  void _onSelect(int index) {
    final first = currentProblem.first;
    final second = currentProblem.second;

    // 분수 크기 비교 (double 캐스팅)
    final firstValue = first.num / first.den;
    final secondValue = second.num / second.den;

    final correctIndex = firstValue > secondValue ? 0 : 1;
    final selectedCorrect = index == correctIndex;

    setState(() {
      isCorrect = selectedCorrect;
    });

    // 일단은 스낵바로 피드백
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(selectedCorrect ? '정답!' : '오답 😅'),
        duration: const Duration(milliseconds: 600),
      ),
    );
    _newQuestion();

    // 정답/오답 상관없이 다음 문제 자동으로 넘기고 싶으면:
    // Future.delayed(const Duration(milliseconds: 600), _newQuestion);
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
    final first = currentProblem.first;
    final second = currentProblem.second;

    return Scaffold(
      appBar: AppBar(title: const Text("Game")),
      body: Center(
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
            if (isCorrect != null)
              Text(
                isCorrect! ? '정답 ✅' : '오답 ❌',
                style: TextStyle(
                  fontSize: 18,
                  color: isCorrect! ? Colors.green : Colors.red,
                ),
              ),
            const SizedBox(height: 24),
            // 다음 문제 버튼 (디버깅용 / 수동)
            ElevatedButton(
              onPressed: () {
                isCorrect = null;
                _newQuestion();
              },
              child: const Text("다음 문제"),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Pause()),
                );
              },
              child: Text("정지"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Result()),
                );
              },
              child: Text("결과"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _newQuestion();
              },
              child: Text("function"),
            ),
          ],
        ),
      ),
    );
  }
}
