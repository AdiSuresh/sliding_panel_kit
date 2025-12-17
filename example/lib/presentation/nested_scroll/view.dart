import 'package:flutter/material.dart';
import 'package:sliding_panel_kit/sliding_panel_kit.dart';

class NestedScrollExample extends StatefulWidget {
  const NestedScrollExample({super.key});

  @override
  State<NestedScrollExample> createState() => _NestedScrollExampleState();
}

class _NestedScrollExampleState extends State<NestedScrollExample>
    with SingleTickerProviderStateMixin {
  late final TabController tabCtrl;

  @override
  void initState() {
    super.initState();
    tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SlidingPanelBuilder(
          snapConfig: SlidingPanelSnapConfig(extents: [0.75]),
          handle: const SlidingPanelHandle(),
          builder: (context, handle) {
            return SlidingPanelBody(
              child: Column(
                children: [
                  ?handle,
                  TabBar(
                    controller: tabCtrl,
                    tabs: List.generate(
                      3,
                      (index) => Tab(text: 'Tab ${index + 1}'),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabCtrl,
                      children: const [
                        TabContent(index: 0),
                        TabContent(index: 1),
                        TabContent(index: 2),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class TabContent extends StatelessWidget {
  final int index;

  const TabContent({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: PageStorageKey('tab-list-$index'),
      physics: const BouncingScrollPhysics(),
      itemCount: 30,
      itemBuilder: (context, index) {
        return ListTile(title: Text('Item ${index + 1}'));
      },
    );
  }
}
