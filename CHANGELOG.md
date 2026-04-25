## 0.0.5

- Fixed `unsendable object` crash when using `useBackgroundValidation: true`. Improved isolate memory safety by avoiding state capturing.

## 0.0.4

- **New UI Components**:
    - `OmniGlassCard`: A modern glassmorphism container.
    - `OmniShimmer`: Easy-to-use skeleton loading animations (ListTile, Circular, Rectangular).
- **New Infrastructure Utilities**:
    - `OmniNetwork`: Simplified API client (Dio wrapper) with connectivity checks.
    - `OmniStorage`: A clean "one-liner" local storage solution (SharedPreferences wrapper).

## 0.0.3

- Added `useBackgroundValidation` (Isolate-based) to `OmniVideoPlayer` and `OmniAudioPlayer` to validate media URLs/paths in the background and prevent main-thread jank.

## 0.0.2

- Added extensive customization options (colors, placeholders, error builders) to `OmniVideoPlayer`, `OmniAudioPlayer`, and `OmniFilePreviewer`.

## 0.0.1

- Initial version.
