import 'package:example/presentation/basic_usage/view.dart';
import 'package:example/presentation/home/route/route.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class CustomSnappingRoute extends GoRouteData with $CustomSnappingRoute {
  const CustomSnappingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BasicUsageExample();
  }
}
