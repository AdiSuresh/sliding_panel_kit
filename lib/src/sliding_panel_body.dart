import 'package:flutter/material.dart';

final class SlidingPanelBody extends StatelessWidget {
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final BorderRadius borderRadius;
  final Widget child;

  const SlidingPanelBody({
    super.key,
    this.color,
    this.boxShadow,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(28)),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = this.color ?? colorScheme.surfaceContainerLowest;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: boxShadow ?? [
            BoxShadow(color: colorScheme.shadow, blurRadius: 8, spreadRadius: -4),
        ],
      ),
      child: ClipRRect(borderRadius: borderRadius, child: child),
    );
  }
}
