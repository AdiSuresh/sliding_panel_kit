import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_panel_kit/src/extent/extent.dart';
import 'package:sliding_panel_kit/src/snap_config/snap_config.dart';

final class SlidingPanelBuilder extends StatefulWidget {
  final SlidingPanelController controller;
  final double minSize;
  final double maxSize;
  final SlidingPanelSnapConfig snapConfig;
  final PreferredSizeWidget? handle;
  final Widget Function(BuildContext context, Widget? handle) builder;

  final double _handleHeight;

  SlidingPanelBuilder({
    super.key,
    required this.controller,
    this.minSize = 0.0,
    this.maxSize = 1.0,
    SlidingPanelSnapConfig? snapConfig,
    this.handle,
    required this.builder,
  }) : assert(
         minSize >= 0 && minSize <= 1,
         'Minimum size must be between 0.0 and 1.0 inclusive.',
       ),
       assert(
         maxSize >= 0 && minSize <= 1,
         'Maximum size must be between 0.0 and 1.0 inclusive.',
       ),
       assert(
         minSize <= maxSize,
         'Minimum size cannot be greater than maximum size.',
       ),
       snapConfig = _processSnapPointsArg(snapConfig, minSize, maxSize),
       _handleHeight = handle?.preferredSize.height ?? 0.0;

  static SlidingPanelSnapConfig _processSnapPointsArg(
    SlidingPanelSnapConfig? snapConfig,
    double minSize,
    double maxSize,
  ) {
    final sizes = {minSize, maxSize, ...?snapConfig?.sizes}.toList();
    assert(
      sizes.every((e) => e >= minSize && e <= maxSize),
      'All snapSizes must be between minSize and maxSize inclusive.',
    );
    sizes.sort();
    return switch (snapConfig) {
      null => SlidingPanelSnapConfig(sizes: sizes),
      _ => snapConfig.copyWith(sizes: sizes),
    };
  }

  SlidingPanelExtent get _extent {
    return SlidingPanelExtent(minSize: minSize, maxSize: maxSize);
  }

  @override
  State<SlidingPanelBuilder> createState() => _SlidingPanelBuilderState();
}

final class _SlidingPanelBuilderState extends State<SlidingPanelBuilder> {
  final scrollAreaTracker = _ScrollAreaTracker();
  VelocityTracker? velocityTracker;

  double get velocity {
    return velocityTracker?.getVelocity().pixelsPerSecond.dy ?? 0;
  }

  SlidingPanelController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller._extent = widget._extent;
  }

  @override
  void didUpdateWidget(covariant SlidingPanelBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newExtent = widget._extent;
    final extentChanged = oldWidget._extent != newExtent;

    final sizesChanged = !listEquals(
      oldWidget.snapConfig.sizes,
      widget.snapConfig.sizes,
    );

    if (extentChanged || sizesChanged) {
      controller._extent = newExtent;
      snap();
    }
  }

  void drag(double dy) {
    final pixels = controller.maxPixels - widget._handleHeight;
    if (pixels case 0) {
      return;
    }
    controller.jumpTo(controller.value - dy * widget.maxSize / pixels);
  }

  double findSnapPoint(double current) {
    return widget.snapConfig.sizes.reduce(
      (a, b) => (current - a).abs() < (current - b).abs() ? a : b,
    );
  }

  int findSnapPointIndex(double current) {
    return widget.snapConfig.sizes.indexOf(findSnapPoint(current));
  }

  bool isSnapPoint(double current) {
    return current == findSnapPoint(current);
  }

  Future<void> snap() async {
    final size = controller.value;
    final velocity = this.velocity;
    final index = findSnapPointIndex(size);

    final SlidingPanelBuilder(:minSize, :maxSize) = widget;

    final SlidingPanelSnapConfig(
      sizes: snapSizes,
      velocityRange: (lower, upper),
      :springDescription,
    ) = widget.snapConfig;

    var snapPoint = snapSizes[index];

    if (velocity < -upper) {
      snapPoint = maxSize;
    } else if (velocity < -lower) {
      snapPoint = snapSizes[(index + 1).clamp(0, snapSizes.length - 1)];
    } else if (velocity > upper) {
      snapPoint = minSize;
    } else if (velocity > lower) {
      snapPoint = snapSizes[(index - 1).clamp(0, snapSizes.length - 1)];
    }

    final snapToEdge = snapPoint == minSize || snapPoint == maxSize;

    switch (springDescription) {
      case != null when !snapToEdge:
        final speed = velocity.abs().clamp(0, 5000);
        await controller.animateWith(
          SpringSimulation(
            springDescription,
            size,
            snapPoint,
            speed / 5000,
            snapToEnd: true,
          ),
        );
        controller.jumpTo(snapPoint);

      case _:
        final pixels = (size - snapPoint).abs() * controller.availablePixels;
        final speed = velocity.abs().clamp(1000, 5000);
        final seconds = pixels / speed;
        await controller.animateTo(
          snapPoint,
          duration: Duration(milliseconds: (seconds * 1000).round()),
          curve: Curves.ease,
        );
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
            final value = controller.value;
            final isSnapPoint = this.isSnapPoint(value);

            if (dragDetails == null) {
              scrollAreaTracker.reset();
              if (!isSnapPoint) {
                position.correctBy(-(notification.scrollDelta ?? 0.0));
                position.hold(() {}).cancel();
              }
              break;
            }

            final dy = dragDetails.delta.dy;

            final ScrollPosition(
              :outOfRange,
              :pixels,
              :minScrollExtent,
              :correctBy,
            ) = position;

            if (outOfRange) {
              if (pixels < minScrollExtent) {
                scrollAreaTracker.reset();
                correctBy(dy < 0 ? -dy : dy);
                break;
              } else if (dy < 0) {
                scrollAreaTracker.reset();
                if (!isSnapPoint) {
                  correctBy(dy);
                }
                break;
              }
            } else if (!isSnapPoint) {
              scrollAreaTracker.reset();
              correctBy(dy);
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

                final maxHeight = availablePixels * widget.maxSize;
                final minHeight = availablePixels * widget.minSize;

                final travel = (maxHeight - minHeight) - widget._handleHeight;

                final dy = (1 - controller.normalizedValue) * travel;

                return Transform.translate(
                  offset: Offset(0, dy),
                  child: Align(
                    alignment: .bottomCenter,
                    child: ConstrainedBox(
                      constraints: constraints.copyWith(maxHeight: maxHeight),
                      child: child,
                    ),
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
  final double initialSize;
  final AnimationController _animationController;

  bool _attached = false;
  SlidingPanelExtent _extent = const SlidingPanelExtent();
  double? _availablePixels;

  SlidingPanelController({
    this.initialSize = 0.0,
    required TickerProvider vsync,
  }) : _animationController = AnimationController(vsync: vsync),
       super(initialSize);

  double get availablePixels => _availablePixels!;

  double get pixels => value * availablePixels;

  double get maxPixels => _extent.maxSize * availablePixels;

  @override
  @protected
  set value(double value) {
    super.value = value.clamp(_extent.minSize, _extent.maxSize);
  }

  double get normalizedValue {
    final range = _extent.maxSize - _extent.minSize;
    if (range == 0) {
      return 0;
    }
    return (value - _extent.minSize) / range;
  }

  @override
  void dispose() {
    _detach();
    _animationController.dispose();
    super.dispose();
  }

  void jumpTo(double size) {
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
    value = size;
  }

  Future<void> animateTo(
    double size, {
    required Duration duration,
    required Curve curve,
  }) async {
    if (_animationController.isAnimating) {
      _animationController.stop();
    }

    _animationController.value = value;
    _attach();

    try {
      await _animationController.animateTo(
        size,
        duration: duration,
        curve: curve,
      );
    } finally {
      _detach();
    }
  }

  Future<void> animateWith(Simulation simulation) async {
    if (_animationController.isAnimating) {
      _animationController.stop();
    }

    _animationController.value = value;
    _attach();

    try {
      await _animationController.animateWith(simulation);
    } finally {
      _detach();
    }
  }

  void _attach() {
    if (!_attached) {
      _animationController.addListener(_onTick);
      _attached = true;
    }
    _animationController.stop();
  }

  void _detach() {
    if (_attached) {
      _animationController.removeListener(_onTick);
      _attached = false;
    }
  }

  void _onTick() => value = _animationController.value;
}
