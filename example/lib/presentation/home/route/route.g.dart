// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$homeRoute];

RouteBase get $homeRoute => GoRouteData.$route(
  path: '/',
  factory: $HomeRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: '/basic-usage',
      factory: $BasicUsageRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/custom-usage',
      factory: $CustomUsageRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/nested-scroll',
      factory: $NestedScrollRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/adaptive-sizing',
      factory: $AdaptiveSizingRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/transition-builder',
      factory: $TransitionBuilderRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/parallax-effect',
      factory: $ParallaxEffectRoute._fromState,
    ),
  ],
);

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BasicUsageRoute on GoRouteData {
  static BasicUsageRoute _fromState(GoRouterState state) =>
      const BasicUsageRoute();

  @override
  String get location => GoRouteData.$location('/basic-usage');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CustomUsageRoute on GoRouteData {
  static CustomUsageRoute _fromState(GoRouterState state) =>
      const CustomUsageRoute();

  @override
  String get location => GoRouteData.$location('/custom-usage');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $NestedScrollRoute on GoRouteData {
  static NestedScrollRoute _fromState(GoRouterState state) =>
      const NestedScrollRoute();

  @override
  String get location => GoRouteData.$location('/nested-scroll');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AdaptiveSizingRoute on GoRouteData {
  static AdaptiveSizingRoute _fromState(GoRouterState state) =>
      const AdaptiveSizingRoute();

  @override
  String get location => GoRouteData.$location('/adaptive-sizing');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $TransitionBuilderRoute on GoRouteData {
  static TransitionBuilderRoute _fromState(GoRouterState state) =>
      const TransitionBuilderRoute();

  @override
  String get location => GoRouteData.$location('/transition-builder');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ParallaxEffectRoute on GoRouteData {
  static ParallaxEffectRoute _fromState(GoRouterState state) =>
      const ParallaxEffectRoute();

  @override
  String get location => GoRouteData.$location('/parallax-effect');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
