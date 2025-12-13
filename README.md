# Sliding Panel Kit

A simple and lightweight solution for building sliding-up panels for Flutter with smooth drag gestures, snap-points, and built-in scroll coordination for scrollable content.

## Preview

<img src="assets/demo.gif" width="300">


## Features

**Build custom sliding-up panels**
- Easily build panels that slides up from the bottom of the screen.
- Includes optional widgets like `SlidingPanelHandle` and `SlidingPanelBody`.

**Optional controller**

- Panel works with or without a controller.
- Use a controller only when you need to programmatically control the panel.

**Drag from anywhere**
- The entire panel surface is draggable by default.
- Add a drag handle for visual guidance if desired.

**Automatic scroll hand-off**
- Embed scrollable content (`ListView`, `GridView`, `CustomScrollView`, etc.) inside the panel.
- Overscroll smoothly expands or collapses the panel, similar to Google Maps or Apple Music.

**Snap-point system**
- Automatically snaps to the nearest point when released.
- Supports option to configure spring-based snapping.

## Important note

The API is under active development and may introduce breaking changes.

## Getting Started

Install the package by running this command:

```bash
flutter pub get sliding_panel_kit
```


## Usage

Here's a brief overview of the available components:

| Component | Purpose |
| - | - |
| `SlidingPanelBuilder` | Builds the sliding panel and manages drag, snapping, and scroll coordination. |
| `SlidingPanelController` | Controls the extent of the panel programmatically. |
| `SlidingPanelHandle` | Visually indicates that the panel can be dragged. |
| `SlidingPanelBody` | Wraps the panel’s content with background, shadow, and rounded corners. |


They can be combined and used as follows:

### Step 1:

Import the package:

```dart
import 'package:sliding_panel_kit/sliding_panel_kit.dart';
```


### Step 2:

Adding the panel:

```dart
class _SlidingPanelExampleState extends State<SlidingPanelExample> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Content behind the panel
            SlidingPanelBuilder(
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
      ),
    );
  }
}
```


### Step 3:

Add a drag handle:

```dart
SlidingPanelBuilder(
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


### Step 4:

Add a snap point:

```dart
SlidingPanelBuilder(
  snapConfig: SlidingPanelSnapConfig(extents: [0.75]), // minExtent & maxExtent already included
  ...
)
```

The panel now drags and snaps without needing a controller.


### Step 5:

Add a controller (optional):

a. Create a controller:

```dart
class _SlidingPanelExampleState extends State<SlidingPanelExample> {
  final controller = SlidingPanelController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  ...
}
```

b. Provide the controller to the panel.

```dart
SlidingPanelBuilder(
  controller: controller,
  ...
)
```

### Step 6:

Programmatically control the panel:

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
- [`Spring-based snapping`](https://github.com/AdiSuresh/sliding_panel_kit/blob/master/example/lib/presentation/custom_usage/view.dart)
- [`Parallax effect`](https://github.com/AdiSuresh/sliding_panel_kit/blob/master/example/lib/presentation/parallax_effect/view.dart)


## Future Work

Support for the following features is planned:
- Sliding panel route
- Panel docking positions

## Contributing

If you run into issues or have ideas for improvements, please file an issue on GitHub:

https://github.com/AdiSuresh/sliding_panel_kit/issues

Contributions are welcome! If you’d like to improve the package, feel free to submit a pull request.
