# Flutter Omni Kit 🚀

A comprehensive, all-in-one Flutter toolkit providing ready-to-use media players, document previewers, modern UI components, network utilities, and production-grade Dart extensions.

## Features ✨

### 🎬 Media & Documents
- **`OmniVideoPlayer`**: Drop-in video player with controls and background validation.
- **`OmniAudioPlayer`**: Unified audio player with styles.
- **`OmniFilePreviewer`**: Universal previewer for PDF, Images, and more.

### 💎 Modern UI
- **`OmniGlassCard`**: Stunning frosted-glass (glassmorphism) containers.
- **`OmniShimmer`**: High-performance skeleton loading animations.

### ⚡ Infrastructure & Utilities
- **`OmniNetwork`**: Simplified API client with built-in connectivity monitoring.
- **`OmniStorage`**: Easy "one-liner" local persistence.
- **Validators & Logger**: Regex-based validations and stylized console logging.

### 🛠️ Core Extensions
- **String, DateTime, List, Num**: 100+ combined utility methods for faster development.

## Installation 💻

Add `flutter_omni_kit` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_omni_kit: ^0.0.4
```

## Usage 🚀

### Modern Glass UI
```dart
OmniGlassCard(
  blur: 15,
  opacity: 0.2,
  child: Text("Premium Glass Effect"),
)
```

### Simple API Call
```dart
final api = OmniNetwork();
api.init(baseUrl: 'https://api.example.com');

final response = await api.get('/users');
```

### One-liner Storage
```dart
await OmniStorage.init();
OmniStorage.write('isLoggedIn', true);
bool loggedIn = OmniStorage.read<bool>('isLoggedIn') ?? false;
```

---
*(Refer to `DOCUMENTATION.md` for full API details)*

## License
MIT License.
