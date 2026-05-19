# Suggested Commands

- Install/update Dart packages after dependency changes: `flutter pub get`.
- Run app locally: `flutter run`; choose a specific target with `flutter run -d windows`, `flutter run -d chrome`, or another listed device.
- Analyze: `flutter analyze`.
- Test: `flutter test`.
- Format Dart code: `dart format lib test`.
- Build examples: `flutter build windows`, `flutter build web`, `flutter build apk`.
- Inspect available devices: `flutter devices`.
- Windows PowerShell file utilities:
  - List including hidden: `Get-ChildItem -Force`.
  - Read a file: `Get-Content path\to\file`.
  - Recursive fast file listing: `rg --files`.
  - Fast text search: `rg "pattern"`.
- Current branch/status checks: `git branch --show-current`, `git status --short`.