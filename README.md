# fyp_chat_app

see also https://github.com/chanjeff2/fyp-chat-server

## File Structure

    .
    ├───android         # files for Android
    ├───ios             # files for iOS
    ├───lib
    │   ├───dto         # objects you get from server
    │   ├───models      # classes used in the app
    │   ├───network     # APIs
    │   ├───screens     # app screens
    │   ├───signal      # Signal protocol library related
    │   └───storage     # local storage
    └───test

## Getting Started

### json_serializable 

use `flutter pub run build_runner watch --delete-conflicting-outputs` to generate code for `./lib/dto/*.dart`

pub.dev: https://pub.dev/packages/json_serializable

flutter doc: https://docs.flutter.dev/development/data-and-backend/json#serializing-json-using-code-generation-libraries 

### Provider

app state management

pub.dev: https://pub.dev/packages/provider

flutter doc: https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple
---

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
