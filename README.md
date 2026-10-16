<div align="center">

# NuroPulse App

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white) ![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=flat-square&logo=supabase&logoColor=white)

![go_router](https://img.shields.io/pub/v/go_router?style=for-the-badge&logo=dart&label=go_router&color=02569B) ![flutter_bloc](https://img.shields.io/pub/v/flutter_bloc?style=for-the-badge&logo=dart&label=flutter_bloc&color=0175C2) ![hive](https://img.shields.io/pub/v/hive?style=for-the-badge&logo=dart&label=hive&color=F7B500)

The codebase for NuroPulse's patient-facing mobile app, **a Parkinson’s companion app that screens for hand tremor** in under half a minute using just your phone’s sensors, **then connects you and your neurologist** with your medication and tremor history.

</div>

## Getting started

```bash
cp .env.example .env   # fill in your Supabase project URL and publishable (anon) key
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generates Freezed / JSON code
dart format .
flutter analyze
flutter test
flutter run                                                 # physical Android device
```

`.env` is git-ignored; `flutter_dotenv` loads it at startup (`core/environments/env.dart`) before `Supabase.initialize()` runs. Without it, the app fails fast with a clear error rather than silently misconfiguring Supabase.

## DSP pipeline

`lib/dsp/` is pure Dart (no Flutter, no I/O) and deterministic: the same `DspInput` always produces the same `TremorResult`. `TremorPipeline.analyze()` in [`lib/dsp/tremor_pipeline.dart`](./lib/dsp/tremor_pipeline.dart) orchestrates the stages below in order; any gate failure short-circuits straight to an `invalid` result instead of running the remaining stages.

All thresholds, filter coefficients, and band edges come from [`assets/config/dsp_config.json`](./assets/config/dsp_config.json) (`DspConfig`).

```mermaid
flowchart TD
    IN(["DspInput<br/>tUs · x · y · z @ ~100Hz"]) --> QC["QcSampling.measure<br/>effective rate, max gap, monotonic?"]

    QC --> G1{"Gate: checkSampling<br/>monotonic AND<br/>effectiveFsHz ≥ 50 AND<br/>maxGapMs ≤ 200 AND<br/>durationS ≥ 8s"}
    G1 -->|fail| INV1[["invalid<br/>sampling / dataGap / tooShort"]]

    G1 -->|pass| RS["Resampler.toTargetRate ×3 axes<br/>1 interpolate onto uniform 100Hz grid<br/>2 anti-alias low-pass @ 20Hz, order 4, filtfilt<br/>3 decimate → 50Hz (targetFsHz)"]
    RS --> DM["demean ×3 axes<br/>subtract per-axis mean"]
    DM --> BP["SosFilter.filtfilt ×3 axes<br/>band-pass 1–20Hz, Butterworth order 2, zero-phase"]
    BP --> ED["drop first dropEdgeS = 3.0s<br/>trims filter transient + post-countdown tap"]
    ED -->|too few samples left| INV2[["invalid: tooShort"]]

    ED --> G2{"Gate: checkFlatSignal<br/>all 3 resampled axes constant?"}
    G2 -->|yes, dead sensor| INV3[["invalid: flatSignal"]]

    G2 -->|no| WE["Welch.compute per filtered axis<br/>4.0s segments · 50% overlap · Hann window · nfft 256<br/>matches scipy.signal.welch(detrend='constant', scaling='density')"]
    WE --> SUM["sum PSD across x, y, z<br/>(not vector magnitude — avoids doubling apparent frequency)"]
    SUM -->|signal shorter than one segment| INV4[["invalid: tooShort"]]

    SUM --> FE["FeatureExtractor.compute"]
    FE --> F1["peakFrequencyHz<br/>argmax in 3–12Hz (peakSearchHz)<br/>+ parabolic interpolation"]
    FE --> F2["bandPowerRatio<br/>∫3.5–7Hz power / ∫1–15Hz power"]
    FE --> F3["snr<br/>peak power / median power in 1–15Hz"]
    FE --> F4["bandRms (g)<br/>√(∫3.5–7Hz power)"]
    FE --> F5["consistency<br/>fraction of Welch segments whose own<br/>peak falls in 3.5–7Hz"]

    F1 --> DR["DecisionRule.decide"]
    F2 --> DR
    F3 --> DR
    F4 --> DR
    F5 --> DR

    DR --> G3{"peak in tremorBandHz 3.5–7Hz AND<br/>snr ≥ 4.0 AND<br/>bandPowerRatio ≥ 0.3 AND<br/>consistency ≥ 0.6 ?"}
    G3 -->|yes| TREMOR[["tremor"]]
    G3 -->|no| NONE[["none"]]

    classDef invalid fill:#FFF5C2,stroke:#735C00,color:#735C00
    classDef tremor fill:#FCE6E4,stroke:#B3261E,color:#B3261E
    classDef none fill:#EBFCEF,stroke:#0E6936,color:#0E6936

    class INV1,INV2,INV3,INV4 invalid
    class TREMOR tremor
    class NONE none
```

## Dependencies

| Package                                  | Version           | Purpose                                              |
| ---------------------------------------- | ----------------- | ---------------------------------------------------- |
| `flutter_bloc`                           | ^9.1.1            | State management (Cubit, no Bloc events)             |
| `freezed` / `freezed_annotation`         | 3.2.5 / ^3.1.0    | Immutable Cubit states & data models                 |
| `json_serializable` / `json_annotation`  | ^6.14.1 / ^4.12.0 | JSON (de)serialization for models                    |
| `go_router`                              | ^18.0.1           | Declarative routing (`services/router_service.dart`) |
| `hive_ce` / `hive_ce_flutter`            | ^2.20.1 / ^2.4.0  | Local storage for measurements & settings            |
| `sensors_plus`                           | ^7.1.1            | Accelerometer sampling for the tremor check          |
| `fftea`                                  | ^1.5.0+1          | FFT for the on-device DSP pipeline                   |
| `fl_chart`                               | ^1.2.0            | Frequency-spectrum chart on the detail screen        |
| `flutter_svg`                            | ^2.3.0            | SVG icons/logo rendering                             |
| `lottie`                                 | ^3.6.1            | Pulse animation on the processing screen             |
| `google_nav_bar`                         | ^5.0.7            | Bottom navigation bar for the home shell             |
| `wakelock_plus`                          | ^1.8.1            | Keeps the screen on while recording                  |
| `device_info_plus` / `package_info_plus` | ^13.3.0 / ^10.2.2 | Device & app metadata sent with a measurement        |
| `path_provider`                          | ^2.1.6            | Filesystem paths for local storage                   |
| `uuid`                                   | ^4.6.0            | Client-generated measurement IDs                     |
| `share_plus`                             | ^13.3.1           | Sharing results/history                              |
| `logger`                                 | ^2.8.0            | Wrapped by `services/logger_service.dart`            |
| `supabase_flutter`                       | ^2.18.3           | Backend client — auth & data, not yet wired past init |
| `flutter_dotenv`                         | ^6.0.1            | Loads `.env` for `core/environments/` (Supabase URL/anon key) |
| `flutter_secure_storage`                 | planned           | Auth session storage, once implemented               |

Dev-only: `flutter_lints`, `build_runner`, `bloc_test`, `mocktail`, `flutter_launcher_icons`.
