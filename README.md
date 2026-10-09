<div align="center">

# NuroPulse App

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white) ![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=flat-square&logo=supabase&logoColor=white)

![go_router](https://img.shields.io/pub/v/go_router?style=for-the-badge&logo=dart&label=go_router&color=02569B) ![flutter_bloc](https://img.shields.io/pub/v/flutter_bloc?style=for-the-badge&logo=dart&label=flutter_bloc&color=0175C2) ![hive](https://img.shields.io/pub/v/hive?style=for-the-badge&logo=dart&label=hive&color=F7B500)

The codebase for NuroPulse's patient-facing mobile app, **a Parkinson’s companion app that screens for hand tremor** in under half a minute using just your phone’s sensors, **then connects you and your neurologist** with your medication and tremor history.

</div>

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
| `fl_chart`                               | ^1.2.0            | History trend charts                                 |
| `flutter_svg`                            | ^2.3.0            | SVG icons/logo rendering                             |
| `wakelock_plus`                          | ^1.8.1            | Keeps the screen on while recording                  |
| `device_info_plus` / `package_info_plus` | ^13.3.0 / ^10.2.2 | Device & app metadata sent with a measurement        |
| `path_provider`                          | ^2.1.6            | Filesystem paths for local storage                   |
| `uuid`                                   | ^4.6.0            | Client-generated measurement IDs                     |
| `share_plus`                             | ^13.3.1           | Sharing results/history                              |
| `logger`                                 | ^2.8.0            | Wrapped by `services/logger_service.dart`            |
| `supabase_flutter`                       | planned           | Auth & backend data, once implemented                |
| `flutter_secure_storage`                 | planned           | Auth session storage, once implemented               |
| `flutter_dotenv`                         | planned           | Supabase URL/anon key from `.env`, once implemented  |

Dev-only: `flutter_lints`, `build_runner`, `bloc_test`, `mocktail`.
