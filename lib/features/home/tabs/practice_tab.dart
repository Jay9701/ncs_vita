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
      int prev = (config.level - 1).clamp(1, 10);
      config = config.copyWith(level: prev);
      debugPrint('config::: ${config.level}');
    });
  }

  void _nextLevel() {
    setState(() {
      int next = (config.level + 1).clamp(1, 10);
      config = config.copyWith(level: next);
      debugPrint('config::: ${config.level}');
    });
  }

  void _prevCount() {
    setState(() {
      int prev = (config.count - 1).clamp(10, 30);
      config = config.copyWith(count: prev);
      debugPrint('config::: ${config.count}');
    });
  }

  void _nextCount() {
    setState(() {
      int next = (config.count + 1).clamp(10, 30);
      config = config.copyWith(count: next);
      debugPrint('config::: ${config.count}');
    });
  }

  void _prevType() {
    setState(() {
      GameType prev = config.type.prev;
      config = config.copyWith(type: prev);
      debugPrint('config::: ${config.type}');
    });
  }

  void _nextType() {
    setState(() {
      GameType next = config.type.next;
      config = config.copyWith(type: next);
      debugPrint('config::: ${config.type}');
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
              child: Center(child: Text('연습 시작')),
            ),
          ),

          const SizedBox(height: 16),

          // ===== 하단 카드 그리드 =====
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppCard(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Center(child: Text('유형')),
                    SizedBox(height: 15),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_left),
                            onPressed: _prevType,
                            // 아이콘 크기나 색상을 바꾸고 싶을 때
                            iconSize: 30,
                            color: Colors.blue,
                          ),
                          Text(
                            '${config.type.label}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_right),
                            onPressed: _nextType,
                            // 아이콘 크기나 색상을 바꾸고 싶을 때
                            iconSize: 30,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Center(child: Text('난이도')),
                    SizedBox(height: 15),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_left),
                            onPressed: _prevLevel,
                            // 아이콘 크기나 색상을 바꾸고 싶을 때
                            iconSize: 30,
                            color: Colors.blue,
                          ),
                          Text(
                            '${config.level}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_right),
                            onPressed: _nextLevel,
                            // 아이콘 크기나 색상을 바꾸고 싶을 때
                            iconSize: 30,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Center(child: Text('문항수')),
                    SizedBox(height: 15),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_left),
                            onPressed: _prevCount,
                            // 아이콘 크기나 색상을 바꾸고 싶을 때
                            iconSize: 30,
                            color: Colors.blue,
                          ),
                          Text(
                            '${config.count}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_right),
                            onPressed: _nextCount,
                            // 아이콘 크기나 색상을 바꾸고 싶을 때
                            iconSize: 30,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                onTap: () {},
                child: Center(child: Text('타이머')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
