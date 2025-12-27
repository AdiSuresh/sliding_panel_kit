import 'package:example/app/core/extensions/go_route.dart';
import 'package:example/presentation/home/route/route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final routes = $appRoutes.first.routes.cast<GoRoute>();
    return Scaffold(
      appBar: AppBar(title: Text('Sliding Panel Kit Examples')),
      body: ListView(
        children: [
          for (final (i, route) in routes.indexed)
            ListTile(
              leading: Text((i + 1).toString()),
              title: Text(route.title),
              onTap: () {
                context.go(route.path);
              },
            ),
        ],
      ),
    );
  }
}
