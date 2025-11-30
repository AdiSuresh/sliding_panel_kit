// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snap_config.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SlidingPanelSnapConfigCWProxy {
  SlidingPanelSnapConfig sizes(List<double> sizes);

  SlidingPanelSnapConfig velocityRange((double, double) velocityRange);

  SlidingPanelSnapConfig springDescription(
    SpringDescription? springDescription,
  );

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `SlidingPanelSnapConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SlidingPanelSnapConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  SlidingPanelSnapConfig call({
    List<double> sizes,
    (double, double) velocityRange,
    SpringDescription? springDescription,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfSlidingPanelSnapConfig.copyWith(...)` or call `instanceOfSlidingPanelSnapConfig.copyWith.fieldName(value)` for a single field.
class _$SlidingPanelSnapConfigCWProxyImpl
    implements _$SlidingPanelSnapConfigCWProxy {
  const _$SlidingPanelSnapConfigCWProxyImpl(this._value);

  final SlidingPanelSnapConfig _value;

  @override
  SlidingPanelSnapConfig sizes(List<double> sizes) => call(sizes: sizes);

  @override
  SlidingPanelSnapConfig velocityRange((double, double) velocityRange) =>
      call(velocityRange: velocityRange);

  @override
  SlidingPanelSnapConfig springDescription(
    SpringDescription? springDescription,
  ) => call(springDescription: springDescription);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `SlidingPanelSnapConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SlidingPanelSnapConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  SlidingPanelSnapConfig call({
    Object? sizes = const $CopyWithPlaceholder(),
    Object? velocityRange = const $CopyWithPlaceholder(),
    Object? springDescription = const $CopyWithPlaceholder(),
  }) {
    return SlidingPanelSnapConfig(
      sizes: sizes == const $CopyWithPlaceholder() || sizes == null
          ? _value.sizes
          // ignore: cast_nullable_to_non_nullable
          : sizes as List<double>,
      velocityRange:
          velocityRange == const $CopyWithPlaceholder() || velocityRange == null
          ? _value.velocityRange
          // ignore: cast_nullable_to_non_nullable
          : velocityRange as (double, double),
      springDescription: springDescription == const $CopyWithPlaceholder()
          ? _value.springDescription
          // ignore: cast_nullable_to_non_nullable
          : springDescription as SpringDescription?,
    );
  }
}

extension $SlidingPanelSnapConfigCopyWith on SlidingPanelSnapConfig {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfSlidingPanelSnapConfig.copyWith(...)` or `instanceOfSlidingPanelSnapConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SlidingPanelSnapConfigCWProxy get copyWith =>
      _$SlidingPanelSnapConfigCWProxyImpl(this);
}
