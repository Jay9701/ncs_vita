import 'package:flutter/material.dart';
import 'package:ncs_vita/theme/font.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const AppCard({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: DefaultTextStyle(style: context.fonts.title1, child: child),
      ),
    );

    if (onTap != null) {
      card = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}

class QCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? borderColor;

  const QCard({super.key, required this.child, this.onTap, this.borderColor});

  @override
  Widget build(BuildContext context) {
    final hasBorder = borderColor != null;
    final isCorrect = borderColor == Colors.green;

    const successColor = Colors.green;
    const errorColor = Colors.red;
    final activeColor = isCorrect ? successColor : errorColor;

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

class CardLabel extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;
  final double spacing;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  final double fontSize;

  const CardLabel({
    super.key,
    required this.label,
    this.icon,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
    this.spacing = 6,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.iconSize = 14,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconColor = iconColor ?? Colors.white70;
    final resolvedTextColor = textColor ?? Colors.white;
    final resolvedBackground =
        backgroundColor ?? Colors.white.withValues(alpha: 0.08);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: resolvedBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: resolvedIconColor),
            SizedBox(width: spacing),
          ],
          Text(
            label,
            style: TextStyle(
              color: resolvedTextColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;
  final Color? titleColor;
  final Color? valueColor;
  final Color? backgroundColor;
  final double? titleFontSize;
  final double? valueFontSize;
  final int valueMaxLines;
  final bool centerValue;
  final EdgeInsetsGeometry padding;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
    this.titleColor,
    this.valueColor,
    this.backgroundColor,
    this.titleFontSize,
    this.valueFontSize,
    this.valueMaxLines = 1,
    this.centerValue = false,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final resolvedTitleColor =
        titleColor ?? colors.onSurface.withValues(alpha: 0.6);
    final resolvedValueColor = valueColor ?? colors.onSurface;
    final resolvedBackground = backgroundColor ?? colors.surface;

    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: resolvedBackground,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize:
                      titleFontSize ??
                      MediaQuery.textScalerOf(
                        context,
                      ).scale(12).clamp(11.0, 13.0),
                  color: resolvedTitleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Align(
                alignment: centerValue
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: Text(
                  value,
                  maxLines: valueMaxLines,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  textAlign: centerValue ? TextAlign.center : TextAlign.start,
                  style: TextStyle(
                    fontSize:
                        valueFontSize ??
                        MediaQuery.textScalerOf(
                          context,
                        ).scale(20).clamp(17.0, 24.0),
                    fontWeight: FontWeight.bold,
                    color: resolvedValueColor,
                  ),
                ),
              ),
            ],
          ),
          if (onTap != null)
            Positioned(
              top: -2,
              right: -2,
              child: Icon(
                Icons.settings_outlined,
                size: 17,
                color: resolvedTitleColor.withValues(alpha: 0.7),
              ),
            ),
        ],
      ),
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: card,
      ),
    );
  }
}
