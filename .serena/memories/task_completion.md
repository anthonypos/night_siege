# Task Completion

- For Dart/UI/game code changes, run:
  - `dart format lib test`
  - `flutter analyze`
  - `flutter test`
- After `pubspec.yaml` dependency changes, run `flutter pub get` before analyze/test.
- If changing platform host files, run at least the relevant targeted build/run command (`flutter build windows`, `flutter build web`, `flutter build apk`, etc.) in addition to Dart checks.
- Update or replace `test/widget_test.dart` when `lib/main.dart` stops exposing the template counter behavior; the existing test asserts the counter starts at 0 and increments to 1.
- Before final response, check `git status --short` and mention any pre-existing unrelated dirty files separately from files changed for the task.