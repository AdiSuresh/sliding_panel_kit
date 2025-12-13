import 'package:flutter/animation.dart';

part 'animations/curved.dart';
part 'animations/spring.dart';

sealed class SnapAnimation<T extends Object> {
  static const maxSpeed = 5000.0;

  const SnapAnimation();

  T evaluate(double pixels, double velocity);
}
