## 0.0.8

- Updated `OmniAudioPlayer` to use the modern `UrlSource` API (fixing playback and duration issues).
- Added detailed error reporting to `OmniVideoPlayer` UI for easier debugging of network/native issues.

## 0.0.7

- Fully resolved `unsendable object` crash by refactoring isolate calls into static methods, ensuring no state capturing occurs.

## 0.0.6

- Fixed `00:00` duration issue in `OmniAudioPlayer` by adding a manual duration fetch fallback.
- Improved `useBackgroundValidation` compatibility by using `GET` headers instead of `HEAD` requests.
- Made background validation non-blocking to allow native player fallbacks.

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
