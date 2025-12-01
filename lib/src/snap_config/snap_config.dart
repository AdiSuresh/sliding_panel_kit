import 'dart:collection';
import 'package:flutter/physics.dart';

final class SlidingPanelSnapConfig {
  final List<double> _sizes;
  final (double lower, double upper) velocityRange;
  final SpringDescription? springDescription;

  UnmodifiableListView<double> get sizes => UnmodifiableListView(_sizes);

  SlidingPanelSnapConfig({
    List<double> sizes = const [],
    this.velocityRange = (500, 2500),
    this.springDescription,
  }) : _sizes = sizes,
       assert(
         sizes.every((e) => e >= 0 && e <= 1),
         'All snapSizes must be between 0.0 and 1.0 inclusive.',
       ),
       assert(() {
         final (lower, upper) = velocityRange;
         return lower > 0 && upper > 0 && lower < upper;
       }(), 'Invalid snap velocity range was specified.');

  SlidingPanelSnapConfig copyWith({
    List<double>? sizes,
    (double lower, double upper)? velocityRange,
    SpringDescription? springDescription,
  }) {
    return SlidingPanelSnapConfig(
      sizes: sizes ?? _sizes,
      velocityRange: velocityRange ?? this.velocityRange,
      springDescription: springDescription ?? this.springDescription,
    );
  }
}
