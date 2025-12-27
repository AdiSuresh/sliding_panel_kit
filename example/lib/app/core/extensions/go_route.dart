import 'package:go_router/go_router.dart';

extension GoRouteExtension on GoRoute {
  String get title {
    final uri = Uri(path: path);
    return _toTitleCase(uri.pathSegments.last.replaceAll('-', ' '));
  }

  String _toTitleCase(String input) {
    return input.replaceAllMapped(
      RegExp(r'\b\w'),
      (match) => match.group(0)!.toUpperCase(),
    );
  }
}
