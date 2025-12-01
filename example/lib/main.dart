import 'package:example/app/router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.lightBlue,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      contrastLevel: -0.1,
    );
    return MaterialApp.router(
      routerConfig: AppRouter().router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2.5,
        ),
      ),
    );
  }
}
