## 3.0.1

- Document the public API and enforce documentation coverage with
  `public_member_api_docs`.
- Declare Linux support for media selection, previews, and result generation;
  platform-specific editing and video playback remain capability-dependent.
- Keep the mobile image cropper out of Web/WASM builds through conditional
  platform implementations.

## 3.0.0

- Require Flutter 3.44 and Dart 3.12.
- Migrate from the discontinued `flutter_painter_v2` package to
  `flutter_painter`.
- Upgrade `v_platform` to `2.2.0` for safer source validation, URL handling,
  and native/web file access.
- Upgrade direct dependencies and remove unused package dependencies.
- Fix crop cancellation, image compression quality, thumbnail destinations,
  controller disposal, empty input, and async widget lifecycle handling.
- Export media metadata models and return immutable result lists.
- Replace the generated counter example and placeholder test with package usage
  and regression coverage.

## 2.2.0

- Support Flutter 3.27.

## 2.0.0

- Support Flutter 3.22.

## 1.2.1

- Upgrade dependencies.

## 1.0.0

- Support Dart 3.

## 0.4.0

- Add localization support.

## 0.3.0

- Add web support.

## 0.0.4

- Update `v_chat_utils` to 0.0.4.

## 0.0.3

- Update `v_chat_utils` to 0.0.3.

## 0.0.1

- Initial release.
