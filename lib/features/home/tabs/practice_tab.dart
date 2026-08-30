import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ncs_vita/features/game/models/game_config.dart';
import 'package:ncs_vita/theme/components/card.dart';
import 'package:ncs_vita/theme/font.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Practice extends StatefulWidget {
  final void Function(GameConfig config) onStart;
  const Practice({super.key, required this.onStart});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  static const _typeKey = 'practice_type';
  static const _levelKey = 'practice_level';
  static const _countKey = 'practice_count';
  static const _timerKey = 'practice_timer';

  GameConfig config = GameConfig(level: 1);

  @override
  void initState() {
    super.initState();
    _restoreConfig();
  }

  Future<void> _restoreConfig() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final typeIndex = preferences.getInt(_typeKey);
      final savedType =
          typeIndex != null &&
              typeIndex >= 0 &&
              typeIndex < GameType.values.length
          ? GameType.values[typeIndex]
          : config.type;

      if (!mounted) return;
      setState(() {
        config = config.copyWith(
          type: savedType,
          level: (preferences.getInt(_levelKey) ?? config.level).clamp(1, 10),
          count: (preferences.getInt(_countKey) ?? config.count).clamp(10, 30),
          timer: (preferences.getInt(_timerKey) ?? config.timer).clamp(0, 3600),
        );
      });
    } catch (_) {
      // Keep the default configuration when local storage is unavailable.
    }
  }

  Future<void> _saveConfig() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await Future.wait([
        preferences.setInt(_typeKey, config.type.index),
        preferences.setInt(_levelKey, config.level),
        preferences.setInt(_countKey, config.count),
        preferences.setInt(_timerKey, config.timer),
      ]);
    } catch (_) {
      // The current session can continue even when local storage is unavailable.
    }
  }

  Future<void> _selectOption<T>({
    required String title,
    required List<T> options,
    required T selected,
    required String Function(T option) labelBuilder,
    required ValueChanged<T> onSelected,
    Widget? helpContent,
  }) async {
    var isHelpVisible = false;
    final result = await showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => FractionallySizedBox(
          heightFactor: 0.7,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      if (helpContent != null)
                        IconButton(
                          tooltip: '난이도 안내',
                          onPressed: () {
                            setSheetState(() => isHelpVisible = !isHelpVisible);
                          },
                          icon: Icon(
                            isHelpVisible
                                ? Icons.close_rounded
                                : Icons.help_outline_rounded,
                          ),
                        ),
                    ],
                  ),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 180),
                    crossFadeState: isHelpVisible
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 8, bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: helpContent ?? const SizedBox.shrink(),
                    ),
                    secondChild: const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(labelBuilder(option)),
                          trailing: option == selected
                              ? const Icon(Icons.check_rounded)
                              : null,
                          onTap: () => Navigator.pop(context, option),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (result != null) {
      setState(() => onSelected(result));
      await _saveConfig();
    }
  }

  Future<void> _selectTimer() async {
    var minutes = config.timer ~/ 60;
    var seconds = config.timer % 60;
    final result = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '타이머 선택',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context, minutes * 60 + seconds),
                      child: const Text('완료'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 180,
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 40,
                          scrollController: FixedExtentScrollController(
                            initialItem: minutes,
                          ),
                          onSelectedItemChanged: (value) {
                            setSheetState(() {
                              minutes = value;
                              if (minutes == 60) seconds = 0;
                            });
                          },
                          children: List.generate(
                            61,
                            (index) => Center(child: Text('$index분')),
                          ),
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 40,
                          scrollController: FixedExtentScrollController(
                            initialItem: seconds,
                          ),
                          onSelectedItemChanged: (value) {
                            if (minutes < 60) {
                              setSheetState(() => seconds = value);
                            }
                          },
                          children: List.generate(
                            60,
                            (index) => Center(
                              child: Text(minutes == 60 ? '0초' : '$index초'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (result != null) {
      setState(() => config = config.copyWith(timer: result));
      await _saveConfig();
    }
  }

  String _formatTimer(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    if (minutes == 0) return '$seconds초';
    if (seconds == 0) return '$minutes분';
    return '$minutes분 $seconds초';
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 360;
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(compact ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              '연습 모드',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '레벨과 문제 수를 설정하고 바로 시작해보세요.',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.6),
                fontSize: context.scaleText(12.5).clamp(11.0, 14.0),
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () => widget.onStart(config),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(compact ? 18 : 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      colors.primary,
                      Color.alphaBlend(
                        colors.onPrimary.withValues(alpha: 0.4),
                        colors.primary,
                      ),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.onPrimary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: colors.onPrimary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          config.type.label,
                          style: TextStyle(
                            fontSize: context.scaleText(17).clamp(15.0, 20.0),
                            fontWeight: FontWeight.bold,
                            color: colors.onPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      config.type.description,
                      style: TextStyle(
                        fontSize: context.scaleText(12.5).clamp(11.0, 14.0),
                        color: colors.onPrimary.withValues(alpha: 0.75),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        CardLabel(
                          icon: Icons.quiz_rounded,
                          label: '${config.count}문제',
                          iconColor: colors.onPrimary.withValues(alpha: 0.7),
                          textColor: colors.onPrimary,
                          backgroundColor: colors.onPrimary.withValues(
                            alpha: 0.12,
                          ),
                        ),
                        CardLabel(
                          icon: Icons.access_time_rounded,
                          label: _formatTimer(config.timer),
                          iconColor: colors.onPrimary.withValues(alpha: 0.7),
                          textColor: colors.onPrimary,
                          backgroundColor: colors.onPrimary.withValues(
                            alpha: 0.12,
                          ),
                        ),
                        CardLabel(
                          icon: Icons.trending_up_rounded,
                          label: 'Lv.${config.level}',
                          iconColor: colors.onPrimary.withValues(alpha: 0.7),
                          textColor: colors.onPrimary,
                          backgroundColor: colors.onPrimary.withValues(
                            alpha: 0.12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: compact ? 1.42 : 1.35,
              children: [
                StatCard(
                  title: '유형',
                  value: config.type.label,
                  onTap: () => _selectOption<GameType>(
                    title: '유형 선택',
                    options: GameType.values,
                    selected: config.type,
                    labelBuilder: (type) => type.label,
                    onSelected: (type) => config = config.copyWith(type: type),
                  ),
                ),
                StatCard(
                  title: '난이도',
                  value: 'Lv.${config.level}',
                  onTap: () => _selectOption<int>(
                    title: '난이도 선택',
                    options: List.generate(10, (index) => index + 1),
                    selected: config.level,
                    labelBuilder: (level) => 'Lv.$level',
                    onSelected: (level) =>
                        config = config.copyWith(level: level),
                    helpContent: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DifficultyGuideRow(range: 'Lv.1~3', label: '기초'),
                        _DifficultyGuideRow(range: 'Lv.4~6', label: '연습'),
                        _DifficultyGuideRow(range: 'Lv.7~8', label: '실전'),
                        _DifficultyGuideRow(range: 'Lv.9~10', label: '심화'),
                      ],
                    ),
                  ),
                ),
                StatCard(
                  title: '문항수',
                  value: '${config.count}',
                  onTap: () => _selectOption<int>(
                    title: '문항수 선택',
                    options: List.generate(21, (index) => index + 10),
                    selected: config.count,
                    labelBuilder: (count) => '$count문제',
                    onSelected: (count) =>
                        config = config.copyWith(count: count),
                  ),
                ),
                StatCard(
                  title: '타이머',
                  value: _formatTimer(config.timer),
                  onTap: _selectTimer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyGuideRow extends StatelessWidget {
  final String range;
  final String label;

  const _DifficultyGuideRow({required this.range, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              range,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Text(label),
        ],
      ),
    );
  }
}
