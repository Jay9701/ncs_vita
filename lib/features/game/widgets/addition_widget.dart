import 'package:flutter/material.dart';
import 'package:ncs_vita/features/game/services/game_service.dart';
import 'package:ncs_vita/features/game/models/game_question.dart';
import 'package:ncs_vita/features/game/models/level_config.dart';
import 'package:ncs_vita/features/game/widgets/number_pad.dart';
import 'package:ncs_vita/theme/font.dart';

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
  bool? _isCorrect;
  int? _correctAnswer;

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  void _newQuestion() {
    final config = getCalculationConfig(widget.level);
    _q = GameService.generateAddProblem(
      len: config.termCount,
      maxVal: config.maxValue,
      sumBlankProbability: config.sumBlankProbability,
    );
    setState(() {
      _input = ""; // 입력값 초기화
      _isCorrect = null;
      _correctAnswer = null;
    });
  }

  // 숫자 버튼 눌렀을 때 실행할 함수
  void _handleNumberTap(String number) {
    if (_isCorrect != null) return;

    setState(() {
      if (_input.length < 10) {
        // (선택) 최대 10자리까지만 입력 가능하게 제한
        _input += number;
      }
    });
  }

  // 지우기 버튼 눌렀을 때 실행할 함수
  void _handleDelete() {
    if (_isCorrect != null) return;

    if (_input.isNotEmpty) {
      setState(() {
        _input = _input.substring(0, _input.length - 1);
      });
    }
  }

  // 전체 지우기 버튼 눌렀을 때 실행할 함수
  void _handleClear() {
    if (_isCorrect != null) return;

    setState(() {
      _input = "";
    });
  }

  // 제출 버튼 눌렀을 때 실행할 함수
  void _handleSubmit() {
    if (_input.isEmpty || _isCorrect != null) return;

    // 정답 확인
    final int? userAnswer = int.tryParse(_input);
    final int correctAnswer = _q.hIdx == _q.nums.length
        ? _q
              .sum // 합을 맞추는 경우
        : _q.nums[_q.hIdx]; // 빈 숫자를 맞추는 경우

    final bool isCorrect = userAnswer == correctAnswer;

    setState(() {
      _isCorrect = isCorrect;
      _correctAnswer = correctAnswer;
    });

    // 부모에게 결과 전달
    widget.onAnswered(isCorrect);

    // 다음 문제로 진행 (1초 후)
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _newQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;
        final questionTextSize = context
            .scaleText(compact ? 14.0 : 16.0)
            .clamp(13.0, 18.0);
        final operatorTextSize = context
            .scaleText(compact ? 14.0 : 16.0)
            .clamp(13.0, 18.0);
        final buttonTextSize = context
            .scaleText(compact ? 16.0 : 18.0)
            .clamp(14.0, 20.0);
        final displayedAnswer = _isCorrect == false
            ? '${_correctAnswer!}'
            : _input;

        return Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 12 : 16,
                  vertical: compact ? 18 : 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "다음 빈칸에 알맞은 수는?",
                      style: TextStyle(
                        fontSize: questionTextSize,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: compact ? 16 : 24),
                    SingleChildScrollView(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: compact ? 4 : 6,
                        runSpacing: compact ? 16 : 20,
                        children: [
                          ...List.generate(_q.nums.length, (i) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildNumberBox(
                                  i == _q.hIdx
                                      ? displayedAnswer
                                      : "${_q.nums[i]}",
                                  isQuestion: i == _q.hIdx,
                                  isCorrect: _isCorrect,
                                  compact: compact,
                                  textScaler: TextScaler.linear(
                                    context.effectiveTextScale,
                                  ),
                                ),
                                if (i < _q.nums.length - 1)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 2,
                                      right: 2,
                                    ),
                                    child: Text(
                                      "+",
                                      style: TextStyle(
                                        fontSize: operatorTextSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                          Text(
                            "=",
                            style: TextStyle(
                              fontSize: operatorTextSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildNumberBox(
                            _q.hIdx == _q.nums.length
                                ? displayedAnswer
                                : "${_q.sum}",
                            isQuestion: _q.hIdx == _q.nums.length,
                            isCorrect: _isCorrect,
                            compact: compact,
                            textScaler: TextScaler.linear(
                              context.effectiveTextScale,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, compact ? 6 : 8),
              child: SizedBox(
                width: double.infinity,
                height: compact ? 48 : 52,
                child: ElevatedButton(
                  onPressed: _input.isEmpty || _isCorrect != null
                      ? null
                      : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '입력',
                    style: TextStyle(
                      fontSize: buttonTextSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            NumberPad(
              onNumberTap: _handleNumberTap,
              onDelete: _handleDelete,
              onClear: _handleClear,
            ),
          ],
        );
      },
    );
  }

  // 개별 숫자 박스 스타일
  Widget _buildNumberBox(
    String text, {
    bool isQuestion = false,
    bool? isCorrect,
    bool compact = false,
    required TextScaler textScaler,
  }) {
    final boxFontSize = textScaler
        .scale(compact ? 18.0 : 21.0)
        .clamp(compact ? 16.0 : 18.0, 23.0);
    final hasInput = isQuestion && text.isNotEmpty;
    final feedbackColor = isCorrect == true
        ? Colors.green
        : isCorrect == false
        ? Colors.red
        : Colors.orange;
    final feedbackBackground = isCorrect == true
        ? Colors.green[100]
        : isCorrect == false
        ? Colors.red[100]
        : Colors.orange[100];

    return Container(
      constraints: isQuestion
          ? BoxConstraints(minWidth: compact ? 44 : 50)
          : null,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 9,
        vertical: compact ? 5 : 6,
      ),
      decoration: BoxDecoration(
        color: isQuestion ? feedbackBackground : Colors.white,
        border: Border.all(
          color: isQuestion ? feedbackColor : Colors.grey[300]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: boxFontSize,
          fontWeight: FontWeight.bold,
          color: hasInput
              ? feedbackColor
              : isQuestion
              ? Colors.orange[900]
              : Colors.black87,
        ),
      ),
    );
  }
}
