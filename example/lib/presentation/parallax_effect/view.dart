import 'package:flutter/material.dart';
import 'package:sliding_panel_kit/sliding_panel_kit.dart';

class ParallaxEffectExample extends StatefulWidget {
  const ParallaxEffectExample({super.key});

  @override
  State<ParallaxEffectExample> createState() => _ParallaxEffectExampleState();
}

class _ParallaxEffectExampleState extends State<ParallaxEffectExample> {
  final controller = SlidingPanelController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              final progress = controller.normalizedExtent;
              const pixels = 16;
              final offset = progress * pixels;

              return Positioned.fill(
                child: Transform.translate(
                  offset: Offset(0, offset),
                  child: child,
                ),
              );
            },
            child: Transform.scale(
              scale: 1.25,
              child: Image.asset('assets/mountain.jpg', fit: BoxFit.cover),
            ),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              final progress = controller.normalizedExtent;
              final offset = progress * 64;

              return Transform.translate(
                offset: Offset(0, -offset),
                child: child,
              );
            },
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Center(
                  child: Icon(
                    Icons.flutter_dash,
                    size: 64,
                    color: Colors.lightBlue,
                  ),
                ),
                Text(
                  'Hello World',
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          SafeArea(
            child: SlidingPanelBuilder(
              controller: controller,
              snapConfig: SlidingPanelSnapConfig(
                extents: [0.75],
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
                      Expanded(child: ListView(children: [])),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
