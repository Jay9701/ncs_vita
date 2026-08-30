import 'package:flutter/material.dart';
import 'package:ncs_vita/features/game/models/game_config.dart';
import 'package:ncs_vita/features/game/game_screen.dart';
import 'package:ncs_vita/features/home/tabs/exam_tab.dart';
import 'package:ncs_vita/features/home/tabs/practice_tab.dart';
import 'package:ncs_vita/features/home/tabs/sample_tab.dart';
import 'package:ncs_vita/features/home/tabs/setting_tab.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;

  // 탭 화면들: 여기만 나중에 네 실제 화면으로 바꿔 끼우면 됨.
  late final List<Widget> _tabs = [
    Practice(onStart: (config) => _startGame(config)),
    const ExamTab(),
    SampleTab(),
    const Setting(), // setting.dart에 Setting 위젯이 있다고 가정
  ];

  void _startGame(GameConfig config) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Game(config: config)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textScale = MediaQuery.textScalerOf(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: IndexedStack(index: _index, children: _tabs),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.18),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: colors.surface,
          selectedItemColor: colors.primary,
          unselectedItemColor: colors.onSurface.withValues(alpha: 0.6),
          selectedFontSize: textScale.scale(12).clamp(11.0, 14.0),
          unselectedFontSize: textScale.scale(12).clamp(11.0, 14.0),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: '연습',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined),
              activeIcon: Icon(Icons.timer),
              label: '검정',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: '내정보',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: '설정',
            ),
          ],
        ),
      ),
    );
  }
}

/// 게임 시작 타입(연습/검정) 구분용
enum PlayType { practice, exam }
