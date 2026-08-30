import 'package:flutter/material.dart';
import 'package:ncs_vita/features/game/services/game_service.dart';
import 'package:ncs_vita/features/game/models/game_question.dart';
import 'package:ncs_vita/features/game/models/level_config.dart';
import 'package:ncs_vita/theme/components/q_card.dart';

class FractionWidget extends StatefulWidget {
  final int level;
  final void Function(bool isCorrect) onAnswered;

  const FractionWidget({
    super.key,
    required this.level,
    required this.onAnswered,
  });

  @override
  State<FractionWidget> createState() => _FractionWidgetState();
}

class _FractionWidgetState extends State<FractionWidget> {
  late FractionPair _q;
  int? _selectedIndex; // 유저가 방금 누른 카드 인덱스 (0 또는 1)
  bool _showResult = false; // 정답/오답 색상을 보여줄지 여부
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  void _newQuestion() {
    final config = getFractionConfig(widget.level);
    _q = GameService.generateFractionPair(
      minDiff: config.minDiff,
      maxDiff: config.maxDiff,
      maxVal: config.maxValue,
    );
    setState(() {});
  }

  void _onSelect(int selected) async {
    if (_showResult) return; // 이미 결과 보여주는 중이면 중복 클릭 방지

    setState(() {
      _isCorrect = selected == (_q.isFirstGreater ? 0 : 1);
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
    Color? getCardColor(int index) {
      if (!_showResult || _selectedIndex != index) {
        return null; // 아직 안 눌렀거나 내가 누른 게 아니면 투명
      }

      // 사용자가 누른 카드가 정답인지 확인 (데이터 구조에 따라 수정 필요)

      return _isCorrect ? Colors.green : Colors.red;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '더 큰 값을 선택하세요',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: QCard(
                onTap: () => _onSelect(0),
                borderColor: getCardColor(0),
                child: _FractionUi(num: _q.first.num, den: _q.first.den),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: QCard(
                onTap: () => _onSelect(1),
                borderColor: getCardColor(1),
                child: _FractionUi(num: _q.second.num, den: _q.second.den),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}

class _FractionUi extends StatelessWidget {
  final int num;
  final int den;

  const _FractionUi({required this.num, required this.den});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$num'),
        const SizedBox(height: 8),
        Container(
          width: 56,
          height: 2,
          decoration: BoxDecoration(
            color: Color(0xFFD6DCE6),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 8),
        Text('$den'),
      ],
    );
  }
}
