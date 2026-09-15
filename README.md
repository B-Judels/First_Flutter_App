# Monthly Budget Planner

A local Flutter budget planner for monthly income, debit orders, services,
insurance, and daily/weekly/biweekly expenses. Data is entered manually.
There are no accounts, bank connections, analytics, or application backend.

## Supported platforms

Android is the primary build target. SQLite is also configured for iOS and macOS,
but Apple builds need verification on a Mac. Windows, Linux, and web runners are
scaffolding only: the app displays a platform-support message there instead of
attempting unsupported storage. The root index.html is a privacy page, not the
Flutter application.

## Install and run

Use Flutter **3.44.7** with Dart **3.12.2** (also pinned in .flutter-version and CI).
Install the Android SDK and JDK 21, accept Android licenses, and connect an Android
device or start an emulator.

    flutter --version
    flutter doctor -v
    flutter pub get --enforce-lockfile
    flutter devices
    flutter run -d <android-device-id>

No application environment variables or secrets are required for development.
Flutter generates android/local.properties. Its flutter.sdk must point to the
same SDK as the flutter command on PATH. Do not copy another developer's local
SDK paths. The Android scripts currently use Gradle 9.1.0 and AGP 9.0.1 with
compatibility flags; review those flags before upgrading either tool.

## Checks and builds

    dart format --output=none --set-exit-if-changed lib test
    flutter analyze --no-pub
    flutter test --no-pub
    flutter build apk --debug --no-pub

Tests use isolated SQLite databases through sqflite_common_ffi and never open the
application's expense_tracker.db. The SQLite test library uses native build hooks;
its first run can take longer. Tests cover transaction rollback, migration from
schema 1 to 2, validation, projections, editing, retry, and unsaved-change handling.
GitHub Actions runs format, analysis, tests, and an unsigned-for-distribution debug
build on Windows. A debug APK uses the normal Android debug key.

For distribution, create the ignored android/key.properties with these keys:

    storeFile=<path to your release keystore>
    storePassword=<keystore password>
    keyAlias=<signing alias>
    keyPassword=<key password>

storeFile resolves relative to android/app unless absolute. Keep both the
properties and keystore out of version control. Missing signing properties are
allowed for debug builds and rejected for release builds.

    flutter build appbundle --release --no-pub

For local Gradle checks an alternate properties file can be selected using
-PsigningPropertiesFile=<path relative to android>. Point it to a nonexistent file
to verify the no-secrets debug path without moving the real signing file.

Nothing deploys automatically. Validate a release on an Android device and inspect
store metadata before uploading it. iOS/macOS signing and template identifiers
still need project-specific setup on a Mac.

## Budget behavior

- One current budget is stored, not a transaction ledger or monthly history.
- Selecting a month changes the daily multiplier; it does not load an old budget.
- Daily costs use that month's actual number of days.
- Weekly/biweekly costs are estimates of four/two payments per month.
- Currency changes the display symbol; there is no exchange-rate conversion.
- Amounts must be finite and nonnegative; income must be greater than zero.
- Apply commits an expense dialog to the draft; Update commits the editor to disk.
- Cancel leaves the original expense intact. Back navigation asks before
  discarding unsaved changes. Failed saves retain the draft for retry.
- Start New confirms before deleting all saved budget data.

## Architecture and data

- lib/main.dart: startup routing, retry, and supported-platform guard.
- lib/pages/startup_page.dart: initial budget and atomic save.
- lib/pages/home.dart: dashboard, month selection, income update, reset.
- lib/pages/expense_page.dart: shared loading/saving/error flow for all editors.
- lib/widgets/expense_section.dart: expense lists and isolated edit dialogs.
- lib/widgets/draft_guard.dart: unsaved-change navigation guard.
- lib/models/budget.dart: categories, common validation, and projections.
- lib/database/database_helper.dart: sole persistence boundary.
- lib/models/: legacy typed category adapters used by the dashboard.
- lib/custom_tools/: shared styling, navigation, and spending bar.

SQLite schema version 2 contains user_settings (id, income, currency) and six
expense tables (id, name, cost). The version-1 migration adds currency with a
default of R. Fixes preserve the schema and existing records. Complete initial
budgets and multi-category edits commit in a single transaction. Settings writes
replace the single settings record rather than appending another one.

Fonts are bundled in fonts/ with their OFL license; runtime font downloads are
not used. Database files rely on OS application storage protections, without
additional application encryption or an app lock. OS backup behavior depends on
the device/platform settings.

## Remaining verification and design work

- Exercise release builds, storage failures, and upgrades on physical devices.
- Test Apple builds and replace their template product identifiers before release.
- Define backup/export, historical-budget, and calendar-exact recurrence needs
  before changing the schema.
- Money currently uses double/SQLite REAL. A future move to integer minor units
  needs an explicit currency/rounding policy and a tested data migration.
- Existing malformed data is not silently deleted or rewritten. Correct it in
  the editor; investigate unreadable databases rather than resetting automatically.
