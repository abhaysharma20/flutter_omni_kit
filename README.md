# Flutter Omni Kit 🚀

A comprehensive, all-in-one Flutter toolkit providing ready-to-use media players (Video & Audio), Document Previewers (PDF, DOCX, etc.), and production-grade Dart extension methods designed specifically for real-world app development.

Say goodbye to integrating dozens of packages for basic media and utility needs. `flutter_omni_kit` provides a robust, heavily tested set of UI widgets and extensions.

## Features ✨

### 🎬 Media & Documents
- **`OmniVideoPlayer`**: A drop-in video player widget with controls (powered by `video_player` and `chewie`).
- **`OmniAudioPlayer`**: A simple, unified audio player widget (powered by `audioplayers`).
- **`OmniFilePreviewer`**: A universal file previewer that renders PDFs natively, displays images, and safely opens Word/Excel documents via the OS.

### 🛠️ Core Extensions
- **String Extensions**: Formatting (camelCase, snake_case), validations (email, URL, IPv4), masking.
- **DateTime Extensions**: Relative time (`timeAgo`), business logic (`isWeekend`, `isToday`), safe additions.
- **List & Iterable Extensions**: Chunking, distinct by selector, grouping, aggregation (`sum`, `min`, `max`).
- **Num & Duration Extensions**: Currency formatting, compact representations (`1.5M`), readable durations.
- **Utilities**: Regex validators (PAN, Aadhaar, Phone), customizable `Debouncer`, and a Stylized `Logger`.

## Installation 💻

Add `flutter_omni_kit` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_omni_kit: ^0.0.1
```

Run `flutter pub get`.

> **Note on Native Permissions**:
> Because this package handles audio, video, and documents, ensure you add the required native permissions:
> - **iOS**: `NSAppTransportSecurity` (for network media).
> - **Android**: Internet permissions, and set `minSdkVersion` to 21 or higher.

## Usage 🚀

Import the library:

```dart
import 'package:flutter_omni_kit/flutter_omni_kit.dart';
```

### Media Widgets

**Video Player**
```dart
OmniVideoPlayer(
  url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  useBackgroundValidation: true, // Validates URL in a background Isolate
)
```

**Audio Player**
```dart
OmniAudioPlayer(
  url: 'https://example.com/audio.mp3',
  useBackgroundValidation: true, // Prevents UI jank for slow DNS lookups
)
```

**File Previewer**
```dart
OmniFilePreviewer(
  filePath: '/path/to/local/file.pdf',
)
```

*(See the `DOCUMENTATION.md` for the full list of Dart extensions!)*

## License
MIT License. Feel free to use in your commercial projects!
