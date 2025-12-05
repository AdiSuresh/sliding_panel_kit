final class SlidingPanelExtent {
  final double minExtent;
  final double maxExtent;

  const SlidingPanelExtent({this.minExtent = 0.0, this.maxExtent = 1.0});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SlidingPanelExtent &&
        other.minExtent == minExtent &&
        other.maxExtent == maxExtent;
  }

  @override
  int get hashCode => Object.hash(minExtent, maxExtent);

  double get range => maxExtent - minExtent;
}
