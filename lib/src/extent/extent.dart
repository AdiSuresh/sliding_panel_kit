final class SlidingPanelExtent {
  final double minSize;
  final double maxSize;

  const SlidingPanelExtent({this.minSize = 0.0, this.maxSize = 1.0});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SlidingPanelExtent &&
        other.minSize == minSize &&
        other.maxSize == maxSize;
  }

  @override
  int get hashCode => Object.hash(minSize, maxSize);
}
