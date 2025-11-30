import 'package:example/presentation/basic_usage/route.dart';
import 'package:example/presentation/custom_snapping/route.dart';
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
            title: Text('Custom Snapping'),
            onTap: () {
              const CustomSnappingRoute().go(context);
            },
          ),
          ListTile(
            leading: Text('3.'),
            title: Text('Parallax'),
            onTap: () {
              // context.go();
            },
          ),
        ],
      ),
    );
  }
}
