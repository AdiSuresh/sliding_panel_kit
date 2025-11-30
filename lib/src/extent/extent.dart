// ignore_for_file: depend_on_referenced_packages
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'extent.g.dart';

@CopyWith()
final class SlidingPanelExtent with EquatableMixin {
  final double minSize;
  final double maxSize;

  const SlidingPanelExtent({this.minSize = 0.0, this.maxSize = 1.0});

  @override
  List<Object?> get props => [minSize, maxSize];
}
