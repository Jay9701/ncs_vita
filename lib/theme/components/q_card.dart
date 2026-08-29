import 'package:flutter/material.dart';
import 'package:ncs_vita/theme/font.dart';

class QCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? borderColor;

  const QCard({super.key, required this.child, this.onTap, this.borderColor});

  @override
  Widget build(BuildContext context) {
    final bool hasBorder = borderColor != null;
    final bool isCorrect = borderColor == Colors.green;

    // ⭐ 더 세련된 색상 정의
    final Color successColor = Colors.green;
    final Color errorColor = Colors.red;
    final Color activeColor = isCorrect ? successColor : errorColor;

    Widget card = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (hasBorder)
            BoxShadow(
              color: activeColor.withValues(alpha: 0.30),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
            width: 10,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Center(
          heightFactor: 1,
          child: DefaultTextStyle(style: context.fonts.fraction, child: child),
        ),
      ),
    );

    if (onTap != null) {
      card = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: card,
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        if (hasBorder)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: activeColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.5),
                    blurRadius: 6,
                    // offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                isCorrect ? Icons.check : Icons.close,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
      ],
    );
  }
}
