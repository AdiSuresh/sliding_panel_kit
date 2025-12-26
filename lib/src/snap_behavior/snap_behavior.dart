import 'package:sliding_panel_kit/src/snap_config/snap_config.dart';

final class SnapBehavior {
  final SnapConfig config;

  const SnapBehavior({required this.config});

  (int, double) findNearestExtent(double current) {
    final extents = config.extents;
    if (extents case []) {
      return (-1, current);
    }
    return extents.indexed.reduce((e1, e2) {
      final (_, a) = e1;
      final (_, b) = e2;
      return (current - a).abs() < (current - b).abs() ? e1 : e2;
    });
  }

  double findNextExtent(double current, double velocity) {
    final (index, extent) = findNearestExtent(current);
    if (index case -1) {
      return current;
    }
    final SnapConfig(:extents, velocityRange: (lower, upper)) = config;
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
