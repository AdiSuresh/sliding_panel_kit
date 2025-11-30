import 'package:flutter/material.dart';
import 'package:sliding_panel_kit/sliding_panel_kit.dart';

void main() {
  runApp(const SlidingPanelApp());
}

class SlidingPanelApp extends StatelessWidget {
  const SlidingPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SlidingPanelExample());
  }
}

class SlidingPanelExample extends StatefulWidget {
  const SlidingPanelExample({super.key});

  @override
  State<SlidingPanelExample> createState() => _SlidingPanelExampleState();
}

class _SlidingPanelExampleState extends State<SlidingPanelExample>
    with TickerProviderStateMixin {
  late final SlidingPanelController controller;

  @override
  void initState() {
    super.initState();
    controller = SlidingPanelController(vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Content behind the panel
            SlidingPanelBuilder(
              controller: controller,
              snapConfig: SlidingPanelSnapConfig(sizes: [0.75]),
              handle: const SlidingPanelHandle(),
              builder: (context, handle) {
                return SlidingPanelBody(
                  child: Column(
                    children: [
                      ?handle,
                      Expanded(
                        child: ListView.builder(
                          itemCount: 25,
                          itemBuilder: (context, index) {
                            return ListTile(title: Text('Item ${index + 1}'));
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.animateTo(
            1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
      ),
    );
  }
}
