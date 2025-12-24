import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sliding_panel_kit/sliding_panel_kit.dart';

class ContentDrivenSizingExample extends StatefulWidget {
  const ContentDrivenSizingExample({super.key});

  @override
  State<ContentDrivenSizingExample> createState() =>
      _ContentDrivenSizingExampleState();
}

class _ContentDrivenSizingExampleState
    extends State<ContentDrivenSizingExample> {
  static const initialSize = 250.0;

  final controller = SlidingPanelController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final random = Random();
  double dimension = initialSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: .center,
          children: [
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dimension = initialSize + random.nextDouble() * 100;
                    });
                  },
                  child: Text('Update Size'),
                ),
              ],
            ),
            SlidingPanelBuilder(
              controller: controller,
              handle: const SlidingPanelHandle(),
              snapConfig: SlidingPanelSnapConfig(
                extents: [.75],
                animation: SpringSnapAnimation(),
              ),
              builder: (context, handle) {
                return SlidingPanelBody(
                  child: Column(
                    mainAxisSize: .min,
                    children: [
                      ?handle,
                      AnimatedContainer(
                        duration: Duration(milliseconds: 150),
                        constraints: BoxConstraints.tight(
                          Size.square(dimension),
                        ),
                        child: ColoredBox(color: Colors.blue),
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
            1,
            duration: Duration(milliseconds: 150),
            curve: Curves.ease,
          );
        },
      ),
    );
  }
}
