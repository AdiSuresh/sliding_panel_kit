import 'dart:collection';
import 'package:flutter/physics.dart';

final class SlidingPanelSnapConfig {
  final List<double> _extents;
  final (double lower, double upper) velocityRange;
  final SpringDescription? springDescription;

  UnmodifiableListView<double> get extents {
    return UnmodifiableListView(_extents);
  }

  SlidingPanelSnapConfig({
    List<double> extents = const [],
    this.velocityRange = (500, 2500),
    this.springDescription,
  }) : _extents = extents,
       assert(
         extents.every((e) => e >= 0 && e <= 1),
         'All snap points must be between 0.0 and 1.0 inclusive.',
       ),
       assert(() {
         final (lower, upper) = velocityRange;
         return lower > 0 && upper > 0 && lower < upper;
       }(), 'Invalid snap velocity range was specified.');

  SlidingPanelSnapConfig copyWith({
    List<double>? extents,
    (double lower, double upper)? velocityRange,
    SpringDescription? springDescription,
  }) {
    return SlidingPanelSnapConfig(
      extents: extents ?? _extents,
      velocityRange: velocityRange ?? this.velocityRange,
      springDescription: springDescription ?? this.springDescription,
    );
  }
}
