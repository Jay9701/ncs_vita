import 'package:flutter/material.dart';
import 'package:ncs_vita/features/game/models/game_config.dart';
import 'package:ncs_vita/theme/components/app_card.dart';

class Practice extends StatefulWidget {
  final void Function(GameConfig config) onStart;
  const Practice({super.key, required this.onStart});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  GameConfig config = GameConfig(level: 1);

  void _prevLevel() {
    setState(() {
      int next = (config.level - 1).clamp(1, 10);
      config = config.copyWith(level: next);
    });
  }

  void _nextLevel() {
    setState(() {
      int next = (config.level + 1).clamp(1, 10);
      config = config.copyWith(level: next);
      debugPrint('config::: ${config.level}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 30),

          // ===== 상단 큰 카드 =====
          SizedBox(
            height: 220,
            width: double.infinity,
            child: AppCard(
              onTap: () {
                widget.onStart(config);
              },
              child: Center(child: Text('분수 비교')),
            ),
          ),

          const SizedBox(height: 16),

          // ===== 하단 카드 그리드 =====
          GridView.count(
            shrinkWrap: true, // ⭐ 핵심
            physics: const NeverScrollableScrollPhysics(), // ⭐ 핵심
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.6,
            children: [
              AppCard(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // ⭐ 핵심
                  children: [
                    SizedBox(height: 15),
                    Center(child: Text('난이도')),
                    SizedBox(height: 15),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // ⭐ 중요
                        children: [
                          Icon(Icons.arrow_left),
                          TextButton(
                            onPressed: _nextLevel,
                            child: Text(
                              '${config.level}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_right),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppCard(
                onTap: () {},
                child: Center(child: Text('문항수')),
              ),
              AppCard(
                onTap: () {},
                child: Center(child: Text('타이머')),
              ),
              AppCard(
                onTap: () {},
                child: Center(child: Text('난이도')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
