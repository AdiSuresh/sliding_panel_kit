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
  }) : _extents = List.of(extents)..sort(),
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

  (int, double) findNearestExtent(double current) {
    return extents.indexed.reduce((e1, e2) {
      final (_, a) = e1;
      final (_, b) = e2;
      return (current - a).abs() < (current - b).abs() ? e1 : e2;
    });
  }

  double findNextExtent(double current, double velocity) {
    final (lower, upper) = velocityRange;
    final (index, extent) = findNearestExtent(current);
    final maxExtentIndex = extents.length - 1;
    final ranges = [
      ((double.negativeInfinity, -upper), maxExtentIndex),
      ((-upper, -lower), index + 1),
      ((-lower, lower), index),
      ((lower, upper), index - 1),
      ((upper, double.infinity), 0),
    ];
    final range = ranges.firstWhere((element) {
      final ((lower, upper), _) = element;
      return velocity > lower && velocity <= upper;
    });
    final (_, resultIndex) = range;
    return extents[resultIndex.clamp(0, maxExtentIndex)];
  }
}
