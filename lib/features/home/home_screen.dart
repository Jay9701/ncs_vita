import 'package:flutter/material.dart';
import 'package:ncs_vita/features/game/models/game_config.dart';
import 'package:ncs_vita/features/game/game_screen.dart';
import 'package:ncs_vita/features/home/tabs/practice_tab.dart';
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
    const ProfileTab(),
    const Setting(), // setting.dart에 Setting 위젯이 있다고 가정
  ];

  void _startGame(config) {
    // TODO: 나중에 mode/level 같은 config를 여기서 만들어서 넘기면 됨.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Game(config: config)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _index, children: _tabs),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
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
    );
  }
}

/// 게임 시작 타입(연습/검정) 구분용
enum PlayType { practice, exam }

/// ------------------------------
/// 아래는 "탭 화면" placeholder.
/// 너가 이미 탭 화면을 따로 만들 생각이면 파일로 빼도 됨.
/// ------------------------------

class ExamTab extends StatelessWidget {
  const ExamTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () {}, child: const Text('검정 시작')),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('내정보(추후 구현)')));
  }
}
