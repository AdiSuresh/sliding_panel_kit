import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_panel_kit/src/extent/extent.dart';
import 'package:sliding_panel_kit/src/snap_animation/snap_animation.dart';
import 'package:sliding_panel_kit/src/snap_config/snap_config.dart';

final class SlidingPanelBuilder extends StatefulWidget {
  final SlidingPanelController? controller;
  final double minExtent;
  final double maxExtent;
  final double initialExtent;
  final SlidingPanelSnapConfig snapConfig;
  final PreferredSizeWidget? handle;
  final Widget Function(BuildContext context, Widget? handle) builder;

  final double _handleHeight;

  SlidingPanelBuilder({
    super.key,
    this.controller,
    this.minExtent = 0.0,
    this.maxExtent = 1.0,
    double? initialExtent,
    SlidingPanelSnapConfig? snapConfig,
    this.handle,
    required this.builder,
  }) : assert(
         minExtent >= 0 && minExtent <= 1,
         'Minimum extent must be between 0.0 and 1.0 inclusive.',
       ),
       assert(
         maxExtent >= 0 && maxExtent <= 1,
         'Maximum extent must be between 0.0 and 1.0 inclusive.',
       ),
       assert(
         minExtent <= maxExtent,
         'Minimum extent cannot be greater than maximum extent.',
       ),
       assert(
         switch (initialExtent) {
           null => true,
           final value => value >= minExtent && value <= maxExtent,
         },
         'Initial extent must be between $minExtent and $maxExtent inclusive.',
       ),
       initialExtent = initialExtent ?? minExtent,
       snapConfig = _processSnapPointsArg(snapConfig, minExtent, maxExtent),
       _handleHeight = handle?.preferredSize.height ?? 0.0;

  static SlidingPanelSnapConfig _processSnapPointsArg(
    SlidingPanelSnapConfig? snapConfig,
    double minExtent,
    double maxExtent,
  ) {
    final snapPoints = {minExtent, maxExtent, ...?snapConfig?.extents}.toList();
    assert(
      snapPoints.every((e) => e >= minExtent && e <= maxExtent),
      'All snap points must be between $minExtent and $maxExtent inclusive.',
    );
    snapPoints.sort();
    return switch (snapConfig) {
      null => SlidingPanelSnapConfig(extents: snapPoints),
      _ => snapConfig.copyWith(extents: snapPoints),
    };
  }

  SlidingPanelExtent get _extent {
    return SlidingPanelExtent(minExtent: minExtent, maxExtent: maxExtent);
  }

  @override
  State<SlidingPanelBuilder> createState() => _SlidingPanelBuilderState();
}

final class _SlidingPanelBuilderState extends State<SlidingPanelBuilder>
    with SingleTickerProviderStateMixin {
  final _controller = SlidingPanelController();
  late final AnimationController animationController;

  final scrollAreaTracker = _ScrollAreaTracker();
  VelocityTracker? velocityTracker;

  SlidingPanelController get controller {
    return widget.controller ?? _controller;
  }

  double get velocity {
    return velocityTracker?.getVelocity().pixelsPerSecond.dy ?? 0;
  }

  bool get atEdge {
    final value = controller.value;
    final SlidingPanelBuilder(:minExtent, :maxExtent) = widget;
    return value == minExtent || value == maxExtent;
  }

  @override
  void initState() {
    super.initState();
    controller
      .._extent = widget._extent
      ..value = widget.initialExtent;
    animationController = AnimationController(vsync: this);
    controller._attach(animationController);
  }

  @override
  void didUpdateWidget(covariant SlidingPanelBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldController = oldWidget.controller;
    final newController = widget.controller;

    switch ((oldController, newController)) {
      case (null, null):
        break;

      case (null, final SlidingPanelController newController):
        newController.value = _controller.value;
        _controller._detach();
        newController._attach(animationController);

      case (final SlidingPanelController oldController, null):
        _controller.value = oldController.value;
        oldController._detach();
        _controller._attach(animationController);

      case (final oldController, final newController)
          when identical(oldController, newController):
        break;

      case (
        final SlidingPanelController oldController,
        final SlidingPanelController newController,
      ):
        newController.value = oldController.value;
        oldController._detach();
        newController._attach(animationController);
    }

    final newExtent = widget._extent;
    final extentChanged = oldWidget._extent != newExtent;

    final snapPointsChanged = !listEquals(
      oldWidget.snapConfig.extents,
      widget.snapConfig.extents,
    );

    if (extentChanged || snapPointsChanged) {
      controller._extent = newExtent;
      snap();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void drag(double dy) {
    final pixels = controller.maxPixels - widget._handleHeight;
    if (pixels case 0) {
      return;
    }
    controller.jumpTo(controller.value - dy * widget.maxExtent / pixels);
  }

  bool isSnapPoint(double current) {
    final (_, nearestExtent) = widget.snapConfig.findNearestExtent(current);
    return current == nearestExtent;
  }

  Future<void> snap() async {
    final extent = controller.value;
    final velocity = this.velocity;

    final SlidingPanelSnapConfig(:findNextExtent, :animation) =
        widget.snapConfig;

    final snapPoint = findNextExtent(extent, velocity);

    if (snapPoint == extent) {
      return;
    }

    final SlidingPanelBuilder(:minExtent, :maxExtent) = widget;

    final snapToEdge = snapPoint == minExtent || snapPoint == maxExtent;

    final extentDiff = (snapPoint - extent).abs();
    final maxPixels = controller.maxPixels - widget._handleHeight;
    final pixels = extentDiff * maxPixels;

    switch (animation) {
      case CurvedSnapAnimation(:final curve, evaluate: final findDuration):
        await controller.animateTo(
          snapPoint,
          duration: findDuration(pixels, velocity),
          curve: curve,
        );

      case SpringSnapAnimation(:final evaluate):
        final spring = evaluate(pixels, velocity);
        final maxSpeed = SnapAnimation.maxSpeed;
        final speed = velocity.abs().clamp(1.0, maxSpeed);
        await controller.animateWith(
          SpringSimulation(
            switch (snapToEdge) {
              true => .withDurationAndBounce(
                duration: spring.duration,
                bounce: 0,
              ),
              _ => spring,
            },
            extent,
            snapPoint,
            speed / maxSpeed,
          ),
        );
    }

    if (animationController.isCompleted) {
      controller.jumpTo(snapPoint);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final ScrollNotification(:metrics, :context) = notification;

        if (metrics.axis == Axis.horizontal || context == null) {
          return false;
        }

        switch (notification) {
          case ScrollStartNotification():
            scrollAreaTracker.update(context.findRect());
            break;

          case ScrollUpdateNotification(:final dragDetails):
            final position = Scrollable.of(context).position;
            final atSnapPoint = isSnapPoint(controller.value);

            if (dragDetails == null) {
              scrollAreaTracker.reset();
              if (!atSnapPoint) {
                position.correctBy(-(notification.scrollDelta ?? 0.0));
                position.hold(() {}).cancel();
              }
              break;
            }

            final dy = dragDetails.delta.dy;

            final ScrollPosition(
              :outOfRange,
              :axisDirection,
              :pixels,
              :minScrollExtent,
              :maxScrollExtent,
              :correctPixels,
              :correctBy,
            ) = position;

            if (outOfRange) {
              final correction = dy.abs();
              if (pixels < minScrollExtent) {
                if (pixels + correction >= minScrollExtent) {
                  if (!atSnapPoint) {
                    correctPixels(minScrollExtent);
                  }
                  scrollAreaTracker.reset();
                  break;
                }
                if (!atSnapPoint) {
                  correctBy(correction);
                  scrollAreaTracker.reset();
                  break;
                }
              } else {
                if (pixels - correction <= maxScrollExtent) {
                  if (!atSnapPoint) {
                    correctPixels(maxScrollExtent);
                  }
                  scrollAreaTracker.reset();
                  break;
                }
                if (!atSnapPoint) {
                  correctBy(-correction);
                  scrollAreaTracker.reset();
                  break;
                }
              }
            } else if (!atSnapPoint) {
              final correction = !axisDirection.reverse ? dy : -dy;
              final newPixels = pixels + correction;
              if (newPixels < minScrollExtent) {
                correctPixels(minScrollExtent);
              } else if (newPixels > maxScrollExtent) {
                correctPixels(maxScrollExtent);
              } else {
                correctBy(correction);
              }
              scrollAreaTracker.reset();
              break;
            }

            scrollAreaTracker.update(context.findRect());
            break;

          case UserScrollNotification(direction: != .idle):
            break;

          case _:
            scrollAreaTracker.reset();
        }

        return false;
      },
      child: Listener(
        onPointerDown: (event) {
          velocityTracker = VelocityTracker.withKind(event.kind);
          drag(event.delta.dy);
        },
        onPointerMove: (event) {
          if (scrollAreaTracker.contains(event.position)) {
            return;
          }

          velocityTracker?.addPosition(event.timeStamp, event.position);
          drag(event.delta.dy);
        },
        onPointerUp: (event) {
          snap();
        },
        child: ValueListenableBuilder<double>(
          valueListenable: controller,
          builder: (context, value, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final availablePixels = constraints.biggest.height;

                controller._availablePixels = availablePixels;

                final maxHeight = availablePixels * widget.maxExtent;
                final minHeight = availablePixels * widget.minExtent;

                final travel = (maxHeight - minHeight) - widget._handleHeight;

                final dy = (1 - controller.normalizedValue) * travel;

                return Transform.translate(
                  offset: Offset(0, dy),
                  child: ConstrainedBox(
                    constraints: constraints.copyWith(maxHeight: maxHeight),
                    child: child,
                  ),
                );
              },
            );
          },
          child: widget.builder(context, widget.handle),
        ),
      ),
    );
  }
}

extension on BuildContext {
  Rect findRect() {
    final renderObject = findRenderObject() as RenderBox;
    final offset = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;

    return Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
  }
}

extension on AxisDirection {
  bool get reverse {
    if (this case .up || .left) {
      return true;
    }
    return false;
  }
}

final class _ScrollAreaTracker {
  static const _initialState = Rect.zero;

  Rect _state = _initialState;

  _ScrollAreaTracker();

  void update(Rect rect) {
    _state = rect;
  }

  void reset() {
    update(_initialState);
  }

  bool contains(Offset offset) {
    return _state.contains(offset);
  }
}

final class SlidingPanelController extends ValueNotifier<double> {
  AnimationController? _animationController;

  SlidingPanelExtent _extent = const SlidingPanelExtent();
  double? _availablePixels;

  SlidingPanelController() : super(0.0);

  double get availablePixels => _availablePixels!;

  double get pixels => value * availablePixels;

  double get maxPixels => _extent.maxExtent * availablePixels;

  @override
  @protected
  set value(double newValue) {
    super.value = newValue.clamp(_extent.minExtent, _extent.maxExtent);
  }

  double get normalizedValue {
    final range = _extent.range;
    if (range == 0) {
      return 0;
    }
    return (value - _extent.minExtent) / range;
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  void jumpTo(double extent) {
    _animationController
      ?..stop()
      ..removeListener(_onTick);
    value = extent;
  }

  Future<void> animateTo(
    double extent, {
    required Duration duration,
    required Curve curve,
  }) async {
    final animationController = _animationController;
    if (animationController == null) {
      return;
    }

    _prepareForAnimation();

    try {
      await animationController.animateTo(
        extent,
        duration: duration,
        curve: curve,
      );
    } finally {
      animationController.removeListener(_onTick);
    }
  }

  Future<void> animateWith(Simulation simulation) async {
    final animationController = _animationController;
    if (animationController == null) {
      return;
    }

    _prepareForAnimation();

    try {
      await animationController.animateWith(simulation);
    } finally {
      animationController.removeListener(_onTick);
    }
  }

  void _prepareForAnimation() {
    _animationController
      ?..stop()
      ..value = value
      ..addListener(_onTick);
  }

  void _attach(AnimationController controller) {
    _animationController = controller;
  }

  void _detach() {
    _animationController?.removeListener(_onTick);
    _animationController = null;
  }

  void _onTick() {
    if (_animationController?.value case final double value) {
      this.value = value;
    }
  }
}
