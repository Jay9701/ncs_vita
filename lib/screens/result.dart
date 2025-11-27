import 'package:flutter/material.dart';
import 'package:ncs_vita/screens/home.dart';
import 'package:ncs_vita/screens/game.dart';

class Result extends StatelessWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Result")),
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
              child: Text("재도전"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home())
                );
              },
              child: Text("나가기"),
            ),
            SizedBox(height: 16),
          ]
        )
      )
    );
  }
}