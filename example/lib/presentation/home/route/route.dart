import 'package:example/presentation/basic_usage/route.dart';
import 'package:example/presentation/custom_usage/route.dart';
import 'package:example/presentation/home/view.dart';
import 'package:example/presentation/nested_scroll/route.dart';
import 'package:example/presentation/adaptive_sizing/route.dart';
import 'package:example/presentation/parallax_effect/route.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

part 'route.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<BasicUsageRoute>(path: '/basic-usage'),
    TypedGoRoute<CustomUsageRoute>(path: '/custom-usage'),
    TypedGoRoute<NestedScrollRoute>(path: '/nested-scroll'),
    TypedGoRoute<AdaptiveSizingRoute>(path: '/adaptive-sizing'),
    TypedGoRoute<ParallaxEffectRoute>(path: '/parallax-effect'),
  ],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return HomePage();
  }
}
