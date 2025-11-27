import 'package:flutter/material.dart';
import 'package:ncs_vita/screens/home.dart';
import 'package:ncs_vita/screens/game.dart';

class Pause extends StatelessWidget {
  const Pause({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pause")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Game())
                );
              },
              child: Text("계속"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Game())
                );
              },
              child: Text("재시도"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home())
                );
              },
              child: Text("홈으로"),
            ),
          ],
        )
      ),
    );
  }
}