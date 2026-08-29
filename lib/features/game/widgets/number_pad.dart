import 'package:flutter/material.dart';

class NumberPad extends StatelessWidget {
  final Function(String) onNumberTap;
  final VoidCallback onDelete;
  final VoidCallback onSubmit;

  const NumberPad({
    super.key,
    required this.onNumberTap,
    required this.onDelete,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final keys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "C", "0", "⌫"];

    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: keys.length,
        itemBuilder: (context, index) {
          final key = keys[index];

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            onPressed: () {
              if (key == '⌫') {
                onDelete;
              } else if (key == '입력') {
                onSubmit;
              } else {
                onNumberTap(key);
              }
            },
            child: Text(
              keys[index],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
