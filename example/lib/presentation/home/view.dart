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
              // context.go();
            },
          ),
          ListTile(
            leading: Text('2.'),
            title: Text('Custom Snapping'),
            onTap: () {
              // context.go();
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
