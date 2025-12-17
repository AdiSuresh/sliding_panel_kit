import 'package:example/presentation/home/route/route.dart';
import 'package:example/presentation/nested_scroll/view.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class NestedScrollRoute extends GoRouteData with $NestedScrollRoute {
  const NestedScrollRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NestedScrollExample();
  }
}
