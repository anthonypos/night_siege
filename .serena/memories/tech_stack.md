# Tech Stack

- Flutter app, project type `app` in `.metadata`.
- Flutter tool observed locally: Flutter 3.44.0 stable, Dart 3.12.0, DevTools 2.57.0.
- `pubspec.yaml` SDK constraint: Dart `^3.12.0`; `pubspec.lock` resolves Dart `>=3.12.0 <4.0.0` and Flutter `>=3.18.0-18.0.pre.54`.
- Direct runtime deps: Flutter SDK, `cupertino_icons`.
- Direct dev deps: Flutter test SDK, `flutter_lints` 6.0.0.
- Lint config is the stock `package:flutter_lints/flutter.yaml` include; no custom active lint rule overrides.
- Dart code uses Dart 3.12 shorthand syntax in the template app, e.g. `.fromSeed(...)` and `.center`.
- Android uses Gradle Kotlin DSL; app namespace/application id is still `com.example.night_siege`; Java/Kotlin target is JVM 17.
- Native platform scaffolds are generated Flutter host projects: Android/Kotlin, iOS+macOS/Swift, Linux+Windows/C++/CMake, Web static shell.