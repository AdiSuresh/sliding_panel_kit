import 'package:example/presentation/custom_usage/view.dart';
import 'package:example/presentation/home/route/route.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class CustomUsageRoute extends GoRouteData with $CustomUsageRoute {
  const CustomUsageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CustomUsageExample();
  }
}
