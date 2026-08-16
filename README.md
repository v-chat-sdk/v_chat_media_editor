# V Chat Media Editor

A Flutter package for previewing attachments, drawing on images, cropping
supported images, generating video thumbnails, and returning typed media
metadata before upload.

## Features

- Preview path-, byte-, asset-, and URL-based media.
- Draw text, shapes, and freehand annotations on local images.
- Crop local images on Android and iOS.
- Generate thumbnails and read durations for local videos.
- Return image, video, and generic-file results through one typed API.

## Requirements

- Flutter 3.44 or newer
- Dart 3.12 or newer
- iOS 14.0 or newer
- macOS 11.0 or newer

## Installation

```yaml
dependencies:
  v_chat_media_editor: ^3.0.0
  v_platform: ^2.2.0
```

`v_platform` provides the `VPlatformFile` objects accepted by the editor.

## Usage

```dart
final result = await Navigator.of(context).push<List<VBaseMediaRes>>(
  MaterialPageRoute(
    builder: (_) => VMediaEditorView(
      files: selectedFiles,
      config: const VMediaEditorConfig(
        imageQuality: 75,
        startCompressAt: 1_500_000,
      ),
    ),
  ),
);

for (final media in result ?? const <VBaseMediaRes>[]) {
  switch (media) {
    case VMediaImageRes image:
      debugPrint('${image.data.width} × ${image.data.height}');
    case VMediaVideoRes video:
      debugPrint(video.data.durationFormat);
    case VMediaFileRes file:
      debugPrint(file.data.name);
  }
}
```

See [`example/`](example/) for multi-file selection and a complete result UI.

## Configuration

| Option | Default | Purpose |
| --- | ---: | --- |
| `imageQuality` | `50` | Image-compression and thumbnail quality (`0`–`100`). |
| `startCompressAt` | `1,500,000` | Compression threshold in bytes. |
| `destVideoThumbFile` | `null` | Optional output path for generated thumbnails. |
| `maxVideoSizeMb` | `100` | Reserved for future video-compression validation. |

Unsupported editing actions are disabled where possible. Image drawing is
currently disabled on web, while cropping is limited to Android and iOS.
Video playback availability follows the platforms supported by `video_player`.
Linux supports selection, image/file previews, and typed result generation;
native video playback and image editing depend on the installed plugins.

## Development

```sh
flutter pub get
dart format lib test example/lib example/test
flutter analyze
flutter test
```

Report issues in the [GitHub issue tracker](https://github.com/v-chat-sdk/v_chat_media_editor/issues).
