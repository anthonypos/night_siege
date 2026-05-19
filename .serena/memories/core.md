# Core

- Flutter app project `night_siege`; README intent is a top-down zombie survival/base-defense game: day scavenging, safehouse fortification, night attacks until dawn.
- Current implementation is still the default Flutter counter scaffold in `lib/main.dart`; `test/widget_test.dart` is the matching counter smoke test.
- Source map:
  - `lib/`: Dart app code and real game/application surface.
  - `test/`: Flutter widget tests.
  - `android/`, `ios/`, `linux/`, `macos/`, `web/`, `windows/`: generated Flutter platform hosts; treat as platform integration unless task explicitly targets native behavior.
  - `docs/`: present but empty during onboarding.
- `README.md` says Flutter + Flame, but `pubspec.yaml` currently has no `flame` dependency.
- Root `.gitignore` ignores `.serena`; Serena config and memories are local workspace state.
- Serena project config should list Dart before C++ so symbol tools target Flutter code first (`languages: [dart, cpp]`). If the active Serena session still reports only C++, restart/re-activate Serena so it reloads `.serena/project.yml`.
- Related memories: read `mem:tech_stack` for SDK/dependency/build details, `mem:conventions` for local coding style, `mem:suggested_commands` for common commands, and `mem:task_completion` before finishing coding work.