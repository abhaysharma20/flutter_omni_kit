## 0.0.14

- Fixed a critical connection leak in the background media validation isolate that prevented audio from loading.
- Made the audio seekbar robust against 0-duration streams to prevent assertion errors.
- Added a visual error icon to the audio player UI if the stream fails to load.

## 0.0.13

- Refactored `OmniAudioPlayer` to use a professional `PositionData` stream pattern with `rxdart`.
- Fixed duration sniffing for servers that omit the `Content-Length` header (like `samplelib`).
- Added buffering/loading spinners to the audio UI.

## 0.0.12

- **Major Upgrade**: Switched audio engine to `just_audio` for professional-grade streaming reliability.
- Fixed duration detection once and for all (metadata now fetches almost instantly).
- Added buffering/loading indicators to the audio player UI.

## 0.0.11

- Updated example audio to a longer, high-quality stream for better seeking and UX testing.

## 0.0.10

- Implemented "Aggressive Duration Fetching" in `OmniAudioPlayer` to resolve `00:00` duration on some devices.
- Switched example streams to W3Schools test files for maximum cross-platform compatibility.

## 0.0.9

- Fixed iOS `CoreMedia` error `-12939` (byte range length mismatch) by updating example streams to high-performance Google Cloud buckets.
- Enhanced `OmniAudioPlayer` duration detection by forcing a refresh on play.
- Updated `example/main.dart` with a complete, modern showcase application.

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
