import 'package:flutter/material.dart';

final class SlidingPanelBody extends StatelessWidget {
  final Color? color;
  final Color? shadowColor;
  final BorderRadius borderRadius;
  final Widget child;

  const SlidingPanelBody({
    super.key,
    this.color,
    this.shadowColor,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(28)),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = this.color ?? colorScheme.surfaceContainerLowest;
    final shadowColor = this.shadowColor ?? colorScheme.shadow;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 8, spreadRadius: -4),
        ],
      ),
      child: ClipRRect(borderRadius: borderRadius, child: child),
    );
  }
}
