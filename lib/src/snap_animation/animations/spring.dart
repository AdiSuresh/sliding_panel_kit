part of '../snap_animation.dart';

final class SpringSnapAnimation extends SnapAnimation<SpringDescription> {
  final SpringSnapSpec spec;

  factory SpringSnapAnimation() {
    return .adaptive(duration: (200, 400), bounce: 0.2);
  }

  SpringSnapAnimation.fixed(SpringDescription spring)
    : spec = FixedSpringSnap(spring);

  SpringSnapAnimation.adaptive({
    required (int, int) duration,
    required double bounce,
  }) : spec = AdaptiveSpringSnap(duration: duration, bounce: bounce);

  @override
  SpringDescription evaluate(double pixels, double velocity) {
    switch (spec) {
      case FixedSpringSnap(:final spring):
        return spring;
      case AdaptiveSpringSnap(
        duration: (final lower, final upper),
        :final bounce,
      ):
        final speed = velocity.abs().clamp(1.0, SnapAnimation.maxSpeed);
        return SpringDescription.withDurationAndBounce(
          duration: Duration(
            milliseconds: (Duration.millisecondsPerSecond * pixels / speed)
                .round()
                .clamp(lower, upper),
          ),
          bounce: bounce,
        );
    }
  }
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
