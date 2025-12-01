import 'package:example/presentation/home/route/route.dart';
import 'package:example/presentation/parallax_effect/view.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ParallaxEffectRoute extends GoRouteData with $ParallaxEffectRoute {
  const ParallaxEffectRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ParallaxEffectExample();
  }
}
