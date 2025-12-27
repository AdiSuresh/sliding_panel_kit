import 'package:flutter/material.dart';
import 'package:sliding_panel_kit/sliding_panel_kit.dart';

class TransitionBuilderExample extends StatefulWidget {
  const TransitionBuilderExample({super.key});

  @override
  State<TransitionBuilderExample> createState() =>
      _TransitionBuilderExampleState();
}

class _TransitionBuilderExampleState extends State<TransitionBuilderExample> {
  final controller = SlidingPanelController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actions = [
      ('Edit', Icons.edit),
      ('Share', Icons.share),
      ('Archive', Icons.archive),
      ('Delete', Icons.delete),
    ];
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: .center,
          children: [
            ElevatedButton(
              onPressed: () {
                controller.animateTo(
                  1,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              child: Text('Show panel'),
            ),
            SlidingPanelBuilder(
              controller: controller,
              snapConfig: SnapConfig(),
              transitionBuilder: (context, extent, child) {
                const minExtent = 0.7;
                final opacity = switch (extent.normalized) {
                  > minExtent => 1.0,
                  final value => value / minExtent,
                };
                return Opacity(opacity: opacity, child: child);
              },
              builder: (context, handle) {
                return FractionallySizedBox(
                  widthFactor: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SlidingPanelBody(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          const SlidingPanelHandle(),
                          Material(
                            type: .transparency,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (final (title, icon) in actions)
                                    Builder(
                                      builder: (context) {
                                        final color = switch (icon) {
                                          Icons.delete => Colors.red.shade400,
                                          _ => null,
                                        };
                                        return ListTile(
                                          leading: Icon(icon, color: color),
                                          title: Text(
                                            title,
                                            style: .new(color: color),
                                          ),
                                          onTap: () {},
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
