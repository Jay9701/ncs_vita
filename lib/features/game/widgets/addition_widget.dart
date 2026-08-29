import 'package:flutter/material.dart';
import 'package:ncs_vita/features/game/services/game_service.dart';
import 'package:ncs_vita/features/game/models/game_question.dart';
import 'package:ncs_vita/features/game/models/level_config.dart';
import 'package:ncs_vita/features/game/widgets/number_pad.dart';
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
  String _input = "";

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

  // 숫자 버튼 눌렀을 때 실행할 함수
  void _handleNumberTap(String number) {
    setState(() {
      if (_input.length < 10) {
        // (선택) 최대 10자리까지만 입력 가능하게 제한
        _input += number;
      }
    });
  }

  // 지우기 버튼 눌렀을 때 실행할 함수
  void _handleDelete() {
    if (_input.isNotEmpty) {
      setState(() {
        _input = _input.substring(0, _input.length - 1);
      });
    }
  }

  // 제출 버튼 눌렀을 때 실행할 함수
  void _handleSubmit() {
    print("제출된 값: $_input");
    // 여기에 정답 체크 로직 추가
    // checkAnswer(_input);

    // (선택) 제출 후 입력창 비우기
    setState(() {
      _input = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "다음 빈칸에 알맞은 수는?",
                  style: TextStyle(color: Colors.grey),
                ),
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // 3. 결과값 (hIdx가 len과 같다면 가림)
                    _buildNumberBox(
                      _q.hIdx == _q.nums.length ? "?" : "${_q.sum}",
                      isQuestion: _q.hIdx == _q.nums.length,
                    ),

                    Container(
                      color: Colors.white,
                      child: NumberPad(
                        onNumberTap: _handleNumberTap, // 함수 연결
                        onDelete: _handleDelete, // 함수 연결
                        onSubmit: _handleSubmit, // 함수 연결
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
}
