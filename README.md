# Thoughts

A Flutter demo project that combines Firebase AI Logic with a physics-based UI built using Flame and Forge2D.

## Demo

https://github.com/user-attachments/assets/8984eccb-3cf2-4b6a-8ddb-8e29f07f62d6

## Tech Stack

- Firebase AI Logic (`firebase_ai`)
- Flame
- Forge2D (`flame_forge2d`)
- Flutter

## Prerequisites

- Flutter SDK installed
- Firebase CLI installed and authenticated
- FlutterFire CLI installed

## Firebase Setup (Required)

You must initialize your own Firebase project before running this app.

1. Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
2. Enable Firebase AI Logic / Gemini API in your Firebase project.
3. Run the following command in this repository:

```bash
flutterfire configure
```

4. Confirm that Firebase configuration files are generated or updated for your target platform(s) (for example, `lib/firebase_options.dart`, Android and iOS Firebase config files).

## Run the App

```bash
flutter pub get
flutter run
```

## Notes

- This repository is a demo project.
- Any checked-in Firebase configuration should be treated as demo-only.
- Replace Firebase configuration with your own Firebase project setup before real use.
