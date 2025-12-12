part of '../snap_animation.dart';

final class SpringSnapAnimation extends SnapAnimation {
  final SpringSnapSpec spec;

  factory SpringSnapAnimation() {
    return .fromDurationAndBounce(duration: (200, 400), bounce: 0.25);
  }

  SpringSnapAnimation.fromDescription(SpringDescription springDescription)
    : spec = SpringSnapFromDescription(springDescription);

  SpringSnapAnimation.fromDurationAndBounce({
    required (int, int) duration,
    required double bounce,
  }) : spec = SpringSnapFromDurationAndBounce(
         duration: duration,
         bounce: bounce,
       );
}

sealed class SpringSnapSpec {
  const SpringSnapSpec();
}

final class SpringSnapFromDescription extends SpringSnapSpec {
  final SpringDescription springDescription;

  const SpringSnapFromDescription(this.springDescription);
}

final class SpringSnapFromDurationAndBounce extends SpringSnapSpec {
  final (int, int) duration;
  final double bounce;

  const SpringSnapFromDurationAndBounce({
    required this.duration,
    required this.bounce,
  });
}
