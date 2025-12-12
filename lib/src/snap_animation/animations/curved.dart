part of '../snap_animation.dart';

final class CurvedSnapAnimation extends SnapAnimation {
  final Curve curve;
  final (int, int)? duration;
  final double minSpeed;

  const CurvedSnapAnimation({
    this.curve = Curves.ease,
    this.duration = (200, 400),
    this.minSpeed = 1000,
  });

  Duration findDuration(double pixels, double velocity) {
    final speed = velocity.abs().clamp(minSpeed, SnapAnimation.maxSpeed);
    final ms = (Duration.millisecondsPerSecond * pixels / speed).round();
    final clampedMs = switch (duration) {
      null => ms,
      (final lower, final upper) => ms.clamp(lower, upper),
    };
    return Duration(milliseconds: clampedMs);
  }
}
