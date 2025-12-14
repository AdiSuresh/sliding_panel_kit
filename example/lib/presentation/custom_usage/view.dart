import 'package:flutter/material.dart';
import 'package:sliding_panel_kit/sliding_panel_kit.dart';

class CustomUsageExample extends StatefulWidget {
  const CustomUsageExample({super.key});

  @override
  State<CustomUsageExample> createState() => _CustomUsageExampleState();
}

class _CustomUsageExampleState extends State<CustomUsageExample> {
  final controller = SlidingPanelController();

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
              snapConfig: SlidingPanelSnapConfig(
                extents: [0.75],
                velocityRange: (400, 2400),
                animation: SpringSnapAnimation.fixed(
                  SpringDescription(mass: 1, stiffness: 350, damping: 30),
                ),
              ),
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
