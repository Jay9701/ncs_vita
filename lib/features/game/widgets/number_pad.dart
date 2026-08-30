import 'package:flutter/material.dart';
import 'package:ncs_vita/theme/font.dart';

class NumberPad extends StatelessWidget {
  final Function(String) onNumberTap;
  final VoidCallback onDelete;
  final VoidCallback? onClear;

  const NumberPad({
    super.key,
    required this.onNumberTap,
    required this.onDelete,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final keys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "C", "0", "⌫"];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;
        final padding = compact ? 8.0 : 10.0;
        final spacing = compact ? 6.0 : 8.0;
        final keypadHeight = (MediaQuery.sizeOf(context).height * 0.28).clamp(
          152.0,
          220.0,
        );
        final keyHeight = (keypadHeight - (padding * 2) - (spacing * 3)) / 4;
        final buttonFontSize = context
            .scaleText(compact ? 16.0 : 18.0)
            .clamp(14.0, 20.0);

        return SizedBox(
          height: keypadHeight,
          child: Container(
            padding: EdgeInsets.all(padding),
            child: GridView.builder(
              shrinkWrap: false,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: keyHeight,
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
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
                    if (key == 'C') {
                      onClear?.call();
                    } else if (key == '⌫') {
                      onDelete();
                    } else {
                      onNumberTap(key);
                    }
                  },
                  child: Text(
                    key,
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
