import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ncs_vita/features/game/models/game_config.dart';
import 'package:ncs_vita/features/game/models/game_result.dart';
import 'package:ncs_vita/features/home/home_screen.dart';
import 'package:ncs_vita/features/game/game_screen.dart';

class Result extends StatelessWidget {
  final GameResult result;

  const Result({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
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
                  child: Text("재도전"),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  },
                  child: Text("나가기"),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          // 2) 디버그 오버레이
          if (kDebugMode)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DefaultTextStyle(
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DEBUG',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        ),
                      ),
                      Text('count: ${result.config.count}'),
                      Text('currentidx: ${result.currentIdx}'),
                      Text('correctCnt: ${result.correctCnt}'),
                      Text('accuracy: ${result.accuracy}'),
                      Text('accuracyStr: ${result.accuracyStr}'),
                      Text('wrongCnt: ${result.wrongCnt}'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
