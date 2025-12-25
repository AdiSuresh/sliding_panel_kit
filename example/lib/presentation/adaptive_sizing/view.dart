import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sliding_panel_kit/sliding_panel_kit.dart';

class AdaptiveSizingExample extends StatefulWidget {
  const AdaptiveSizingExample({super.key});

  @override
  State<AdaptiveSizingExample> createState() => _AdaptiveSizingExampleState();
}

class _AdaptiveSizingExampleState extends State<AdaptiveSizingExample> {
  static const initialSize = 250.0;

  final controller = SlidingPanelController();

  final random = Random();
  final dimension = ValueNotifier(initialSize);

  @override
  void dispose() {
    controller.dispose();
    dimension.dispose();
    super.dispose();
  }

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
                    dimension.value = initialSize + random.nextDouble() * 100;
                  },
                  child: Text('Update Size'),
                ),
              ],
            ),
            SlidingPanelBuilder(
              controller: controller,
              handle: const SlidingPanelHandle(),
              snapConfig: SlidingPanelSnapConfig(
                extents: [0.75],
                animation: SpringSnapAnimation(),
              ),
              builder: (context, handle) {
                return FractionallySizedBox(
                  widthFactor: 1,
                  child: SlidingPanelBody(
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        ?handle,
                        ValueListenableBuilder(
                          valueListenable: dimension,
                          builder: (context, value, child) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              constraints: BoxConstraints.tight(
                                Size.square(value),
                              ),
                              child: child,
                            );
                          },
                          child: const ColoredBox(color: Colors.blue),
                        ),
                      ],
                    ),
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
