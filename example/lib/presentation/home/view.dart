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
      body: Column(
        mainAxisAlignment: .center,
        children: [
          ListTile(
            title: Text('Basic Usage'),
            onTap: () {
              // context.go();
            },
          ),
          ListTile(
            title: Text('Custom Snapping'),
            onTap: () {
              // context.go();
            },
          ),
          ListTile(
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
