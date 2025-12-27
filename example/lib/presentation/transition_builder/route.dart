import 'package:example/presentation/home/route/route.dart';
import 'package:example/presentation/transition_builder/view.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class TransitionBuilderRoute extends GoRouteData with $TransitionBuilderRoute {
  const TransitionBuilderRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TransitionBuilderExample();
  }
}
