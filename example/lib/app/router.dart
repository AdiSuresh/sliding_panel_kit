import 'package:example/presentation/home/route/route.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _instance = AppRouter._();

  final router = GoRouter(
    initialLocation: const HomeRoute().location,
    routes: $appRoutes,
    debugLogDiagnostics: true,
  );

  AppRouter._();

  factory AppRouter() {
    return _instance;
  }

  Uri get uri {
    return router.routeInformationProvider.value.uri;
  }
}
