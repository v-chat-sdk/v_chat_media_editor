# Repository Guidelines

## Project Structure & Module Organization

The package entry point is `lib/v_chat_media_editor.dart`; keep consumer-facing exports routed through this barrel. Shared models, configuration, file utilities, and platform helpers live in `lib/src/core/`. Editor features are grouped under `lib/src/modules/`: `home/` coordinates selection and results, `pinter/` contains image painting, and `video_editor/` contains playback. Package tests belong in `test/`. The runnable sample is in `example/`, with Dart code in `example/lib/`, smoke tests in `example/test/`, and generated platform projects under its Android, iOS, web, Windows, Linux, and macOS folders.

## Build, Test, and Development Commands

- `flutter pub get` installs package dependencies.
- `dart format lib test example/lib example/test` formats maintained Dart sources.
- `flutter analyze` applies the rules from `flutter_lints` through `analysis_options.yaml`.
- `flutter test` runs package tests; use `flutter test --coverage` when reviewing coverage.
- `cd example && flutter pub get && flutter run` launches the demonstration app on a selected device.
- `flutter pub publish --dry-run` checks package metadata and archive contents without publishing.

## Coding Style & Naming Conventions

Use idiomatic, null-safe Dart with two-space indentation and formatter-managed trailing commas. Name files `snake_case.dart`, types and widgets `UpperCamelCase`, members `lowerCamelCase`, and private implementation details with a leading underscore. Prefer small reusable widgets, typed return values, and `const` constructors where possible. Keep platform branching inside existing helpers such as `VFileUtils`; do not expose new implementation files from `lib/src/` unless they are intentionally added to the public barrel.

## Testing Guidelines

Tests use `flutter_test` and must end in `_test.dart`. Organize related cases with `group`, use `test` for models/controllers, and `testWidgets` for editor interactions. Current automated coverage is minimal, so each behavior change should include a focused regression test covering success, cancellation, invalid input, and platform-specific behavior where relevant. Avoid real filesystem, picker, or network dependencies when a deterministic fake can be used.

## Commit & Pull Request Guidelines

Recent history uses short subjects such as `Support Flutter V3.27` and `update packages`; follow that concise, action-oriented style and keep each commit focused. Pull requests should explain the user-visible change, link relevant issues, list validation commands and tested platforms, and include screenshots or recordings for UI changes. Call out public API or dependency changes explicitly and update `CHANGELOG.md` when release-facing behavior changes.

## Security & Generated Files

Never commit credentials, signing material, local paths, or user media. Do not hand-edit generated plugin registrants or build output; regenerate them with Flutter tooling.
