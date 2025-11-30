// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extent.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SlidingPanelExtentCWProxy {
  SlidingPanelExtent minSize(double minSize);

  SlidingPanelExtent maxSize(double maxSize);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `SlidingPanelExtent(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SlidingPanelExtent(...).copyWith(id: 12, name: "My name")
  /// ```
  SlidingPanelExtent call({double minSize, double maxSize});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfSlidingPanelExtent.copyWith(...)` or call `instanceOfSlidingPanelExtent.copyWith.fieldName(value)` for a single field.
class _$SlidingPanelExtentCWProxyImpl implements _$SlidingPanelExtentCWProxy {
  const _$SlidingPanelExtentCWProxyImpl(this._value);

  final SlidingPanelExtent _value;

  @override
  SlidingPanelExtent minSize(double minSize) => call(minSize: minSize);

  @override
  SlidingPanelExtent maxSize(double maxSize) => call(maxSize: maxSize);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `SlidingPanelExtent(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SlidingPanelExtent(...).copyWith(id: 12, name: "My name")
  /// ```
  SlidingPanelExtent call({
    Object? minSize = const $CopyWithPlaceholder(),
    Object? maxSize = const $CopyWithPlaceholder(),
  }) {
    return SlidingPanelExtent(
      minSize: minSize == const $CopyWithPlaceholder() || minSize == null
          ? _value.minSize
          // ignore: cast_nullable_to_non_nullable
          : minSize as double,
      maxSize: maxSize == const $CopyWithPlaceholder() || maxSize == null
          ? _value.maxSize
          // ignore: cast_nullable_to_non_nullable
          : maxSize as double,
    );
  }
}

extension $SlidingPanelExtentCopyWith on SlidingPanelExtent {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfSlidingPanelExtent.copyWith(...)` or `instanceOfSlidingPanelExtent.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SlidingPanelExtentCWProxy get copyWith =>
      _$SlidingPanelExtentCWProxyImpl(this);
}
