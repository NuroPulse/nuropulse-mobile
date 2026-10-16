# CLAUDE.md — NuroPulse Mobile App

Guidance for Claude Code (and any contributor) working in this repository. Read this fully before writing code. When a decision here changes, update this file in the same change.

Status: draft v0.1 (2026-10-09). Rename this file to `CLAUDE.md` in the repository root.

---

## 1. What this project is

NuroPulse is a companion app for people living with Parkinson's disease, and for anyone worried about a hand tremor. This repository is the **patient-facing Flutter mobile app**. Its backend is Supabase. A separate Next.js dashboard (not in this repository) is used by doctors.

The headline feature is an **early tremor check**: the user rests a hand, the phone's motion sensors record the hand, a signal-processing pipeline runs **on the device**, and the app reports whether rhythmic tremor was detected and recommends what to do next.

This app is **not a medical device and never gives a diagnosis**. See Section 2 for what it does and does not do.

The tremor pipeline was first proven in a separate feasibility app (the "biomarker demo"). The DSP code in `lib/dsp/` was brought over from it. Calibration notes and raw-signal tooling stay in that demo, not here.

Source of truth for data sent to the backend: the **NuroPulse Data Contract** (Google Doc, "NuroPulse Data Contract"; link: https://docs.google.com/document/d/1OKP_CYbWHBk-w0SY65_Eyy82N_Fs982KTxe1qxnRd4A/edit). Section 4 summarizes it. If this file and the contract disagree, the contract wins for data shapes, and this file should be corrected.

The actual deployed schema (tables, columns, RLS policies, functions) can be read directly from `supabase/migrations/*.sql` — pulled from the live project with `supabase db pull` (first pulled 2026-10-15). Treat it as the most concrete reference for exact column names/types/constraints when the Doc is silent or ambiguous; Section 4 is kept in sync with it.

---

## 2. Features and limits

### Features in scope (MVP)

| Feature                         | Notes                                                                                                                             |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Tremor check without an account | Anyone can run a check right after installing. The result includes a plain recommendation.                                        |
| Account registration and login  | Role is always `patient` on mobile.                                                                                               |
| Connect to a doctor             | The patient enters the doctor's personal connection code. A patient connects to **one** doctor.                                   |
| Measurement history             | List of past checks with their status.                                                                                            |
| Medication schedule and log     | Mobile side built: read the schedule (`patient_medications`), log a dose (`medication_logs`). Blocked on the backend until `patient_medications`/`medication_logs`/`medicines` get their `GRANT SELECT`/`INSERT` for `authenticated` (Section 13 item 1) — not yet confirmed done. |

### Limits (don't state this in code or UI)

- **Tremor-based detection only.** No gait, voice, handwriting, or any other Parkinson signal.
- **Rest condition only.** The check is always `condition = rest` (hand supported and relaxed). `postural` is not supported in this version.
- **Variable-second recording.** The user can pick how many seconds they will record the tremor-detection for. The literature (we referenced) used 20–30 s per recording. Make it so the recording be chooseable from 8 seconds to 30 seconds. (Originally planned as 4–30 s; raised to 8 s because the demo's calibrated `dropEdgeS` (3 s) + one Welch `segmentS` (4 s) already need 7 s of processed signal — see Section 10 step 4.)
- **Output is only `none`, `tremor`, or `invalid`.** `tremor` means rhythmic shaking was found in the tremor band during this check. Frequency alone does not separate Parkinson's tremor from essential tremor, drug-induced tremor, or enhanced physiological tremor (caffeine, fatigue, anxiety).
- **No diagnosis, no disease name in results.** The app can say that a tremor was found and recommend seeing a neurologist. It cannot say a person has or does not have a disease. It never says "healthy".
- **Thresholds are not calibrated.** They are the team's starting values, not validated on smartphones. While `calibrated` is `false` in the DSP config, the result screen shows the "Ambang belum dikalibrasi" banner.
- **Android first**, tested on physical devices only. iOS later.
- **Amplitude (`band_rms_g`) is only comparable on the same person and the same phone model.**
- **Doctors use the web dashboard.** The mobile app serves `patient` accounts only.

### Do not claim anywhere (UI, store listing, code comments)

"Detects Parkinson's", "diagnoses", "accuracy of X%" (no accuracy has been measured by this team), "detects wearing-off". The word "Parkinson" may appear to describe who the app is for (for example onboarding: "pendamping untuk penderita Parkinson"). It must never appear in a result or in any sentence about the user's own condition.

---

## 3. User flow

```
Install -> Onboarding -> Home -> Cek Tremor (no account needed)
   -> Instructions -> Countdown (3 s) -> Record (n s) -> Processing -> Result + recommendation
   -> (user sees a neurologist; the neurologist gives their connection code)
   -> Register / Login -> Enter connection code -> Connected to doctor
   -> Regular checks (now owned by the account) -> History
   -> Medication schedule and log
```

1. **First open.** Short onboarding explains what the app does (give a small disclaimer that it is not a diagnosis). Then Home. No login wall.
2. **Check without an account.** The user opens Cek Tremor, reads the instructions (phone on the back of the hand, seated, forearm supported, hand relaxed, do not touch the screen), taps Mulai, waits through a 3-second countdown, and the phone records for n seconds. The result page shows the status with a recommendation (wording in Section 8). Invalid results ask the user to repeat.
3. **Diagnosis in real life.** The user visits a neurologist. At the end of diagnosis, the neurologist gives the user their **connection code**.
4. **Register and connect.** The user registers (full name plus credentials), logs in, and enters the doctor's connection code. The account is now linked to that doctor and the doctor sees the patient on the dashboard.
5. **Ongoing use.** The user repeats checks regularly (about weekly is the intended rhythm; reminders are not decided yet, see Section 13). Checks made while logged in are owned by the account (`patient_id` is set).
6. **Medication** (schema exists, mobile not built — Section 13 item 1): the doctor sets the schedule from the dashboard, the patient logs doses in the app.

Checks made before registering have no owner (`patient_id` null) — the backend confirms this is supported (Section 4, Section 13 item 2). After registration, a `claim_measurements(uuid[])` RPC exists to attach previously-local measurement ids to the new account. Mobile does not yet call either of these; see Section 13 item 2 for what's still to implement.

---

## 4. Data contract summary (mobile view)

Kept in sync with the live Supabase schema (`supabase/migrations/*.sql`, see Section 1). Tables marked **(doctor dashboard only)** exist in the database but this mobile app never reads or writes them — listed here only so their existence and RLS shape are known.

### profiles (shared identity row, one per auth user)

| Column            | Type        | Notes                                                                                                    |
| ----------------- | ----------- | -------------------------------------------------------------------------------------------------------- |
| `id`              | uuid        | Same as the Supabase auth user id                                                                        |
| `role`            | text        | `patient` or `doctor`, set by the `handle_new_user` trigger. Every signup inserts as `patient`; if `raw_user_meta_data ->> 'signup_source' = 'web'`, a second step calls `make_doctor()` to upgrade the row (sets role, generates `connection_code`, creates `doctor_details`). `raw_user_meta_data` is client-settable, so a mobile client could in principle send `signup_source: 'web'` too, a known gap, already raised with the backend team. Mobile never sends `signup_source`. |
| `full_name`       | text        | Name shown to the doctor. Sent by mobile as `raw_user_meta_data.full_name` at signup.                   |
| `email`           | text        | Mirrors the auth user's email                                                                            |
| `phone`           | text        | `NOT NULL` as of 2026-10-15 (renamed from `phone_number` the same day). Mobile sends it as `raw_user_meta_data.phone` at signup (register screen requires it). |
| `connection_code` | text        | Doctors only (`CHECK`-enforced: present iff `role = 'doctor'`). Mobile never reads or writes it, except that the patient types a doctor's code to connect. Now correctly set via `make_doctor()` for `'web'` signups (fixed 2026-10-15; earlier version of the trigger skipped it). |
| `doctor_id`       | uuid, optional | Set once a patient connects to a doctor (`CHECK`-enforced: only ever set when `role = 'patient'`). |
| `connected_at`    | timestamptz, optional | Set at the same time as `doctor_id`.                                                            |
| `created_at`      | timestamptz |                                                                                                           |

A profile is created automatically by a database trigger on signup. The mobile app never inserts into `profiles` directly, only reads/updates it.

`GRANT SELECT, UPDATE` on `profiles` for `authenticated` landed 2026-10-15 — reading/updating your own profile from mobile works now. Several other tables mobile may eventually touch (`measurements`, `patient_medications`, `medication_logs`, `medicines`) were found with the same missing-grant gap around the same time; confirm each is granted before building against it, don't assume RLS policies existing means the table is reachable.

Role-specific detail lives in a separate table, also auto-created by the same trigger:

### patient_details (one row per patient profile)

| Column           | Type        | Notes                        |
| ---------------- | ----------- | ----------------------------- |
| `id`             | uuid        | = `profiles.id`               |
| `date_of_birth`  | date, optional |                             |
| `gender`         | text, optional | `male` or `female`         |
| `phone`          | text, optional |                             |
| `email`          | text, optional | Set from the auth email on creation |
| `diagnosis`      | text, optional | Not currently surfaced anywhere in this app — do not add UI for it without asking |
| `updated_at`     | timestamptz |                                |

### doctor_details (doctor dashboard only)

`id` (= `profiles.id`), `phone`, `avatar_url`, `str_number`, `specialization`, `organization_name`, `organization_type`, `verification_status` (`pending` / `verified` / `needs_revision`), `verified_at`, `updated_at`.

### measurements (one per check)

| Column           | Type           | Mobile value                                                    |
| ---------------- | -------------- | --------------------------------------------------------------- |
| `id`             | uuid           | Generated on the device (uuid v4). Makes re-sending idempotent. |
| `patient_id`     | uuid, optional | Logged-in user id, or omitted when not logged in — the backend confirms anonymous inserts (`patient_id = null`) are allowed (Section 13 item 2). |
| `measured_at`    | timestamptz    | Device time at the check                                        |
| `uploaded_at`    | timestamptz    | Set by the backend (a trigger forces `now()` on every insert regardless of what's sent). Mobile never sends it. |
| `condition`      | text           | Always `rest` in this version. The `CHECK` constraint also allows `postural` server-side, but the app must never send it (Section 2). |
| `duration_s`     | number         | from 8 to 30 seconds                                             |
| `status`         | text           | `none`, `tremor`, or `invalid`                                   |
| `invalid_reason` | text           | Only when `invalid` (`CHECK`-enforced: present iff `status = 'invalid'`). Free text — no enum constraint in the database, so the mobile list in Section 13 item 3 is still the authority. |
| `features`       | object (jsonb) | Not sent when `invalid` (`CHECK`-enforced)                       |
| `algo_version`   | text           | `0.1.0` in this version                                          |
| `device`         | object (jsonb) | Device metadata — stored as plain jsonb, no column-level shape enforced, so Section 13 item 4's field list is still the only source for what keys to send |

`features` object (also promoted into five generated columns — `peak_frequency_hz`, `band_power_ratio`, `snr`, `band_rms_g`, `consistency` — read directly off `features ->> '<key>'`, so the JSON keys below must match exactly or the generated columns come back null):

| Key                 | Unit   | Meaning                                                                     |
| ------------------- | ------ | --------------------------------------------------------------------------- |
| `peak_frequency_hz` | Hz     | Frequency of the highest spectral power in the peak-search range            |
| `band_power_ratio`  | 0 to 1 | Power in the tremor band (3.5–7 Hz) divided by total power in 1–15 Hz       |
| `snr`               | ratio  | Peak power divided by the median power in 1–15 Hz                           |
| `band_rms_g`        | g      | RMS in the tremor band, **in g** (convert from m/s² by dividing by 9.80665) |
| `consistency`       | 0 to 1 | Fraction of time segments that contain the tremor                           |

JSON keys use `snake_case` exactly as above. Dart fields use `camelCase` and map through Freezed/json_serializable (`@JsonKey`).

### RPCs the mobile app calls (through Supabase, not plain table access)

| Function                       | Who calls it | Purpose                                                                                     |
| ------------------------------- | ------------- | --------------------------------------------------------------------------------------------- |
| `connect_to_doctor(p_code)`     | patient       | Validates a doctor's connection code, sets `profiles.doctor_id`/`connected_at`. Raises with Postgres error code `P0002` on an invalid code — map that to `ConnectionCodeFailure` in `ConnectionRepository`. |
| `claim_measurements(uuid[])`    | patient       | Attaches the given local measurement ids to the now-logged-in account (`patient_id = auth.uid()`), but only rows where `patient_id` is still null. Call this right after registration/login with any ids saved while logged out. |

### Medication (schema exists; mobile feature not built — Section 13 item 1)

| Table                 | Purpose                                                                                      |
| ----------------------- | ----------------------------------------------------------------------------------------------- |
| `medicines`             | Shared catalog: `name`, `common_dosage`, `notes`. **No working RLS policy yet** — currently unreadable/unwritable by `anon`/`authenticated`. |
| `medication_schedules`  | Looks superseded by `patient_medications` below — has no RLS policies either, and its `patient_id`/`doctor_id`/`medicine_id` columns default to `gen_random_uuid()`, which looks like a bug (a foreign key should never silently default to a random id). Do not build against this table without confirming with the backend first. |
| `patient_medications`   | The one that actually works: `patient_id`, `medicine_id`, `dose`, `schedule_times` (array of `time`), `start_date`/`end_date`, `is_active`, `prescribed_by` (doctor). RLS: patient reads own; doctor has full access to their own patients' rows. |
| `medication_logs`       | One row per dose taken/skipped: `patient_medication_id`, `scheduled_at`, `status` (default `taken`), `taken_at`, `patient_id`. RLS: patient reads/writes own; doctor reads their patients'. |

### Doctor dashboard only — exists, not consumed by this app

`alerts` (doctor is notified when a connected patient's check comes back `tremor` — a trigger creates this automatically) and `notifications` (`recipient_id` is always the doctor for alert-triggered rows). Both are in the `supabase_realtime` publication. Out of scope here per Section 14 ("the doctor-side UI").

---

## 5. Tech stack and decisions

| Area             | Decision                                                                                                                                                   |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Framework        | Flutter (stable channel), Dart null safety                                                                                                                 |
| State management | `flutter_bloc` with **Cubit** (no Bloc events)                                                                                                             |
| State and models | `freezed` + `json_serializable` for Cubit states and data models                                                                                           |
| Backend client   | `supabase_flutter` (auth and data). Backend implementation details are owned by the backend team; the app reaches them only through repository interfaces. |
| Local storage    | `hive_ce` + `hive_ce_flutter` (the original `hive` package is abandoned; do not use it)                                                                    |
| Secure storage   | `flutter_secure_storage` for the auth session. Auth exists now, so it is no longer deferred.                                                               |
| Sensors          | `sensors_plus`                                                                                                                                             |
| FFT              | `fftea`                                                                                                                                                    |
| Routing          | `go_router`, configured in `services/router_service.dart`, `MaterialApp.router` in `app.dart`                                                              |
| Charts           | `fl_chart` for history trends; `CustomPainter` for the live waveform during recording                                                                      |
| Screen           | `wakelock_plus` keeps the screen on while recording                                                                                                        |
| Metadata         | `device_info_plus`, `package_info_plus`, `uuid`                                                                                                            |
| Config           | `flutter_dotenv` for Supabase URL and anon key (`core/environments/`)                                                                                      |
| Logging          | `logger`, wrapped by `LoggerService`                                                                                                                       |
| Testing          | `flutter_test`, `bloc_test`, `mocktail`                                                                                                                    |
| Lints            | `flutter_lints`                                                                                                                                            |

Rules for dependencies:

- Do not pin versions from memory. Check the latest version on pub.dev when adding a package, and say which version you added.
- Do not add a dependency that is not in the table above without asking. Specifically: no Dio (Supabase handles transport), no service locator (`get_it` etc.), no local-notification package until reminders are decided (Section 13).
- DI is plain `RepositoryProvider` / `BlocProvider` wiring in `app.dart` and `main.dart`.
- The Supabase anon key and URL come from `.env` (git-ignored). Never commit them. Never put a service-role key in the app.

---

## 6. Architecture and folder structure

Clean architecture, feature-based. Follow this layout.

```
lib/
├── app.dart                        # Root MaterialApp.router, providers
├── main.dart                       # Entry point — load env, init Hive and Supabase, run app
│
├── core/
│   ├── environments/               # Env access (Supabase URL, anon key)
│   ├── errors/                     # Failure hierarchy
│   ├── themes/                     # BaseColors, FontTheme
│   └── utils/                      # Date/time helpers, number formatting
│
├── dsp/                            # PURE DART signal processing — see rules below
│   ├── dsp_config.dart
│   ├── tremor_pipeline.dart        # Orchestrates the stages
│   ├── models/                     # Pure result types: features, gate results, tremor result
│   └── stages/                     # resampler, sos_filter, welch, features, quality_gate, decision
│
├── features/
│   ├── auth/                       # Register, login, logout, session
│   │   ├── data/{datasources,models,repositories}/
│   │   ├── domain/{entity,repositories}/
│   │   └── presentation/{cubit,pages,widgets}/
│   ├── measure/                    # Instructions -> record -> process -> result; local save and upload queue
│   │   ├── data/{datasources,models,repositories}/
│   │   ├── domain/{entity,repositories}/
│   │   └── presentation/{cubit,pages,widgets}/
│   ├── history/                    # Past measurements
│   │   ├── data/ ...
│   │   ├── domain/ ...
│   │   └── presentation/ ...
│   ├── connection/                 # Enter a doctor's connection code; show the connected doctor
│   │   ├── data/ ...
│   │   ├── domain/ ...
│   │   └── presentation/ ...
│   └── medication/                 # Read the prescribed schedule, log doses. No create/edit: schedules are doctor-only
│       ├── data/ ...
│       ├── domain/ ...
│       └── presentation/ ...
│
└── services/
    ├── storage/                    # HiveService (measurements box + settings box), SecureStorageService
    ├── logger_service.dart
    └── router_service.dart
```

`data/datasources/` holds the Supabase and Hive/sensor access for that feature. File names inside features are illustrative; the folder structure is not.

Not created, on purpose: `core/client/` and `services/jwt_service.dart` (no custom HTTP client or manual JWT handling; `supabase_flutter` owns the session).

### Layer rules

- **presentation** depends on **domain** only (entities and repository interfaces). It never imports `data/`.
- **data** implements **domain** interfaces. Models (Freezed + JSON) live here and map to and from entities.
- **domain** is pure Dart: no Flutter imports, no JSON, no annotations, no Hive, no `sensors_plus`, no Supabase types.
- There is **no use-case layer**. Cubits call repository interfaces directly. Do not add one.
- A feature may depend on another feature's **`domain/`** layer only (for example `history` uses `MeasurementRepository` from `measure`). Never import another feature's `data/` or `presentation/`.
- Widgets contain no business logic. Anything beyond layout and event forwarding belongs in a Cubit.

### Imports (no barrel files)

- There are **no barrel files** in this project. Do not create `index.dart` or `_something.dart` export files.
- Import each file directly with an absolute `package:` import. Do not use relative imports across folders. Use of `export` is limited to re-exporting inside a single file when truly needed; ask first.

### `lib/dsp/` rules (important)

- Files in `lib/dsp/` may import only `dart:*`, `package:fftea`, and other files inside `lib/dsp/`. **No** imports from Flutter, `flutter_bloc`, Hive, Supabase, or any other part of the app (`core/`, `features/`, `services/`).
- DSP result types in `lib/dsp/models/` may be used directly by `domain/` and `data/` layers; do not duplicate them as entities.
- All numbers (bands, thresholds, filter coefficients, segment lengths) come from `DspConfig`, loaded from `assets/config/dsp_config.json`. No magic numbers in stage code.
- DSP code is deterministic and has no I/O.

---

## 7. Coding standards

- `dart format` before every commit; `flutter analyze` must be clean.
- Use `const` constructors wherever possible. Prefer immutability: Freezed for states and models.
- Cubit states and data models are Freezed. Entities are plain immutable Dart classes with no annotations.
- One public class per file (small private helpers excepted). File names are `snake_case`, class names `PascalCase`.
- No `print`. Use `LoggerService`.
- No business logic in widgets. No `BuildContext` in Cubits, repositories, or DSP.
- Do not swallow errors. Catch at the repository boundary, convert to a `Failure`, and let the Cubit emit a failure state.
- Comments explain **why**, not what. Do not leave commented-out code.
- Keep functions short and named for what they do. Prefer early returns over deep nesting.
- Generated files (`*.freezed.dart`, `*.g.dart`) are committed or ignored consistently with `.gitignore`; never edit them by hand.
- Never log or print tokens, passwords, connection codes, or full measurement payloads.

### Errors

- `core/errors/` defines a sealed `Failure` hierarchy: `SensorFailure`, `StorageFailure`, `AnalysisFailure`, `NetworkFailure`, `AuthFailure`, `ConnectionCodeFailure`.
- Repositories **throw** `Failure` subclasses (they implement `Exception`). Cubits catch `Failure` and emit a failure state.
- `Failure.message` is developer-facing English and is only logged. **Never display it.** The presentation layer maps each failure type to an Indonesian message.
- Backend error codes (English identifiers from the contract, for example `code_not_found`) are mapped to a `Failure` subtype in the repository, then to Indonesian text in presentation.

---

## 8. Language rules

### User-facing text → Bahasa Indonesia

Anything rendered in the UI: labels, buttons, error messages shown to the user, toasts, snackbars, dialogs, form validation messages, chart titles and axis labels, empty states, onboarding.

### Developer-facing text → English

Console logs, code comments, commit messages, internal error logs that are not shown to users, `Failure.message`, variable/class/function/file names, test names, JSON keys, and this file.

Never mix: no English strings in the UI, no Indonesian identifiers or comments in code.

UI copy is written **inline, directly in the widget** that shows it. Do not create a strings file, a constants class for UI text, or a localization setup (no `core/constants/strings.dart` and the like). Keep the text next to the code that renders it, so it is easy to read and change in place.

The one exception is text that is genuinely shared and must never drift apart (for example the three decision messages below, shown on both the result page and the history detail). Put those in a small widget that owns the text and reuse the widget, instead of passing string constants around.

### Wording that must stay consistent

This table is a reference for wording, not a code file. When you write a widget, copy the text from here so the same thing is always said the same way.

| Meaning                       | Indonesian text                                                                                            |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------- |
| Check tremor (primary action) | Cek Tremor                                                                                                 |
| Start                         | Mulai                                                                                                      |
| Cancel                        | Batal                                                                                                      |
| Retry                         | Ulangi                                                                                                     |
| Processing                    | Memproses…                                                                                                 |
| Result                        | Hasil                                                                                                      |
| History                       | Riwayat                                                                                                    |
| Register                      | Daftar                                                                                                     |
| Log in                        | Masuk                                                                                                      |
| Log out                       | Keluar                                                                                                     |
| Full name                     | Nama lengkap                                                                                               |
| Doctor connection code        | Kode koneksi dokter                                                                                        |
| Connect                       | Hubungkan                                                                                                  |
| Countdown                     | Bersiap… mulai dalam {n} detik                                                                             |
| Recording                     | Merekam… tahan tangan tetap rileks                                                                         |
| Decision: none                | Tremor ritmis tidak terdeteksi pada pengecekan ini. Jika Anda tetap khawatir, konsultasikan dengan dokter. |
| Decision: tremor              | Tremor ritmis terdeteksi. Sebaiknya konsultasikan dengan dokter saraf.                                     |
| Decision: invalid             | Pengukuran tidak valid. Silakan ulangi.                                                                    |
| Gate: sampling too low        | Kecepatan sampling sensor terlalu rendah                                                                   |
| Gate: data gap                | Ada jeda data yang terlalu panjang                                                                         |
| Gate: large movement          | Gerakan tangan terlalu besar                                                                               |
| Gate: weak signal             | Sinyal terlalu lemah (di bawah noise sensor)                                                               |
| Gate: too short               | Rekaman terlalu pendek untuk dianalisis                                                                    |
| Gate: flat signal             | Sensor tidak mendeteksi gerakan sama sekali                                                                |
| Uncalibrated banner           | Ambang belum dikalibrasi                                                                                   |
| Interrupted                   | Rekaman dihentikan karena aplikasi keluar dari layar.                                                      |
| Code not found                | Kode koneksi tidak ditemukan. Periksa kembali kode dari dokter Anda.                                       |
| Offline                       | Tidak ada koneksi internet. Data akan dikirim saat tersambung.                                             |
| Generic error                 | Terjadi kesalahan. Silakan coba lagi.                                                                      |

Result and recommendation text must **never** say or imply a diagnosis (no "Anda menderita", "sakit", "sehat", and no disease name). Use the decision wording above. Add new strings to this table when you add them.

---

## 9. Recording, storage, and sync

### Sensor

- Record `userAccelerometerEventStream` (gravity removed by the OS) via `sensors_plus`.
- Request `samplingPeriod: Duration(milliseconds: 10)` (about 100 Hz). This is a request, not a guarantee: always compute the effective rate from timestamps.
- Store timestamps from `event.timestamp.microsecondsSinceEpoch`. Never substitute array index or `DateTime.now()`.
- Samples go into an in-memory buffer only. **Raw signals are not saved and not uploaded.** Only the result and features are stored.
- Assumption to confirm from the demo results: user accelerometer only (no raw accelerometer or gyroscope). If the demo showed another stream is needed, change this section and the DSP config together.

### Local storage (Hive)

- Boxes (opened in `HiveService`): `measurements` (key = measurement id) and `settings`.
- Store **JSON maps** produced by the Freezed models. Do not use Hive TypeAdapters or `hive_ce_generator`.
- Each local measurement keeps an `uploaded` flag (local bookkeeping, not part of the contract payload).
- Hive is initialized in `main.dart` before `runApp`.

### Secure storage

- `flutter_secure_storage` holds the auth session. Check how `supabase_flutter` persists the session by default and, if it does not use secure storage, plug in a secure custom storage when implementing auth. Say what you did.

### Saving and uploading a measurement

1. After analysis, build the measurement (Section 4) with a new uuid v4, then save it to Hive **before** showing the result.
2. If logged in, set `patient_id`. Then upload through `MeasurementRepository`. If upload fails (offline, server error), keep the item with `uploaded = false` and retry later (app start, login, connectivity regained).
3. Re-sending must never create duplicates: the same `id` is sent every time.
4. If not logged in: the backend confirms uploading with no `patient_id` is supported (RLS allows anonymous insert — Section 4, Section 13 item 2). **Mobile does not implement this yet** — `MeasurementRepositoryImpl` currently always keeps unauthenticated measurements local-only. Implementing the upload-while-logged-out path, and calling `claim_measurements` after the user registers, is still open work.
5. `uploaded_at` is never set by the app.

### Auth

- Register and login use Supabase auth through `AuthRepository`. The exact sign-in method (email and password assumed) is confirmed with the backend; hide it behind the repository interface.
- Connecting to a doctor goes through a `ConnectionRepository` method that takes the code and returns the connected doctor. Error codes come from the backend; map them in the repository.
- The app never sets `role`. After login, if the profile's `role` is not `patient`, sign out and show the generic message that the web dashboard is for doctors (exact text to be added to Section 8).

---

## 10. DSP specification (version 0.1.0, work in progress)

> Every number below is a **starting value**, not validated on smartphones for the shortest (8-second) window. Values change through `dsp_config.json` after calibration. If a parameter has no source, mark it `TODO(calibrate)` instead of inventing a reference. Do not present any of it as established evidence.

### Protocol (shown to the user before recording)

- Phone strapped to or resting on the back of the hand, seated, forearm supported, hand relaxed.
- Countdown 3 s, then record **n s**, `condition = rest`.
- Do not touch the screen while recording.
- **No vibration, haptics, or sound that moves the phone between recording start and stop.** Cues are allowed before and after only.

### Pipeline

```
QC sampling -> resample -> demean -> band-pass -> edge handling -> Welch per axis, summed
            -> features -> quality gate -> decision
```

1. **QC sampling.** Compute the effective sampling rate and maximum gap from the real timestamps. Starting thresholds: effective rate >= 50 Hz, no gap > 200 ms. Failure gives `invalid` (`low_sampling_rate`, `sampling_gap`). A recording shorter than `minDurationS` (currently 8 s, see step 4) gives `too_short`.
2. **Resample.** Linear interpolation on the real timestamps to a uniform grid, with a low-pass (about 20 Hz) for anti-aliasing before decimating to the working rate (starting plan: 50 Hz). Target rates are config-driven. Guard against duplicate timestamps (zero time span).
3. **Demean**, then **band-pass 1–20 Hz**, Butterworth order 2, applied forward then backward (zero-phase).
   - **Do not design filters in Dart.** SOS coefficients are generated in Python (`scipy.signal.butter(..., output='sos')`) for the working rate, stored in `dsp_config.json`, and only the filter application is implemented in Dart. Python lives in the demo repository.
4. **Edge handling.** Decided from the demo's shipped `dsp_config.json`: drop the first **3.0 s** (`dropEdgeS`) of the filtered signal rather than record an uncounted pre-roll. `duration_s` is the full recorded length (the drop happens after filtering, not before capture). Because the Welch stage below also needs one full 4 s segment, the pipeline needs `dropEdgeS + segmentS = 7.0 s` of recording just to produce one segment — this is why the app's minimum recording length is **8 s**, not 4 s (Section 2). `TODO(calibrate)`: this combination was tuned against the demo's fixed 20–25 s recordings, not validated at 8 s specifically.
5. **Spectrum (Welch), per axis, then sum the per-axis PSDs.**
   - Segment length, overlap, and window come from config. Shipped values: **4 s segments** (`segmentS`), 50% overlap, Hann window, nFFT 256. `TODO(calibrate)`.
   - Frequency resolution with 4 s segments is about 0.25 Hz; the zero-padded bin spacing (nFFT 256 at 50 Hz) is about 0.195 Hz. Do not report peak-frequency precision finer than the resolution supports; parabolic interpolation is allowed.
   - Match `scipy.signal.welch` defaults (`detrend='constant'`, `scaling='density'`, mean averaging) so Dart and Python agree.
   - Sum PSD across axes. **Do not use the vector magnitude** of a zero-mean signal (rectification doubles the apparent frequency). Summing PSD also removes dependence on phone orientation.
6. **Features** (as in the contract; tremor band 3.5–7 Hz, ratio and SNR over 1–15 Hz):
   - `peak_frequency_hz`: argmax of the PSD in the peak-search range (starting 3–12 Hz).
   - `band_power_ratio`, `snr`, `band_rms_g`, `consistency` (fraction of Welch segments whose own peak lies in the tremor band; with only a few segments this value is coarse, so treat it as such). `TremorFeatures.bandRms` inside `lib/dsp/` stays in **m/s²**, matching the Python reference exactly so golden tests compare like for like — convert to g (divide by 9.80665) only when building the contract's `band_rms_g` payload field in `features/measure/data/`, never inside `lib/dsp/`.
7. **Quality gate.** Any failed check makes the result `invalid` and the app asks for a repeat:
   - sampling rate and gap (step 1);
   - excessive voluntary movement (large low-frequency energy or RMS before band-pass);
   - clipping against the sensor's range;
   - signal below the sensor noise floor (per-model noise floor values come from the demo's `noise_floor` measurements).
8. **Decision.** Rule-based and transparent. Exactly three statuses:
   - `none`: valid measurement, rule not met;
   - `tremor`: valid, the peak is inside the tremor band, and the thresholds are met;
   - `invalid`: a gate failed.
   - Thresholds live in `dsp_config.json` with `"calibrated": false`. While false, the result screen shows the uncalibrated banner. The `calibrated` flag is **not** part of the backend payload.

### What the DSP must never claim

- Frequency alone does not separate Parkinson's tremor from essential tremor or other tremors. The app never outputs a diagnosis or a disease name.

### Testing against Python

- Golden test files exported from the demo's Python reference are copied into `test/dsp/golden/`. Dart must match them within a stated tolerance on the analyzed region. Python remains the source of truth for filter design and expected feature values.

---

## 11. Cubit specifics

`MeasureState` is a Freezed union:

```
idle | countdown(secondsLeft) | recording(elapsed, liveWindow) | processing
     | success(result, measurementId) | invalid(reasons) | failure(failure)
```

- The state machine only moves forward through these states; `Ulangi` returns to `idle`.
- Sensor samples go into a plain in-memory buffer, not into state. Emit `recording` state at most about 10–15 times per second with a small downsampled window for the live waveform. A busy main thread distorts sensor event delivery.
- DSP runs off the UI isolate: `Isolate.run(() => TremorPipeline(config).analyze(signals))`. Convert samples to typed lists (`Float64List`) before sending.
- Cancel all sensor subscriptions in `close()`, and when the app leaves the foreground during recording (`AppLifecycleState.paused`) stop and emit `invalid` with the interruption message.
- Keep the screen awake with `wakelock_plus` for the duration of recording and release it afterwards.
- After analysis, persist through `MeasurementRepository` (Hive first, then upload attempt) before emitting `success`. An upload failure must not turn a valid result into a failure: the result is still shown and the item is queued.
- `AuthCubit` exposes `unauthenticated | authenticating | authenticated(profile) | failure`. Router redirects read it; do not scatter session checks through widgets.

---

## 12. Testing

- `flutter test` must pass before any change is considered done.
- **DSP unit tests** (`test/dsp/`): synthetic sines at known frequencies (peak within the Welch resolution for the configured segment length), amplitude behavior, jittered timestamps, gap rejection, duplicate timestamps, a recording below `minDurationS` (must be `invalid` with `too_short`, not crash), all-zero signal (must be `invalid`, not `none`).
- **Golden tests**: see Section 10.
- **Cubit tests** with `bloc_test` and `mocktail`: `MeasureCubit` state sequences for success, invalid, failure, and interruption; upload failure after a valid result; `AuthCubit` transitions.
- **Repository tests** with mocked datasources: idempotent re-upload (same `id`), retry queue, mapping of backend error codes to `Failure` types.
- No tests that depend on a real sensor or a real backend.

---

## 13. Open items (do not guess; ask or follow the backend)

1. **Medication schedule and log:** ~~no data contract yet~~ Mobile built 2026-10-16 (`features/medication/`): reads `patient_medications` (joined with `medicines` for the name) and writes `medication_logs`. `medication_schedules` is still not used, has no RLS and a likely bug (FK columns defaulting to `gen_random_uuid()`). **Still open, blocking:** as of this migration history, `patient_medications`/`medication_logs`/`medicines` have never had `GRANT SELECT`/`INSERT`/`UPDATE` added for `authenticated` (checked every migration since 2026-10-14; only `profiles` got fixed, 2026-10-15). Every query here will fail with `permission denied` (same as the `profiles` issue) until that grant is added. Confirm it's been run before relying on this feature working.
2. **Measurements without an account:** ~~undecided~~ **Resolved 2026-10-15.** The backend supports anonymous inserts (`patient_id = null`, RLS policy `measurements: insert own or anonymous`), and a `claim_measurements(uuid[])` RPC attaches local-only measurement ids to the account after registration (Section 4). **Still open:** mobile doesn't implement either side of this yet (Section 9 step 4) — that's an implementation task, not a backend question anymore.
3. **`invalid_reason` values:** the contract says "see below" but the list is not written. Until confirmed, use `low_sampling_rate`, `sampling_gap`, `voluntary_movement`, `clipping`, `high_noise`, `too_short`, plus two the mobile app needed and the backend hasn't seen yet: `flat_signal` (constant/all-zero signal — dead sensor or missing recording; `GateCheck.flatSignal` had no listed string) and `interrupted` (app left the foreground mid-recording — never reaches the DSP gates at all).
4. **`device` object:** not written out in the contract. Until confirmed, send `model`, `os` (`android` or `ios`), `app_version`, `effective_sampling_hz`.
5. ~~Registration method and fields~~ **Resolved 2026-10-15.** Email and password, plus `full_name` and `phone` (both required, since `profiles.phone` is `NOT NULL`). Both are sent via `signUp()`'s `data` map.
6. **Weekly check reminders:** intended product behavior, not in the contract. Needs a decision before adding a local-notification package.
7. ~~**Four-second window:**~~ **Resolved 2026-10-10.** Checked against the demo's shipped `dsp_config.json` and golden tests: `dropEdgeS` (3.0 s) + one Welch `segmentS` (4.0 s) need 7.0 s of recording before the pipeline can produce anything, so a 4 s minimum is structurally impossible. The app's minimum recording length is now **8 s**, not 4 s (Section 2, Section 10 step 4). Still open: these values were tuned against the demo's fixed 20–25 s recordings, never validated at 8 s specifically — revisit once real 8–12 s recordings are available.
8. **Sensor units and timestamps:** confirm on a device, then record here: whether `event.timestamp` is hardware sensor time or arrival time, whether Android 12+ needs `HIGH_SAMPLING_RATE_SENSORS` to reach about 100 Hz on target phones, and the unit of `userAccelerometer` (expected m/s²).
9. **Doctor account signing in on mobile:** the exact message and flow.

---

## 14. Out of scope (do not add unless explicitly asked)

Dio or a custom HTTP client, a service locator, a use-case layer, a UI strings file or constants class, analytics, push notifications, localization frameworks, raw-signal storage or export, `postural` recordings, gait/voice/handwriting analysis, anything that outputs a diagnosis, the doctor-side UI, and any backend implementation (tables, RLS, functions) which belongs to the backend team.

---

## 15. Commands

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # Freezed / JSON generated code
dart format .
flutter analyze
flutter test
flutter run                                                # on a physical device
```

---

## 16. Working agreements

- Ask before adding a dependency, a new feature folder, or a new architectural layer.
- Never invent literature values, citations, accuracy numbers, or validation results. Unknown means `TODO(calibrate)` or an entry in Section 13.
- The data contract is the source of truth for anything sent to or received from the backend. Do not add, rename, or drop fields on your own; raise it instead.
- Keep `lib/dsp/` pure. If a change would make it import Flutter, Cubit, Hive, Supabase, or any app code, stop and restructure.
- No barrel files. Import files directly with `package:` imports.
- UI strings in Bahasa Indonesia, everything developer-facing in English.
- Never write result text that implies a diagnosis (Section 2 and Section 8).
- Run `dart format`, `flutter analyze`, and `flutter test` before reporting work as done, and state what you ran.
- Commit messages: English, imperative mood, one logical change per commit.
