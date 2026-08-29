import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ncs_vita/features/home/home_screen.dart';
import 'package:ncs_vita/main.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                      Text('font: ${settings.fontScale}'),
                    ],
                  ),
                ),
              ),
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    settings.setDarkMode(!settings.isDarkMode);
                  },
                  child: Text("다크모드"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    settings.setFontScale(0.8);
                  },
                  child: Text("폰트 0.8"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    settings.setFontScale(0.9);
                  },
                  child: Text("폰트 0.9"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    settings.setFontScale(1.0);
                  },
                  child: Text("폰트 1.0"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    settings.setFontScale(1.1);
                  },
                  child: Text("폰트 1.1"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    settings.setFontScale(1.2);
                  },
                  child: Text("폰트 1.2"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  },
                  child: Text("저장"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
