![scanningworld](https://i.imgur.com/WuBu4TY.png)

# Flutter Scanning World App

Scanning World is a mobile cross-platform application.

## Features

- Login/Register with phone number and password
    - after successfully register set your 4 digits code for future sign in
    - if device supports Biometric Authentication like Face ID or Touch ID user can sign in with
      that instead of 4-digits PIN
- Scan QR codes
    - User can check where are QR codes on the map
    - Check if user is near QR Code
    - Check if user didn't scan this code yet and the code is in the region(city) chosen by user
    - Add points to User Account
- Order Coupons
    - if user has enough money, he/she can buy some coupons (valid for 15 minutes)

## Installation

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)z

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on
mobile development, and a full API reference.

1. Download the and install flutter latest SDK
   from [here](https://docs.flutter.dev/get-started/install)
2. Extract the file
3. Add flutter to your system path

```sh
export PATH="$PATH:{your_path_to_flutter_sdk}/bin"
```

## Android Setup

##### You can download the app directly from google play from this [link]()

---

#### Manually setup

1. Download, install and setup Android Studio (also setup android SDK).
2. Add Dart and flutter plugin to the IDE
3. Connect your phone and run command (add --release for the release mode)

```sh
flutter run
```

4. For more info click [here](https://docs.flutter.dev/get-started/install/macos#android-setup)

## iOS Setup

1. Install Xcode
2. To install app to a physical device you need physical device deployment in Xcode and an Apple
   Developer account.
3. At the first time connect you need to trust your device also in iOS **^16**  you need to enable
   developer mode
4. For more info
   click [here](https://docs.flutter.dev/get-started/install/macos#deploy-to-ios-devices)

## Plugins

Scanning world is currently extended with the following plugins.

| Plugin | README |
| ------ | ------ |
| flutter_platform_widgets | [packages/flutter_platform_widgets](https://pub.dev/packages/flutter_platform_widgets) |
| google_fonts | [packages/google_fonts](https://pub.dev/packages/google_fonts) |
| dio | [packages/dio](https://pub.dev/packages/dio) |
| flutter_svg | [packages/flutter_svg](https://pub.dev/packages/flutter_svg) |
| local_auth | [packages/local_auth](https://pub.dev/packages/local_auth)|
| provider | [packages/provider](https://pub.dev/packages/provider) |
| flutter_secure_storage | [packages/flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) |
| pinput | [packages/pinput](https://pub.dev/packages/pinput) |
| shared_preferences | [packages/shared_preferences](https://pub.dev/packages/shared_preferences) |
| flutter_map | [packages/flutter_map](https://pub.dev/packages/flutter_map) |
| flutter_map_marker_popup | [packages/flutter_map_marker_popup](https://pub.dev/packages/flutter_map_marker_popup) |
| url_launcher | [packages/url_launcher](https://pub.dev/packages/url_launcher) |
| qr_code_scanner | [packages/qr_code_scanner](https://pub.dev/packages/qr_code_scanner) |
| permission_handler | [packages/permission_handler](https://pub.dev/packages/permission_handler) |
| flutter_lazy_indexed_stack | [packages/flutter_lazy_indexed_stack](https://pub.dev/packages/flutter_lazy_indexed_stack) |
| intl | [packages/intl](https://pub.dev/packages/intl) |
| map_launcher | [packages/map_launcher](https://pub.dev/packages/map_launcher) |
| cached_network_image | [packages/cached_network_image](https://pub.dev/packages/cached_network_image) |
| geolocator | [packages/geolocator](https://pub.dev/packages/geolocator) |

## Demo

### Video [link]()
---

### Screenshots (iOS and Android)
![](https://res.cloudinary.com/dybborlve/image/upload/h_500/Simulator_Screen_Shot_-_iPhone_14_Pro_Max_-_2022-10-23_at_20.00_tlwbdz.png)



