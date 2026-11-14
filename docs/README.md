# Development foundation — 9 November 2026

The Flutter app lives at the repository root. Android and iOS scaffolds are included.
Created and checked with Flutter 3.47.6 / Dart 3.13.5.

## Run and check

```sh
flutter pub get
flutter run
flutter analyze
flutter test
```

Commit `pubspec.lock` for reproducible application dependencies.

## Structure

- `lib/app.dart`: application configuration.
- `lib/core/router/app_router.dart`: go_router configuration; `/login` is the initial screen; `/` opens the Home scaffold. See [navigation](navigation.md).
- `lib/core/theme/`: shared colors, Poppins text styles, spacing and light ThemeData.
- `lib/core/utils/validators.dart`: reusable form validators.
- `lib/core/data/placeholder_data.dart`: intentionally empty until sample data is needed.
- `lib/features/`: feature screens.
- `assets/images/`: bundled images, including the logo extracted from the supplied Step 2.1 PDF.
- `assets/fonts/`: Poppins regular, medium, semibold and bold with their OFL license.

Poppins is bundled locally and requires no runtime download. Source:
https://github.com/google/fonts/tree/main/ofl/poppins

## Validators

Use `Validators.required`, `Validators.universityEmail`, or
`Validators.minLength(8)` as a `TextFormField.validator`. Valid input returns null;
invalid input returns an English error message, matching the app language.
`minLength` counts Unicode code points and preserves spaces; combine with
`required` when whitespace-only values must also be rejected.

`universityEmail` accepts `.edu` and `.edu.tr` domains including subdomains,
matching the Step 2.1 PDF. This is an initial suffix heuristic, not a complete global
university directory or email ownership check. Institutions using other domains
will require an approved domain list in a later authentication implementation.

The initial color palette can be adjusted centrally when the final design is available.
Firebase authentication and the remaining feature bodies are outside the November 12 milestone.
The login validates input and opens Home as a UI prototype; it does not authenticate against a backend.
