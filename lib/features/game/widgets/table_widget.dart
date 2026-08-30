import 'package:flutter/material.dart';
import 'package:ncs_vita/features/game/models/game_question.dart';
import 'package:ncs_vita/features/game/services/game_service.dart';
import 'package:ncs_vita/features/game/widgets/number_pad.dart';
import 'package:ncs_vita/theme/font.dart';

class TableWidget extends StatefulWidget {
  final int level;
  final void Function(bool isCorrect) onAnswered;

  const TableWidget({super.key, required this.level, required this.onAnswered});

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  late TableProblem _problem;
  final Map<TableHole, String> _inputs = {};
  TableHole? _activeHole;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  void _newQuestion() {
    _problem = GameService.generateTableProblem();
    _inputs.clear();
    _activeHole = _problem.holes.first;
    _isSubmitted = false;
  }

  void _appendNumber(String number) {
    if (_isSubmitted || _activeHole == null) return;
    setState(() {
      final current = _inputs[_activeHole] ?? '';
      if (current.length < 6) _inputs[_activeHole!] = '$current$number';
    });
  }

  void _deleteNumber() {
    if (_isSubmitted || _activeHole == null) return;
    setState(() {
      final current = _inputs[_activeHole] ?? '';
      if (current.isNotEmpty) {
        _inputs[_activeHole!] = current.substring(0, current.length - 1);
      }
    });
  }

  void _clearNumber() {
    if (_isSubmitted || _activeHole == null) return;
    setState(() => _inputs[_activeHole!] = '');
  }

  void _submit() {
    final isReady = _problem.holes.every(
      (hole) => (_inputs[hole] ?? '').isNotEmpty,
    );
    if (_isSubmitted || !isReady) return;

    setState(() {
      for (final hole in _problem.holes) {
        hole.userInput = int.tryParse(_inputs[hole] ?? '');
      }
      _isSubmitted = true;
    });

    widget.onAnswered(_problem.isAllCorrect);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(_newQuestion);
    });
  }

  TableHole? _getHole(int row, int column) {
    for (final hole in _problem.holes) {
      if (hole.row == row && hole.col == column) return hole;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 360;
    final isReadyToSubmit = _problem.holes.every(
      (hole) => (_inputs[hole] ?? '').isNotEmpty,
    );

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, compact ? 12 : 20, 16, 12),
            child: Column(
              children: [
                Text(
                  _problem.table.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text('단위: ${_problem.table.unit}'),
                const SizedBox(height: 16),
                _buildTable(context),
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
              onPressed: isReadyToSubmit && !_isSubmitted ? _submit : null,
              child: Text(
                '입력',
                style: TextStyle(
                  fontSize: context.scaleText(compact ? 16 : 18),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        NumberPad(
          onNumberTap: _appendNumber,
          onDelete: _deleteNumber,
          onClear: _clearNumber,
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final table = _problem.table;

    return Table(
      border: TableBorder.all(color: colors.outline.withValues(alpha: 0.35)),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {0: FlexColumnWidth(1.15)},
      children: [
        TableRow(
          decoration: BoxDecoration(color: colors.surfaceContainerHighest),
          children: [
            _headerCell(context, '구분'),
            ...table.cols.map((label) => _headerCell(context, label)),
            _headerCell(context, table.rowSummaryLabel),
          ],
        ),
        ...List.generate(table.rows.length, (rowIndex) {
          return TableRow(
            children: [
              _labelCell(context, table.rows[rowIndex]),
              ...List.generate(table.cols.length, (columnIndex) {
                return _dataCell(
                  context,
                  _getHole(rowIndex, columnIndex),
                  table.data[rowIndex][columnIndex],
                );
              }),
              _dataCell(context, null, table.rowSummaries[rowIndex]),
            ],
          );
        }),
        TableRow(
          decoration: BoxDecoration(color: colors.surfaceContainerHighest),
          children: [
            _headerCell(context, table.columnSummaryLabel),
            ...table.columnSummaries.map(
              (summary) => _dataCell(context, null, summary),
            ),
            _dataCell(context, null, table.grandSummary),
          ],
        ),
      ],
    );
  }

  Widget _headerCell(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }

  Widget _labelCell(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    );
  }

  Widget _dataCell(BuildContext context, TableHole? hole, int value) {
    final colors = Theme.of(context).colorScheme;
    final isHole = hole != null;
    final isActive = identical(hole, _activeHole);
    final isCorrect = _isSubmitted && hole?.isCorrect == true;
    final isWrong = _isSubmitted && hole?.isCorrect == false;
    final displayValue = !isHole
        ? '$value'
        : isWrong
        ? '${hole.originalValue}'
        : (_inputs[hole] ?? '?');
    final foreground = isCorrect
        ? Colors.green
        : isWrong
        ? Colors.red
        : isHole
        ? colors.primary
        : colors.onSurface;

    return InkWell(
      onTap: isHole && !_isSubmitted
          ? () => setState(() => _activeHole = hole)
          : null,
      child: Container(
        constraints: const BoxConstraints(minHeight: 46),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isCorrect
              ? Colors.green.withValues(alpha: 0.12)
              : isWrong
              ? Colors.red.withValues(alpha: 0.12)
              : isActive
              ? Colors.orange.withValues(alpha: 0.12)
              : null,
          border: isActive ? Border.all(color: Colors.orange, width: 2) : null,
        ),
        child: Text(
          displayValue,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: context.scaleText(16).clamp(13.0, 19.0),
            fontWeight: isHole ? FontWeight.w700 : FontWeight.w500,
            color: foreground,
          ),
        ),
      ),
    );
  }
}
