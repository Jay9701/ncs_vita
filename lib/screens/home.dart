import 'package:flutter/material.dart';
import 'package:ncs_vita/models/game_config.dart';
import 'package:ncs_vita/screens/setting.dart';
import 'game.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Game(config: const GameConfig()),
                  ),
                );
              },
              child: Text("연습 모드"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Game(config: const GameConfig().set(level: 4)),
                  ),
                );
              },
              child: Text("검정 시작"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Setting()),
                );
              },
              child: Text("환경 설정"),
            ),
          ],
        ),
      ),
    );
  }
}
