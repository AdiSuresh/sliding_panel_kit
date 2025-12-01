# Sliding Panel Kit

A simple and lightweight solution for building sliding-up panel for Flutter with smooth drag gestures, snap-points, and built-in scroll coordination for scrollable content.

## Features

**Build custom sliding-up panel**
- Easily build a panel that slides up from the bottom of the screen.
- Includes optional UI components like `SlidingPanelHandle` and `SlidingPanelBody`.

**Drag from anywhere**
- The entire panel surface is draggable by default.
- Add a drag handle for visual guidance if desired.

**Automatic scroll hand-off**
- Embed scrollable content (ListView, GridView, CustomScrollView, etc.) inside the panel.
- Overscroll smoothly expands or collapses the panel, similar to Google Maps or Apple Music.

**Snap-point system**
- Supports multiple snap points with spring-based snapping.
- Automatically snaps to the nearest point when released.


## Getting started

Install the package by running this command:

```bash
flutter pub get sliding_panel_kit
```


## Usage

The kit contains two core components:

1) `SlidingPanelBuilder`
2) `SlidingPanelController`

You also get two widgets:
1) `SlidingPanelHandle`
2) `SlidingPanelBody`

They can be combined and used as follows:

### Step 1:

Import the package:

```dart
import 'package:sliding_panel_kit/sliding_panel_kit.dart';
```


### Step 2:

Create the panel controller:

```dart
class _SlidingPanelExampleState extends State<SlidingPanelExample> with TickerProviderStateMixin {
  late final SlidingPanelController controller;
  
  ...
  
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

  ...
}
```


### Step 3:

Adding the panel:

```dart
class _SlidingPanelExampleState extends State<SlidingPanelExample>
    with TickerProviderStateMixin {

...
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Content behind the panel
          SlidingPanelBuilder(
            controller: controller,
            builder: (context, handle) {
              return SlidingPanelBody(
                child: ListView.builder(
                  itemCount: 25,
                  itemBuilder: (_, i) => ListTile(
                    title: Text('Item ${i + 1}'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
```


### Step 4:

Add a drag handle:

```dart
SlidingPanelBuilder(
  controller: controller,
  handle: const SlidingPanelHandle(),
  builder: (context, handle) {
    return SlidingPanelBody(
      child: Column(
        children: [
          if (handle != null) handle,
          Expanded(
            child: ListView.builder(
              itemCount: 25,
              itemBuilder: (_, i) => ListTile(
                title: Text('Item ${i + 1}'),
              ),
            ),
          ),
        ],
      ),
    );
  },
),
```


### Step 5:

Add a snap point:

```dart
SlidingPanelBuilder(
  controller: controller,
  snapConfig: SlidingPanelSnapConfig(sizes: [0.75]), // minSize and maxSize already included
  ...
)
```


### Step 6:

Programmatically open the panel:

```dart
FloatingActionButton(
  onPressed: () {
    controller.animateTo(
      1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  },
)
```
For the complete example, see [`basic_usage/view.dart`](https://github.com/AdiSuresh/sliding_panel_kit/blob/master/example/lib/presentation/basic_usage/view.dart).

Here are some other examples:
- [`Spring-based snapping`](https://github.com/AdiSuresh/sliding_panel_kit/blob/master/example/lib/presentation/custom_snapping/view.dart)
- [`Parallax effect`](https://github.com/AdiSuresh/sliding_panel_kit/blob/master/example/lib/presentation/parallax_effect/view.dart)


## Future work

Support for the following features is planned:
- Sliding panel route
- Panel docking positions

## Contributing

If you run into issues or have ideas for improvements, please file an issue on GitHub:

https://github.com/AdiSuresh/sliding_panel_kit/issues

Contributions are welcome! If you’d like to improve the package, feel free to submit a pull request.
