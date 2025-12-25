import 'package:example/presentation/basic_usage/route.dart';
import 'package:example/presentation/custom_usage/route.dart';
import 'package:example/presentation/nested_scroll/route.dart';
import 'package:example/presentation/adaptive_sizing/route.dart';
import 'package:example/presentation/parallax_effect/route.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sliding Panel Kit Examples')),
      body: ListView(
        children: [
          ListTile(
            leading: Text('1.'),
            title: Text('Basic Usage'),
            onTap: () {
              const BasicUsageRoute().go(context);
            },
          ),
          ListTile(
            leading: Text('2.'),
            title: Text('Custom Usage'),
            onTap: () {
              const CustomUsageRoute().go(context);
            },
          ),
          ListTile(
            leading: Text('3.'),
            title: Text('Nested Scroll'),
            onTap: () {
              const NestedScrollRoute().go(context);
            },
          ),
          ListTile(
            leading: Text('4.'),
            title: Text('Adaptive Sizing'),
            onTap: () {
              const AdaptiveSizingRoute().go(context);
            },
          ),
          ListTile(
            leading: Text('5.'),
            title: Text('Parallax Effect'),
            onTap: () {
              const ParallaxEffectRoute().go(context);
            },
          ),
        ],
      ),
    );
  }
}
