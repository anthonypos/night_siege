# AGENTS.md

This file gives AI coding agents the operating rules for this Flutter project. Follow it before making changes. If a more specific `AGENTS.md` exists deeper in the tree, the deeper file wins for files under that directory.

## Project assumptions

- This is a Flutter/Dart project. Preserve the existing app architecture unless the user explicitly asks for a redesign.
- Prefer project-local commands and wrappers. If `.fvm/fvm_config.json` exists, use `fvm flutter` and `fvm dart` instead of bare `flutter` and `dart`.
- If `melos.yaml`, `justfile`, `Makefile`, `.github/workflows`, or project scripts define canonical commands, prefer those over generic commands below.
- Do not introduce new state-management, routing, networking, persistence, code-generation, or lint packages without explicit user approval.

## Agent workflow

1. Start by checking repository context: `pubspec.yaml`, `analysis_options.yaml`, existing README/docs, current folder structure, and relevant tests.
2. Inspect existing patterns before writing code. Match naming, state management, dependency injection, navigation, error handling, and test style already in use.
3. Keep edits focused. Avoid broad rewrites, mass renames, dependency upgrades, generated-file edits, or formatting unrelated files unless requested.
4. Protect user work. Check `git status --short` before edits when possible; never overwrite or revert unrelated user changes.
5. Prefer small, reviewable changes. Make behavior changes explicit and update tests/docs when behavior changes.
6. After code changes, run the narrowest relevant validation first, then broader checks when feasible.
7. In the final response, report changed files, validation commands run, and any checks that could not be run.

## Standard commands

Run from the repository root unless a package-specific directory is clearly required.

```sh
flutter pub get

dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Use these conditionally:

```sh
# Code generation, only if build_runner or generated models are used.
dart run build_runner build --delete-conflicting-outputs

# Integration tests, only if integration_test/ exists and the environment supports it.
flutter test integration_test

# Dependency review.
flutter pub outdated

# Environment diagnostics, only when toolchain problems are suspected.
flutter doctor -v
```

For repositories using FVM:

```sh
fvm flutter pub get
fvm dart format --set-exit-if-changed .
fvm flutter analyze
fvm flutter test
```

Do not run destructive commands such as `git reset`, `git clean`, `rm -rf`, wholesale lockfile regeneration, or broad `flutter pub upgrade` without explicit user permission.

## Flutter architecture

- Use separation of concerns. Keep UI, UI logic, business/domain logic, and data access in distinct classes or layers.
- Prefer a feature-first structure for new app features when the project does not already enforce another structure:

```text
lib/
  app/                  # app bootstrap, router, theme, dependency wiring
  ui/core/              # shared design-system widgets, theme helpers, extensions
  features/
    feature_name/
      data/             # repositories, services, DTO/API models, data sources
      domain/           # optional use cases/domain models for complex logic
      ui/               # screens/views, widgets, view models/controllers
```

- Do not force this structure onto an existing project. Extend the current structure consistently.
- Use repositories to isolate data access from the rest of the app.
- Use service/data-source classes for external APIs, databases, platform channels, and persistence.
- Use ViewModels/controllers/notifiers/blocs according to the existing project pattern. Widgets should remain mostly declarative.
- Do not put business logic in widgets. Widget logic should be limited to simple rendering branches, layout, animation plumbing, and routing delegation.
- Use immutable data models for app state and domain/data objects when practical.
- Add a domain/use-case layer only when logic is complex, reused across ViewModels, or would otherwise crowd UI logic.
- Use dependency injection rather than global mutable singletons. Follow the current DI mechanism; if none exists, prefer simple constructor injection before adding a package.

## State management

- Use the state-management approach already present in the project, such as Provider, Riverpod, Bloc/Cubit, ChangeNotifier, ValueNotifier, MobX, or another established pattern.
- For local ephemeral UI state, `setState`, `ValueNotifier`, or existing local-state patterns are acceptable.
- For shared app state, keep updates unidirectional: user/UI events call ViewModel/controller methods; state changes flow back to the UI.
- Represent loading, success, empty, and error states explicitly.
- Keep asynchronous work out of `build()` methods. Trigger loading through lifecycle methods, providers, route loaders, ViewModels, or repositories.
- Dispose controllers, streams, subscriptions, timers, and notifiers that the widget or ViewModel owns.

## Routing and navigation

- Use the existing router/navigation system.
- If the project has no routing decision yet, prefer `go_router` for app-level routing in normal Flutter apps.
- Keep route definitions central and typed/constant where possible.
- Avoid scattering string route names, query keys, and deep-link parsing across widgets.
- Navigation guards, redirects, and auth checks should be tested where possible.

## Dart style and static analysis

- Follow Effective Dart naming:
  - `UpperCamelCase` for classes, enums, typedefs, extensions, and type parameters.
  - `lowerCamelCase` for variables, parameters, methods, and fields.
  - `lowercase_with_underscores` for files, directories, and library names.
- Format Dart with `dart format`; do not hand-format around the formatter.
- Keep `flutter_lints` or the project’s stricter lint set enabled. Do not silence lints unless the suppression is narrow and justified in a comment.
- Prefer `final` for values that are not reassigned.
- Prefer `const` constructors and widgets wherever valid.
- Avoid `dynamic` and unchecked casts unless required by an external boundary; validate and narrow types quickly.
- Prefer expression clarity over cleverness. Keep functions and widgets small enough to test and review.
- Use `///` doc comments for public APIs, reusable components, and non-obvious behavior.
- Do not edit generated files directly, including `*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.mocks.dart`, generated localization files, or generated plugin registrants. Change the source file and regenerate.

## UI and widget guidelines

- Prefer composition with small widgets over large monolithic `build()` methods.
- Prefer reusable `StatelessWidget`/`StatefulWidget` components over helper functions that return widgets, especially for UI reused across screens.
- Keep expensive calculations, parsing, network calls, database calls, and logging loops out of `build()`.
- Localize rebuilds. Do not call `setState` high in the tree for changes that affect only a small subtree.
- Use `ListView.builder`, `GridView.builder`, pagination, or virtualization patterns for large or unbounded collections.
- Use the project theme, design tokens, spacing system, and text styles. Avoid hard-coded colors, font sizes, and magic layout numbers unless the project already uses them intentionally.
- Respect accessibility: semantic labels for icon-only actions, sufficient tap targets, text scaling, contrast, focus order, and screen-reader-friendly labels.
- Keep user-visible strings localizable when the project uses Flutter localization/ARB files.
- Handle empty, error, loading, and offline states; do not leave screens blank during failures.

## Performance rules

- Optimize for correctness first, then measure before making non-obvious performance claims.
- Use DevTools/profile mode and a physical device for serious performance investigation.
- Keep `build()` cheap and deterministic.
- Use `const` widgets and stable child widget instances where possible.
- Avoid unnecessary intrinsic layout, excessive opacity layers, repeated `saveLayer`, huge images, and large synchronous JSON parsing on the UI isolate.
- Move CPU-heavy work to isolates when it is large enough to cause jank.
- Cache only when it improves measured behavior and does not create stale-state bugs.

## Data, networking, and persistence

- Keep API clients, database access, cache access, and platform channels behind repositories/services.
- Map external DTOs to app/domain models when the boundary is complex or unstable.
- Validate external data. Treat network, storage, platform-channel, and environment values as untrusted.
- Surface errors through typed failures or clear exception handling according to project style.
- Do not log secrets, tokens, authorization headers, full PII payloads, or sensitive user data.
- Use timeouts, cancellation, retries, and backoff deliberately; do not add retry loops without considering idempotency.

## Dependencies and `pubspec.yaml`

- Use `flutter pub add <package>` and `flutter pub remove <package>` for dependency changes when practical.
- Add packages only when they solve a real project need and after checking maintenance, platform support, license, transitive dependencies, and compatibility with the current SDK constraints.
- Prefer direct dependencies only for packages imported by project code. Do not add unused dependencies.
- Avoid `dependency_overrides` except as a temporary, documented workaround.
- Keep asset, font, localization, and SDK constraint changes deliberate. YAML whitespace matters.
- After changing `pubspec.yaml`, run `flutter pub get` and relevant validation.

## Testing expectations

- Add or update tests for changed behavior.
- Unit test services, repositories, mappers, validators, use cases, ViewModels/controllers, and pure business logic.
- Widget test screens and reusable widgets, especially rendering states, user interactions, routing, and dependency injection.
- Integration test critical user flows when the project has integration tests.
- Prefer fakes for repositories/services in tests. Use mocks only where they clarify an external boundary.
- Keep tests deterministic. Avoid real network calls, wall-clock timing, random data without a seed, and order-dependent tests.
- Name tests by behavior, not implementation detail.
- Golden tests may be updated only when visual changes are intentional. Do not run `--update-goldens` without user approval unless the user specifically requested golden updates.

## Platform-specific changes

- Android, iOS, macOS, Windows, Linux, and web changes must be minimal and clearly explained.
- When editing platform permissions, entitlements, manifests, Gradle files, Podfiles, signing settings, Info.plist, or build configuration, mention the exact reason.
- Do not change bundle IDs, app IDs, signing, provisioning, deployment targets, or package names unless requested.
- Test platform-specific changes on the relevant platform when available; otherwise state what could not be validated.

## Security and privacy

- Never commit API keys, private certificates, keystores, service-account JSON, tokens, passwords, or `.env` files containing secrets.
- Use `--dart-define`, platform secret stores, CI secrets, or documented local config mechanisms for secrets.
- Keep `.gitignore` protections for generated artifacts and secret files.
- Check auth, payment, encryption, account, and permission changes carefully. Prefer explicit user confirmation before changing security-sensitive behavior.
- Do not weaken TLS, certificate validation, auth guards, authorization checks, input validation, or platform permission boundaries.

## Serena MCP instructions

Use Serena when available for codebase understanding, symbol navigation, and precise code edits.

- At the start of a non-trivial coding task, ensure the correct Serena project is active. If it is not active, use `activate_project` with the repository root or the configured project name.
- If Serena has not onboarded this project, run onboarding. After onboarding, review/read the generated memories that look relevant.
- Before broad code exploration, use Serena memories and symbolic tools instead of reading large files from top to bottom.
- Prefer:
  - `list_memories` and `read_memory` for project conventions and prior decisions.
  - `get_symbols_overview` to understand a Dart file’s top-level declarations.
  - `find_symbol` to inspect a specific class, method, function, enum, extension, or top-level value.
  - `find_referencing_symbols` before changing public APIs or renaming symbols.
  - `get_diagnostics_for_file` after meaningful edits when available.
  - `replace_symbol_body`, `insert_before_symbol`, `insert_after_symbol`, `rename_symbol`, or safe-delete tools for symbol-aware edits.
  - `search_for_pattern` for text-only items such as asset paths, route strings, localization keys, JSON keys, generated references, and config values.
- Avoid reading entire large Dart files unless symbolic tools cannot provide the needed context.
- Use symbol-aware refactors for renames/moves that affect references. Do not do fragile search-and-replace for Dart symbols when Serena can refactor safely.
- Before writing Serena memories, read `memory_maintenance` if present and follow its conventions.
- Store Serena memories for durable project facts: architecture, commands, folder conventions, gotchas, coding standards, and decisions that future coding agents need.
- Do not store secrets, credentials, private user data, or noisy task transcripts in Serena memories.
- For multi-package repositories, activate the root that best matches the task. If cross-package references are needed, verify Serena configuration rather than assuming they are available.

## Basic Memory MCP instructions

Use Basic Memory when available for durable, user-owned project knowledge that should survive across sessions and connect to other notes.

- At the start of a substantial task, search Basic Memory for this project name, active feature, architecture decisions, requirements, and related bugs or plans.
- Determine the active Basic Memory project with `get_current_project` or `list_memory_projects`. In multi-project or cloud workspaces, prefer stable `project_id`/external IDs when available to avoid project-name collisions.
- Use `search_notes` or `search` before creating notes. Prefer hybrid/semantic search when available.
- Use `build_context` from relevant `memory://` URLs when prior decisions or connected topics may affect the task.
- Save only durable knowledge: decisions and rationale, requirements, API contracts, domain concepts, architecture notes, recurring project gotchas, feature plans, and handoff summaries.
- Do not save transient chatter, secrets, credentials, raw tokens, sensitive personal data, or information the user would not reasonably expect to persist.
- Ask permission before saving new information to Basic Memory unless the user has already explicitly asked you to remember/save it or project instructions clearly authorize saving.
- Prefer updating existing notes with `edit_note` over creating duplicates. Use `write_note` for new notes only.
- When creating or updating notes, use a structured format:

```markdown
# Note Title

## Context
Brief background and why this matters.

## Observations
- [decision] Concrete decision or fact #tag
- [requirement] Requirement or constraint #tag
- [technique] Implementation approach #tag

## Relations
- relates_to [[Other Exact Note Title]]
- implements [[Feature or Architecture Area]]
- requires [[Dependency or Decision]]
```

- Aim for 3-5 useful observations and 2-3 meaningful relations in substantive notes.
- Use exact `[[WikiLinks]]` for related notes and relation types such as `relates_to`, `implements`, `requires`, `extends`, `part_of`, and `contrasts_with`.
- Good folder conventions for this project, if no Basic Memory convention already exists: `projects/<project-name>/decisions`, `projects/<project-name>/architecture`, `projects/<project-name>/features`, `projects/<project-name>/bugs`, and `projects/<project-name>/handoffs`.
- Confirm what was saved and where after writing to Basic Memory.

## Relationship between Serena and Basic Memory

- Use Serena for code-aware, project-local operational context and symbol-level editing.
- Use Basic Memory for longer-lived knowledge, decisions, requirements, and cross-session continuity.
- Do not blindly duplicate every Serena memory into Basic Memory. Promote only durable, human-useful decisions or project knowledge.
- If the two memory systems conflict, treat repository files and current user instructions as authoritative, then current project docs, then Serena/Basic Memory notes. Mention the conflict in your response.

## Documentation updates

Update docs when changes affect:

- setup commands or developer workflow;
- public APIs or package exports;
- routing, environment variables, permissions, or deployment steps;
- architecture decisions or folder conventions;
- user-visible behavior that existing docs describe.

Keep human-facing docs concise. Keep agent-specific operational detail in `AGENTS.md` or nested `AGENTS.md` files.

## Pull request / handoff expectations

When finishing a task, provide:

- summary of behavior changed;
- files changed;
- tests/checks run;
- known limitations or unvalidated areas;
- any follow-up work that is genuinely required.

Do not claim tests passed unless they were run and passed. If a command fails because of environment setup, report the failure and the relevant output.

## Reference guidance used for this file

- Flutter architecture recommendations: https://docs.flutter.dev/app-architecture/recommendations
- Flutter performance best practices: https://docs.flutter.dev/perf/best-practices
- Flutter performance profiling: https://docs.flutter.dev/perf/ui-performance
- Flutter testing cookbook: https://docs.flutter.dev/cookbook/testing/unit/introduction
- Flutter packages and pubspec docs: https://docs.flutter.dev/packages-and-plugins/using-packages and https://docs.flutter.dev/tools/pubspec
- Dart Effective Dart style: https://dart.dev/effective-dart/style
- Dart formatter/analyzer docs: https://dart.dev/tools/dart-format and https://dart.dev/tools/dart-analyze
- `flutter_lints`: https://pub.dev/packages/flutter_lints
- AGENTS.md format: https://agents.md and https://developers.openai.com/codex/guides/agents-md
- Serena docs: https://oraios.github.io/serena/
- Basic Memory docs/source guide: https://github.com/basicmachines-co/basic-memory
