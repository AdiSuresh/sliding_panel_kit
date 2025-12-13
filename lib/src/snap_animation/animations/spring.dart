part of '../snap_animation.dart';

final class SpringSnapAnimation extends SnapAnimation {
  final SpringSnapSpec spec;

  factory SpringSnapAnimation() {
    return .adaptive(duration: (200, 400), bounce: 0.25);
  }

  SpringSnapAnimation.fixed(SpringDescription spring)
    : spec = FixedSpringSnap(spring);

  SpringSnapAnimation.adaptive({
    required (int, int) duration,
    required double bounce,
  }) : spec = AdaptiveSpringSnap(duration: duration, bounce: bounce);
}

sealed class SpringSnapSpec {
  const SpringSnapSpec();
}

final class FixedSpringSnap extends SpringSnapSpec {
  final SpringDescription spring;

  const FixedSpringSnap(this.spring);
}

final class AdaptiveSpringSnap extends SpringSnapSpec {
  final (int, int) duration;
  final double bounce;

  const AdaptiveSpringSnap({required this.duration, required this.bounce});
}
