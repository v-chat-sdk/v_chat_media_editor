# Repository Guidelines

## Project Structure & Module Organization

The package entry point is `lib/v_chat_media_editor.dart`; keep consumer-facing exports routed through this barrel. Shared models, configuration, file utilities, and platform helpers live in `lib/src/core/`. Editor features are grouped under `lib/src/modules/`: `home/` coordinates selection and results, `pinter/` contains image painting, and `video_editor/` contains playback. Package tests belong in `test/`. The runnable sample is in `example/`, with Dart code in `example/lib/`, smoke tests in `example/test/`, and generated platform projects under its Android, iOS, web, Windows, Linux, and macOS folders.

## Flutter 3.50 verification workflow

Use the installed project-compatible Flutter 3.50/Dart 3.14 SDK. Keep direct `material_ui`/`cupertino_ui` dependencies consistent with their imports; design widgets no longer come from `flutter/material.dart` or `flutter/cupertino.dart`. Prefer neutral Flutter libraries when design widgets are unnecessary. Preserve this project's architecture and public contracts.

Resolve dependencies from each affected package root with `flutter pub get --no-example`. For a design migration, run `dart fix --apply --code=migrate_design_widgets` and review its output. After every code edit, run these commands sequentially from the affected package root:

```sh
dart fix --apply
dart format .
flutter analyze
```

Fix and format must finish before analysis or tests. Analyzer-only verification is the default. Run a focused test or build when requested or needed to prove a specific behavior change; choose the smallest useful check. Passing analysis does not prove runtime, provider, native linking, or integration behavior. Never suppress maintained-source diagnostics to obtain a pass. Preserve tool-owned generated files.

Existing web runners: `example`. When a run is requested, use the existing web development workflow with one explicitly selected target and port, then inspect it with Playwright MCP. An explicitly requested `flutter build web` is a compile check, separate from the development run. Do not add web targets merely to validate a migration.

Use a reachable physical Android device only when web is unsupported and device execution is requested. No emulator or simulator is authorized. This Linux VPS cannot execute native iOS/macOS builds or assume access to a phone attached to the Mac. Observe the global 500 MB download rule and preserve existing edits, credentials, caches, and running sessions. Do not push, publish, deploy, or run native builds without task authorization.

Use one handwritten class/widget per file; a StatefulWidget and its paired State may share a file. Apply SOLID without speculative abstractions. Keep UI, coordination, domain behavior, transport, persistence, and provider mechanics in their existing layers; use explicit types and correct async ownership/disposal. Do not impose another project’s state management or architecture.


## Coding Style & Naming Conventions

Use idiomatic, null-safe Dart with two-space indentation and formatter-managed trailing commas. Name files `snake_case.dart`, types and widgets `UpperCamelCase`, members `lowerCamelCase`, and private implementation details with a leading underscore. Prefer small reusable widgets, typed return values, and `const` constructors where possible. Keep platform branching inside existing helpers such as `VFileUtils`; do not expose new implementation files from `lib/src/` unless they are intentionally added to the public barrel.

## Testing Guidelines

Tests use `flutter_test` and must end in `_test.dart`. Organize related cases with `group`, use `test` for models/controllers, and `testWidgets` for editor interactions. Current automated coverage is minimal, so each behavior change should include a focused regression test covering success, cancellation, invalid input, and platform-specific behavior where relevant. Avoid real filesystem, picker, or network dependencies when a deterministic fake can be used.

## Commit & Pull Request Guidelines

Recent history uses short subjects such as `Support Flutter V3.27` and `update packages`; follow that concise, action-oriented style and keep each commit focused. Pull requests should explain the user-visible change, link relevant issues, list validation commands and tested platforms, and include screenshots or recordings for UI changes. Call out public API or dependency changes explicitly and update `CHANGELOG.md` when release-facing behavior changes.

## Security & Generated Files

Never commit credentials, signing material, local paths, or user media. Do not hand-edit generated plugin registrants or build output; regenerate them with Flutter tooling.

## Local package migration dependencies

The development overrides in `pubspec_overrides.yaml`, `example/pubspec_overrides.yaml` point to migrated sibling packages in the organized workspace. Keep the relative layout when developing this migration. Hosted releases may still expose legacy Material theme types. Before distributing a checkout independently, release compatible dependency versions and update its hosted constraints; do not publish local paths or force incompatible overrides.
