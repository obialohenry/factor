# Copilot Instructions for `factor`

- This is a Flutter 3.8 application; keep platform code under `lib/` and rely on `flutter pub get`, `flutter analyze`, and `flutter test` for the core workflow. Run UI builds with `flutter run` once dependencies are fetched.
- `lib/src/` re-exports the public surface (components, config, repository, etc.). Prefer importing from `package:factor/src/<module>.dart` so shared widgets and services stay centralized.
- UI code lives in `lib/view/`; compose screens with the custom primitives in `view/components/` (`TextView`, `Gap`, `FactorsAppBars`). Reuse `FactorColorsDark` and `FactorStrings` from `lib/cofig/` instead of hard-coding styles or strings.
- `ExchangeRateScreen` is the primary entry point. Keypad presses call the singleton `ExchangeRateCalculator` (`lib/view_model/exchange_rate_calculator.dart`); mutate its state via the provided methods and call `setState` in the screen to refresh.
- `ExchangeRateCalculator` keeps global state (selected coin/currency, keypad digits, font scaling). When adding new reactive data, extend this class and remember it is a singleton—avoid storing BuildContext or disposable objects inside it.
- Real-time pricing should go through the repository layer: `FactorsBackend.getPriceBackend` wraps `ApiServices.get`, which uses Dio with Jupiter Lite (`lite-api.jup.ag`). Add new endpoints in `ApiConstants` so headers and base paths remain consistent.
- Handle rate limiting and networking errors with the custom exceptions in `lib/repository/exception/custom_exception.dart`; surface human-friendly messages through `showToast` (BotToast wrapper) rather than raw snackbars.
- If you need mock data (e.g., offline token list), check `assets/json/crypto.json` and keep JSON shape aligned with `TokenResponseModel` / `PriceResponseModel`.
- Format numeric output with `UtilFunctions.formatAmount`; it preserves user-entered decimals and drives the dynamic text sizing logic.
- The select coin/currency screens toggle between search and list views using `ExchangeRateCalculator` flags. Keep interaction locks (`isSelectCoinScreenInteractionDisabled`, etc.) in sync when adding new overlays or animations.
- Fonts are configured for the Inter family (regular weight only). Add new weights via `pubspec.yaml` if you need them, and remember to bump `flutter pub get`.
- `widget_test.dart` still holds the Flutter counter scaffold and does not exercise current screens. Replace or extend it if you introduce behavior changes that should be tested.
- Common color adjustments or asset additions belong in `lib/cofig/` (`FactorColorsDark`, `FactorImages`); update the re-export file so downstream imports keep working.
- Logging is currently done with `print` statements in `ApiServices`; keep them or swap in a logger, but respect the 30-second timeout already applied to Dio.
- When adding new services or repositories, extend `ApiServices` to inherit error handling and header setup, and surface high-level methods from a `Backend` class mirroring `FactorsBackend`.
- BotToast is wired via `MaterialApp.builder` in `main.dart`; do not remove `BotToastNavigatorObserver()` or notifications will fail.
