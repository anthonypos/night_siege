# Conventions

- Prefer app/game implementation in Dart under `lib/`; avoid changing generated platform host files unless the task is platform integration, packaging, permissions, or runner behavior.
- Keep using Flutter/Material patterns until a game architecture is introduced; the current app is template Material counter UI.
- Follow `flutter_lints` defaults; no project-specific lint suppressions or style overrides are active.
- Use `const` constructors where Flutter lints expect them.
- Dart SDK is new enough for shorthand member syntax; preserve existing `.fromSeed(...)` / `.center` style unless broader style rules change.
- Do not manually edit `.metadata`; Flutter tool owns it.
- If the README’s Flame game direction becomes implementation work, add the actual Flame package(s) to `pubspec.yaml` before writing Flame APIs.