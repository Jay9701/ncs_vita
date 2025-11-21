import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // 오른쪽 위 디버그 글씨 제거
      title: 'Math Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),   // 첫 화면 연결
    );
  }
}
