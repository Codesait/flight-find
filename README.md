# flight_search

A Flutter flight search demo app using Riverpod for state management.

## Features
- Search for flights by selecting origin, destination, date, and filters
- Cities and flights loaded from local JSON asset
- Robust error and loading state handling
- Results page displays matching flights and search summary

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x recommended)
- Dart (comes with Flutter)

### Install dependencies
```
flutter pub get
```

### Run the app
```
flutter run
```

### Notes
- Make sure your emulator or device is running.
- If you add or change assets, run `flutter pub get` and restart the app.
- The app uses local JSON data in `assets/dummy/dummy_flight_data.json`.
- If you see 'No flights found', try searching for:
  - From: New York, To: Los Angeles
  - From: Los Angeles, To: New York
  - From: New York, To: Dallas

## Project Structure
- `lib/features/flight_search/` — main feature code (UI, provider, model)
- `assets/dummy/dummy_flight_data.json` — flight and city data

## Troubleshooting
- If you get asset errors, check that the asset is registered in `pubspec.yaml` under `flutter/assets`.
- For any issues, try a full restart: stop the app and run `flutter run` again.

---

For more info, see the [Flutter documentation](https://docs.flutter.dev/).
