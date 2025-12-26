import 'dart:collection';
import 'package:sliding_panel_kit/src/snap_animation/snap_animation.dart';

final class SnapConfig {
  final List<double> _extents;
  final bool includeBoundaryExtents;
  final (double lower, double upper) velocityRange;
  final SnapAnimation animation;

  UnmodifiableListView<double> get extents {
    return UnmodifiableListView(_extents);
  }

  SnapConfig({
    List<double> extents = const [],
    this.includeBoundaryExtents = true,
    this.velocityRange = (500, 2500),
    this.animation = const CurvedSnapAnimation(),
  }) : _extents = List.of(extents, growable: false)..sort(),
       assert(
         extents.every((e) => e >= 0 && e <= 1),
         'All snap points must be between 0.0 and 1.0 inclusive.',
       ),
       assert(() {
         final (lower, upper) = velocityRange;
         return lower > 0 && upper > 0 && lower < upper;
       }(), 'Invalid snap velocity range was specified.');

  SnapConfig copyWith({
    List<double>? extents,
    (double lower, double upper)? velocityRange,
    SnapAnimation? animation,
  }) {
    return SnapConfig(
      extents: extents ?? _extents,
      velocityRange: velocityRange ?? this.velocityRange,
      animation: animation ?? this.animation,
    );
  }
}
