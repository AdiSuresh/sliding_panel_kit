import 'package:flutter/material.dart';
import 'package:sliding_panel_kit/sliding_panel_kit.dart';

class ParallaxEffectExample extends StatefulWidget {
  const ParallaxEffectExample({super.key});

  @override
  State<ParallaxEffectExample> createState() => _ParallaxEffectExampleState();
}

class _ParallaxEffectExampleState extends State<ParallaxEffectExample>
    with SingleTickerProviderStateMixin {
  late final SlidingPanelController panelCtrl;

  @override
  void initState() {
    super.initState();
    panelCtrl = SlidingPanelController(vsync: this);
  }

  @override
  void dispose() {
    panelCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: panelCtrl,
            builder: (context, child) {
              final progress = panelCtrl.normalizedValue;
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
            animation: panelCtrl,
            builder: (context, child) {
              final progress = panelCtrl.normalizedValue;
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
              controller: panelCtrl,
              snapConfig: SlidingPanelSnapConfig(
                extents: [0.75],
                springDescription: SpringDescription(
                  mass: 1.2,
                  stiffness: 300,
                  damping: 30,
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
