import 'package:flutter/material.dart';

class SlidingPanelHandle extends StatelessWidget
    implements PreferredSizeWidget {
  final double width;
  final double height;
  final EdgeInsets padding;
  final Color? color;

  const SlidingPanelHandle({
    super.key,
    this.width = 32,
    this.height = 4,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.color,
  });

  @override
  Size get preferredSize {
    final width = this.width + padding.horizontal;
    final height = this.height + padding.vertical;
    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: padding,
      child: DecoratedBox(
        decoration: ShapeDecoration(shape: StadiumBorder(), color: color),
        child: SizedBox(width: width, height: height),
      ),
    );
  }
}
