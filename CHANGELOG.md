## 0.0.2

### Added
- Support for using the panel without providing a controller.

### Changed
- General cleanup and internal improvements.

### Breaking changes
- `SlidingPanelController` no longer requires a `vsync`. Existing code passing `vsync` must remove or update the parameter.
- Renamed all size-related API fields for clarity:
  - SlidingPanelBuilder
    - minSize → minExtent
    - maxSize → maxExtent
  - SlidingPanelSnapConfig
    - sizes → extents
