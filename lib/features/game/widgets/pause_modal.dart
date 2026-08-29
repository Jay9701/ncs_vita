import 'package:flutter/material.dart';

class Pause extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onExit;

  const Pause({super.key, required this.onResume, required this.onExit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '일시정지',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onResume, child: const Text('계속하기')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: onExit, child: const Text('그만하기')),
        ],
      ),
    );
  }
}
