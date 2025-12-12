import 'package:flutter/animation.dart';

part 'animations/curved.dart';
part 'animations/spring.dart';

sealed class SnapAnimation {
  static const maxSpeed = 5000.0;

  const SnapAnimation();
}
