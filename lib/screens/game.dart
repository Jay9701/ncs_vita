import 'package:flutter/material.dart';
import 'package:ncs_vita/screens/pause.dart';
import 'package:ncs_vita/screens/result.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Game")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Pause())
                );
              },
              child: Text("정지"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Result())
                );
              },
              child: Text("결과"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {build(context);},
              child: Text("function"),
            ),
          ],
        )
      ),
    );
  }
}