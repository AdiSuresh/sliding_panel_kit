import 'package:example/presentation/home/route/route.dart';
import 'package:example/presentation/content_driven_sizing/view.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ContentDrivenSizingRoute extends GoRouteData
    with $ContentDrivenSizingRoute {
  const ContentDrivenSizingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ContentDrivenSizingExample();
  }
}
