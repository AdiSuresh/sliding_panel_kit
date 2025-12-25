import 'package:example/presentation/home/route/route.dart';
import 'package:example/presentation/adaptive_sizing/view.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class AdaptiveSizingRoute extends GoRouteData with $AdaptiveSizingRoute {
  const AdaptiveSizingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AdaptiveSizingExample();
  }
}
