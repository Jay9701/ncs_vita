import 'package:flutter/material.dart';
import 'package:ncs_vita/features/game/services/game_service.dart';
import 'package:ncs_vita/features/game/models/game_question.dart';
import 'package:ncs_vita/features/game/models/level_config.dart';
import 'package:ncs_vita/theme/components/q_card.dart';

class MultipleWidget extends StatefulWidget {
  final int level;
  final void Function(bool isCorrect) onAnswered;

  const MultipleWidget({
    super.key,
    required this.level,
    required this.onAnswered,
  });

  @override
  State<MultipleWidget> createState() => _MultipleWidgetState();
}

class _MultipleWidgetState extends State<MultipleWidget> {
  late MultiplicationPair _q;
  int? _selectedIndex; // 유저가 방금 누른 카드 인덱스 (0 또는 1)
  bool _showResult = false; // 정답/오답 색상을 보여줄지 여부
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  void _newQuestion() {
    final cfg = getLevelConfig(widget.level);
    _q = GameService.generateMultiplicationPair(
      minDiff: cfg.minDiff,
      maxDiff: cfg.maxDiff,
      maxVal: cfg.maxVal,
    );
    setState(() {});
  }

  void _onSelect(int selected) async {
    if (_showResult) return; // 이미 결과 보여주는 중이면 중복 클릭 방지

    setState(() {
      // final a = _q.first.num / _q.first.den;
      // final b = _q.second.num / _q.second.den;
      final a = _q.a * _q.b;
      final b = _q.c * _q.d;
      _isCorrect = selected == (a > b ? 0 : 1);
      _selectedIndex = selected; // 1. 내가 누른 게 뭔지 저장
      _showResult = true; // 2. 이제 색깔 보여줘! 라고 신호 보냄
    });

    // 3. 다음 문제로 넘어가기 전 상태 초기화
    setState(() {
      widget.onAnswered(_isCorrect);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color? _getCardColor(int index) {
      if (!_showResult || _selectedIndex != index) {
        return null; // 아직 안 눌렀거나 내가 누른 게 아니면 투명
      }

      // 사용자가 누른 카드가 정답인지 확인 (데이터 구조에 따라 수정 필요)

      return _isCorrect ? Colors.green : Colors.red;
    }

    return Row(
      children: [
        const SizedBox(width: 32),
        Expanded(
          child: QCard(
            onTap: () => _onSelect(0),
            borderColor: _getCardColor(0), // 여기서 실시간으로 색 결정
            child: _MultiplicationUi(num1: _q.a, num2: _q.b),
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: QCard(
            onTap: () => _onSelect(1),
            borderColor: _getCardColor(1), // 여기서 실시간으로 색 결정
            child: _MultiplicationUi(num1: _q.c, num2: _q.d),
          ),
        ),
        const SizedBox(width: 32),
      ],
    );
  }
}

class _MultiplicationUi extends StatelessWidget {
  final int num1;
  final int num2;

  const _MultiplicationUi({required this.num1, required this.num2});

  @override
  Widget build(BuildContext context) {
    return Text('$num1 x $num2');
  }
}
