## 0.3.0
### Breaking changes
- Replaced available height based extent model with a more intuitive **content height based extent model**.
  
- Removed `maxExtent` in favor of the new content height based extent model.
  - To size the panel relative to the available height, please check out the `FractionallySizedBox` widget.

- Migrated `SlidingPanelController` to extend `ChangeNotifier`.
  - Renamed:
    - `value` to `extent`
    - `normalizedValue` to `normalizedExtent`
  - Replaced:
    - `pixels` by `dimensions`


## 0.2.0
### Added
- New `includeBoundaryExtents` flag to control whether `minExtent` and `maxExtent` are used as snap points.
- Support for scroll coordination for:
  - horizontal scroll views
  - vertical scroll views inside horizontal scroll views


## 0.1.0
### Added
- New `SnapAnimation` API to support curved and spring-based snap animations via `CurvedSnapAnimation` and `SpringSnapAnimation`.

### Breaking changes
- `springDescription` has been replaced by `animation` in `SlidingPanelSnapConfig`.

**Old:**
```dart
SlidingPanelSnapConfig(
  springDescription: SpringDescription(...)
)
```

**New:**
```dart
SlidingPanelSnapConfig(
  animation: SpringSnapAnimation.fixed(
    SpringDescription(...)
  )
)
```


## 0.0.3

### Added
- Smarter scroll coordination algorithm.


## 0.0.2+1

### Changed
- Adjust width of demo in README.md.


## 0.0.2

### Added
- Support for using the panel without providing a controller.

### Changed
- General cleanup and internal improvements.

### Breaking changes
- `SlidingPanelController` no longer requires a `vsync`. Existing code passing `vsync` must remove or update the parameter.
- Renamed all size-related API fields for clarity:
  - SlidingPanelBuilder
    - `minSize` to `minExtent`
    - `maxSize` to `maxExtent`
  - SlidingPanelSnapConfig
    - `sizes` to `extents`


## 0.0.1
- Initial release of **sliding_panel_kit**.
- Added core sliding panel widget with:
  - Drag-to-open/close gestures
  - Snap points and anchor support
  - Smooth animation and panel controller
  - Configurable panel sizes and behavior
- Included basic documentation and example.
