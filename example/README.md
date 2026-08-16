# V Chat Media Editor Example

This app demonstrates selecting multiple attachments, opening
`VMediaEditorView`, and reading the typed editor results.

```sh
flutter pub get
flutter run
```

Choose a device with file-picker support. Image cropping is available on
Android and iOS; drawing is disabled on web. The result list shows image
dimensions, video duration, or the selected file name after submission. Native
builds require iOS 14.0 or macOS 11.0 and newer.
