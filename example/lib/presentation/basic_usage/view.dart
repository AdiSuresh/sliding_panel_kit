import 'package:flutter/material.dart';
import 'package:sliding_panel_kit/sliding_panel_kit.dart';

class BasicUsageExample extends StatefulWidget {
  const BasicUsageExample({super.key});

  @override
  State<BasicUsageExample> createState() => _BasicUsageExampleState();
}

class _BasicUsageExampleState extends State<BasicUsageExample>
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
              snapConfig: SlidingPanelSnapConfig(extents: [0.75]),
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
