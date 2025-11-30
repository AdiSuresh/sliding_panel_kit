import 'dart:collection';

// ignore: depend_on_referenced_packages
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/physics.dart';

part 'snap_config.g.dart';

@CopyWith()
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
}
