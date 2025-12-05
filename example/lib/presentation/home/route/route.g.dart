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
