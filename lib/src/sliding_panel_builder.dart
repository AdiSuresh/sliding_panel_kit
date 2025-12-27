import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_panel_kit/src/snap_animation/snap_animation.dart';
import 'package:sliding_panel_kit/src/snap_behavior/snap_behavior.dart';
import 'package:sliding_panel_kit/src/snap_config/snap_config.dart';

typedef SlidingPanelTransitionBuilder =
    Widget Function(
      BuildContext context,
      ({double value, double normalized}) extent,
      Widget child,
    );

final class SlidingPanelBuilder extends StatefulWidget {
  final SlidingPanelController? controller;
  final double minExtent;
  final double initialExtent;
  final SnapBehavior _snapBehavior;
  final PreferredSizeWidget? handle;
  final Widget Function(BuildContext context, Widget? handle) builder;
  final SlidingPanelTransitionBuilder transitionBuilder;

  final double _handleHeight;

  SlidingPanelBuilder({
    super.key,
    this.controller,
    this.minExtent = 0.0,
    double? initialExtent,
    SnapConfig? snapConfig,
    this.handle,
    this.transitionBuilder = defaultTransitionBuilder,
    required this.builder,
  }) : assert(
         minExtent >= 0 && minExtent <= 1,
         'Minimum extent must be between 0.0 and 1.0 inclusive.',
       ),
       assert(switch (initialExtent) {
         null => true,
         final value => value >= minExtent && value <= 1,
       }, 'Initial extent must be between $minExtent and 1.0 inclusive.'),
       initialExtent = initialExtent ?? minExtent,
       _snapBehavior = _processSnapBehavior(snapConfig, minExtent),
       _handleHeight = handle?.preferredSize.height ?? 0.0;

  static SnapBehavior _processSnapBehavior(
    SnapConfig? snapConfig,
    double minExtent,
  ) {
    final boundaryExtents = switch (snapConfig?.includeBoundaryExtents) {
      true => [minExtent, 1.0],
      _ => <double>[],
    };
    final snapPoints = {...boundaryExtents, ...?snapConfig?.extents}.toList();
    assert(
      snapPoints.every((e) => e >= minExtent && e <= 1),
      'All snap points must be between $minExtent and 1.0 inclusive.',
    );
    snapPoints.sort();
    return SnapBehavior(
      config: switch (snapConfig) {
        null => SnapConfig(extents: snapPoints),
        _ => snapConfig.copyWith(extents: snapPoints),
      },
    );
  }

  static Widget defaultTransitionBuilder(
    BuildContext context,
    ({double value, double normalized}) extent,
    Widget child,
  ) => child;

  @override
  State<SlidingPanelBuilder> createState() => _SlidingPanelBuilderState();
}

final class _SlidingPanelBuilderState extends State<SlidingPanelBuilder>
    with SingleTickerProviderStateMixin {
  final childKey = GlobalKey();
  Size? childSize;

  final _controller = SlidingPanelController();
  late final AnimationController animationController;

  double snapPoint = 0.0;

  final pointerTracker = _PointerTracker();
  final scrollAreaTracker = _ScrollAreaTracker();
  VelocityTracker? velocityTracker;

  SlidingPanelController get controller {
    return widget.controller ?? _controller;
  }

  double get velocity {
    return velocityTracker?.getVelocity().pixelsPerSecond.dy ?? 0;
  }

  @override
  void initState() {
    super.initState();
    controller
      .._minExtent = widget.minExtent
      ..extent = widget.initialExtent;
    animationController = AnimationController(vsync: this);
    controller._attach(animationController);
    snapPoint = widget.initialExtent;

    updateChildSize();
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
        newController.extent = _controller.extent;
        _controller._detach();
        newController._attach(animationController);

      case (final SlidingPanelController oldController, null):
        _controller.extent = oldController.extent;
        oldController._detach();
        _controller._attach(animationController);

      case (final oldController, final newController)
          when identical(oldController, newController):
        break;

      case (
        final SlidingPanelController oldController,
        final SlidingPanelController newController,
      ):
        newController.extent = oldController.extent;
        oldController._detach();
        newController._attach(animationController);
    }

    final newExtent = widget.minExtent;
    final extentChanged = oldWidget.minExtent != newExtent;

    final snapPointsChanged = !listEquals(
      oldWidget._snapBehavior.config.extents,
      widget._snapBehavior.config.extents,
    );

    if (extentChanged || snapPointsChanged) {
      controller._minExtent = newExtent;
      snap();
    }

    updateChildSize();
  }

  @override
  void dispose() {
    animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void updateChildSize({bool notify = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (childKey.currentContext?.findSize()) {
        case null:
          return;

        case final value when value != childSize:
          childSize = value;
          controller._updateDimensions(value);
      }
    });
  }

  void drag(double dy) {
    final pixels = controller.dimensions.height - widget._handleHeight;
    if (pixels case 0) {
      return;
    }
    controller.jumpTo(controller.extent - dy / pixels);
  }

  Future<void> snap() async {
    final extent = controller.extent;
    final velocity = this.velocity;

    final SnapBehavior(:findNextExtent, config: SnapConfig(:animation)) =
        widget._snapBehavior;

    final snapPoint = findNextExtent(extent, velocity);

    if (snapPoint == extent) {
      this.snapPoint = snapPoint;
      return;
    }

    final SlidingPanelBuilder(:minExtent) = widget;

    final extentDiff = (snapPoint - extent).abs();
    final maxPixels = controller.dimensions.height - widget._handleHeight;
    final pixels = extentDiff * maxPixels;

    switch (animation) {
      case CurvedSnapAnimation(:final curve, :final evaluate):
        await controller.animateTo(
          snapPoint,
          duration: evaluate(pixels, velocity),
          curve: curve,
        );

      case SpringSnapAnimation(:final evaluate):
        final spring = evaluate(pixels, velocity);
        final maxSpeed = SnapAnimation.maxSpeed;
        final speed = velocity.abs().clamp(1.0, maxSpeed);
        await controller.animateWith(
          SpringSimulation(
            switch (snapPoint == minExtent || snapPoint == 1) {
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
      this.snapPoint = snapPoint;
      controller.jumpTo(snapPoint);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewId = View.of(context).viewId;
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final ScrollNotification(:metrics, :context) = notification;

        if (metrics.axis == .vertical || context == null) {
          return false;
        }

        final canScroll = [
          widget.minExtent,
          snapPoint,
          1.0,
        ].contains(controller.extent);

        if (canScroll) {
          switch (notification) {
            case ScrollStartNotification():
              scrollAreaTracker.update(context.findRect());
              pointerTracker.exceed();
              break;

            case UserScrollNotification(direction: .idle) ||
                ScrollEndNotification():
              scrollAreaTracker.reset();
              pointerTracker.reset();
              break;

            case _:
          }
        } else {
          switch (notification) {
            case ScrollUpdateNotification(:final dragDetails)
                when !metrics.outOfRange:
              final dx = dragDetails?.delta.dx;

              if (dx != null) {
                final position = Scrollable.of(context).position;
                position.correctBy(dx);
              }

              break;

            case _:
          }
        }

        return false;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final ScrollNotification(:metrics, :context) = notification;

          if (metrics.axis == .horizontal || context == null) {
            return false;
          }

          switch (notification) {
            case ScrollStartNotification(:final dragDetails):
              if (dragDetails == null) {
                break;
              }
              scrollAreaTracker.update(context.findRect());
              pointerTracker.exceed();
              break;

            case ScrollUpdateNotification(:final dragDetails):
              final position = Scrollable.of(context).position;
              final canScroll = [
                widget.minExtent,
                snapPoint,
                1.0,
              ].contains(controller.extent);

              if (dragDetails == null) {
                if (!canScroll) {
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
                    if (!canScroll) {
                      correctPixels(minScrollExtent);
                    }
                    scrollAreaTracker.reset();
                    break;
                  }
                  if (!canScroll) {
                    correctBy(correction);
                    scrollAreaTracker.reset();
                    break;
                  }
                } else {
                  if (pixels - correction <= maxScrollExtent) {
                    if (!canScroll) {
                      correctPixels(maxScrollExtent);
                    }
                    scrollAreaTracker.reset();
                    break;
                  }
                  if (!canScroll) {
                    correctBy(-correction);
                    scrollAreaTracker.reset();
                    break;
                  }
                }
              } else if (!canScroll) {
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

            case OverscrollNotification():
              scrollAreaTracker.reset();
              break;

            case _:
              scrollAreaTracker.reset();
              pointerTracker.reset();
          }

          return false;
        },
        child: Listener(
          onPointerDown: (event) {
            pointerTracker.start(context, event);
            velocityTracker = VelocityTracker.withKind(event.kind);
            drag(event.delta.dy);
          },
          onPointerMove: (event) {
            if (scrollAreaTracker.contains(event.position)) {
              return;
            }

            velocityTracker?.addPosition(event.timeStamp, event.position);

            if (!pointerTracker.update(viewId, event)) {
              return;
            }

            drag(event.delta.dy);
          },
          onPointerUp: (event) {
            pointerTracker.reset();
            if (!scrollAreaTracker.contains(event.position)) {
              snap();
            }
            scrollAreaTracker.reset();
          },
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final dimensions = childSize;

                  final pixels = dimensions?.height ?? 0.0;

                  final contentPixels = pixels - widget._handleHeight;
                  final minContentPixels = contentPixels * widget.minExtent;

                  final travel = contentPixels - minContentPixels;

                  final dy = (1 - controller.normalizedExtent) * travel;

                  return Offstage(
                    offstage: dimensions == null,
                    child: Transform.translate(
                      offset: Offset(0, dy),
                      child: Align(
                        alignment: .bottomCenter,
                        child: RepaintBoundary(
                          child: widget.transitionBuilder(
                            context,
                            (
                              value: controller._extent,
                              normalized: controller.normalizedExtent,
                            ),
                            ConstrainedBox(
                              constraints: constraints,
                              child: child,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: NotificationListener<SizeChangedLayoutNotification>(
              onNotification: (notification) {
                updateChildSize();
                return true;
              },
              child: SizeChangedLayoutNotifier(
                key: childKey,
                child: widget.builder(context, widget.handle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on BuildContext {
  RenderBox get _box {
    return findRenderObject() as RenderBox;
  }

  Size findSize() {
    return _box.size;
  }

  Rect findRect() {
    final box = _box;
    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;

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

final class _PointerTracker {
  static const maxDistance = kTouchSlop + 1e-6;

  double _distance = 0.0;

  _PointerTracker();

  bool isOverScrollable(BuildContext context, Offset position) {
    final view = View.of(context);
    final result = HitTestResult();

    WidgetsBinding.instance.hitTestInView(result, position, view.viewId);

    for (final entry in result.path) {
      if (entry.target case RenderAbstractViewport()) {
        return true;
      }
    }

    return false;
  }

  void start(BuildContext context, PointerDownEvent event) {
    if (isOverScrollable(context, event.position)) {
      return;
    }
    exceed();
  }

  bool update(int viewId, PointerMoveEvent event) {
    if (_distance >= maxDistance) {
      return true;
    }
    _distance += event.delta.distance;
    return false;
  }

  void exceed() {
    _distance = maxDistance;
  }

  void reset() {
    _distance = 0.0;
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

final class SlidingPanelController extends ChangeNotifier {
  double _extent;
  double _minExtent = 0.0;

  Size? _dimensions;

  AnimationController? _animationController;

  SlidingPanelController([this._extent = 0.0]);

  Size get dimensions => _dimensions!;

  double get extent {
    return _extent;
  }

  @protected
  set extent(double newExtent) {
    newExtent = newExtent.clamp(_minExtent, 1.0);
    if (newExtent == _extent) {
      return;
    }
    _extent = newExtent;
    notifyListeners();
  }

  void _updateDimensions(Size? newDimensions) {
    if (newDimensions == _dimensions) {
      return;
    }
    _dimensions = newDimensions;
    notifyListeners();
  }

  double get normalizedExtent {
    final range = 1 - _minExtent;
    if (range == 0) {
      return 1;
    }
    return (_extent - _minExtent) / range;
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
    this.extent = extent;
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
      ..value = _extent
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
      extent = value;
    }
  }
}
