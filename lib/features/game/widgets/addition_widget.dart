import 'package:flutter/material.dart';
import 'package:ncs_vita/features/game/services/game_service.dart';
import 'package:ncs_vita/features/game/models/game_question.dart';
import 'package:ncs_vita/features/game/models/level_config.dart';
import 'package:ncs_vita/theme/components/q_card.dart';

class AdditionWidget extends StatefulWidget {
  final int level;
  final void Function(bool isCorrect) onAnswered;

  const AdditionWidget({
    super.key,
    required this.level,
    required this.onAnswered,
  });

  @override
  State<AdditionWidget> createState() => _AddtionWidgetState();
}

class _AddtionWidgetState extends State<AdditionWidget> {
  late AdditionSet _q;

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  void _newQuestion() {
    final cfg = getLevelConfig(widget.level);
    _q = GameService.generateAddProblem(len: 3, maxVal: 99);
    setState(() {});
  }

  void _showNumPad(int selected) async {
    // 넘버패드 오픈
  }

  @override
  Widget build(BuildContext context) {
    // 예시: 실제로는 위젯 외부나 State에서 생성된 데이터를 사용합니다.
    // final problem = generateAddProblem(len: 3, maxVal: 99);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("다음 빈칸에 알맞은 수는?", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8, // 요소 사이 간격
            children: [
              // 1. 숫자 리스트 나열 (hIdx 체크)
              ...List.generate(_q.nums.length, (i) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNumberBox(
                      i == _q.hIdx ? "?" : "${_q.nums[i]}",
                      isQuestion: i == _q.hIdx,
                    ),
                    if (i < _q.nums.length - 1)
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          "+",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                );
              }),

              // 2. 등호
              const Text(
                "=",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              // 3. 결과값 (hIdx가 len과 같다면 가림)
              _buildNumberBox(
                _q.hIdx == _q.nums.length ? "?" : "${_q.sum}",
                isQuestion: _q.hIdx == _q.nums.length,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 개별 숫자 박스 스타일
  Widget _buildNumberBox(String text, {bool isQuestion = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isQuestion ? Colors.orange[100] : Colors.white,
        border: Border.all(
          color: isQuestion ? Colors.orange : Colors.grey[300]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isQuestion ? Colors.orange[900] : Colors.black87,
        ),
      ),
    );
  }

  // 숫자패드 위젯 예시
  Widget _buildNumPad({required Function(String) onKeyTap}) {
    final keys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "C", "0", "⌫"];

    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: keys.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            onPressed: () => onKeyTap(keys[index]),
            child: Text(
              keys[index],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
