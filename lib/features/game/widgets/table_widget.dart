import 'package:flutter/material.dart';
import 'package:ncs_vita/features/game/services/game_service.dart';
import 'package:ncs_vita/features/game/models/game_question.dart';
import 'package:ncs_vita/features/game/models/level_config.dart';
import 'package:ncs_vita/theme/components/q_card.dart';

class TableWidget extends StatefulWidget {
  final int level;
  final void Function(bool isCorrect) onAnswered;

  const TableWidget({super.key, required this.level, required this.onAnswered});

  @override
  State<TableWidget> createState() => _CalculationGameWidgetState();
}

class _CalculationGameWidgetState extends State<TableWidget> {
  late TableProblem _q;
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
    _q = GameService.generateTableProblem(3);
    setState(() {});
  }

  void _onSelect(int selected) async {
    // 다이얼 오픈
  }

  // 특정 좌표가 구멍인지 확인하는 헬퍼 함수
  TableHole? _getHole(int r, int c) {
    return _q.holes.where((h) => h.row == r && h.col == c).firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. 헤더 (열 라벨)
          Row(
            children: [
              const Expanded(child: SizedBox()), // 행 라벨(구분) 자리 비우기
              ..._q.table.cols.map(
                (col) => Expanded(
                  child: Center(
                    child: Text(
                      col,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),

          // 2. 데이터 행들
          ...List.generate(_q.table.rows.length, (rIdx) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  // 행 라벨 (예: 1회, 국어 등)
                  Expanded(
                    child: Text(
                      _q.table.rows[rIdx],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  // 실제 데이터 셀들
                  ...List.generate(_q.table.cols.length, (cIdx) {
                    final hole = _getHole(rIdx, cIdx);
                    final bool isHole = hole != null;

                    return Expanded(
                      child: GestureDetector(
                        child: Center(
                          child: Text(
                            isHole
                                ? (hole.userInput?.toString() ??
                                      "?") // 입력값 없으면 ?
                                : _q.table.data[rIdx][cIdx].toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: isHole
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isHole
                                  ? Theme.of(context).primaryColor
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
