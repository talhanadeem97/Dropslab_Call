# Dropslab Call

**Dropslab Call** is a Flutter-based VoIP and video calling application built on the **Matrix protocol**.
It integrates **offline voice command support via the Vivoka SDK** and is designed **exclusively for ARSpectra Android devices**.

The application enables users to initiate and manage voice or video calls while interacting with the system through **hands-free voice commands**, making it suitable for **AR, industrial, and field environments** where manual interaction may be limited.

---

# Project Overview

This application provides a **Matrix-based communication client** with integrated **WebRTC calling** and **offline voice control**.

Key capabilities include:

* Voice and video calling using the **Matrix protocol**
* **Hands-free interaction** using Vivoka offline voice commands
* Secure communication with **Matrix end-to-end encryption**
* Optimized UI and workflows for **ARSpectra smart devices**
* Android-only deployment

The system is designed specifically for **AR-assisted workflows and industrial use cases** where users may need to operate the device without direct touch interaction.

---

# Architecture

The application uses the following core technologies:

* **Framework:** Flutter (Dart)
* **Protocol:** Matrix (decentralized messaging and calling)
* **WebRTC:** `flutter_webrtc` for peer-to-peer audio/video communication
* **Voice Commands:** Vivoka SDK integrated through Flutter `MethodChannel` and `EventChannel`
* **Encryption:** `flutter_vodozemac` for Matrix end-to-end encryption
* **Local Storage:** SQLite via `sqflite`

---

# Project Structure

Important files and directories in the project:

* **`lib/main.dart`**
  Application entry point. Initializes the Matrix client, Vivoka SDK, and application providers.

* **`lib/voip/voip_service.dart`**
  Core VoIP service responsible for WebRTC session and call management.

* **`lib/voip/call_screen.dart`**
  User interface for active voice or video calls.

* **`lib/voip/login_screen.dart`**
  Matrix login interface.

* **`lib/voip/vivoka_sdk.dart`**
  Flutter wrapper for the Vivoka native Android SDK.

* **`android/`**
  Android-specific code including Vivoka SDK integration written in Kotlin.

* **`assets/vodozemac/`**
  WebAssembly files used for Matrix encryption.

---

# Development Environment

The application is developed using **Flutter Stable Channel**.

**Environment Details**

* Flutter Version: **3.41.2**
* Dart Version: **3.11.0**
* DevTools Version: **2.54.1**
* Operating System: **macOS 15.7.5 (darwin-x64)**

Flutter SDK installation path:

```
/Users/macbookpro/flutter
```

Add Flutter to the system PATH:

```bash
export PATH="$PATH:/Users/macbookpro/flutter/bin"
```

This configuration enables building and running the application with **Android as the primary target platform** for ARSpectra devices.

---

# Project Configuration

Project settings and dependencies are defined in the `pubspec.yaml` file.

### Project Information

* **Project Name:** `dropslab_call`
* **Version:** `1.0.0+1`
* **Publishing:** Private project (`publish_to: none`)

### SDK Environment

```
sdk: ^3.10.7
```

This ensures compatibility with the Flutter environment used in the project.

---

# Core Dependencies

The project uses several Flutter packages to support communication, media handling, and device features.

| Package                   | Purpose                              |
| ------------------------- | ------------------------------------ |
| matrix                    | Matrix client SDK                    |
| flutter_webrtc            | WebRTC voice and video communication |
| webrtc_interface          | WebRTC interface utilities           |
| camera                    | Camera access for video calls        |
| camera_platform_interface | Platform camera interface            |
| permission_handler        | Runtime permission management        |
| flutter_ringtone_player   | Incoming call ringtone playback      |
| call_sound_controller     | Call sound and audio control         |
| just_audio                | Audio playback                       |
| provider                  | State management                     |
| sqflite                   | Local database storage               |
| path_provider             | File system access                   |
| flutter_zxing             | Barcode and QR code scanning         |
| torch_light               | Flashlight control                   |
| flutter_volume_controller | Volume management                    |
| restart_app               | Application restart functionality    |
| flutter_sficon            | Icon support                         |
| name_avatar               | Avatar generation                    |
| flutter_vodozemac         | Matrix encryption utilities          |

---

# Dependency Overrides

The camera dependency is explicitly overridden to ensure compatibility with dependent libraries:

```
camera: ^0.12.0
```

---

# Development Dependencies

| Package       | Purpose                               |
| ------------- | ------------------------------------- |
| flutter_test  | Flutter testing framework             |
| flutter_lints | Recommended lint rules for clean code |

---

# Assets

The application includes several asset directories used at runtime.

| Directory         | Purpose                    |
| ----------------- | -------------------------- |
| assets/           | General application assets |
| assets/vodozemac/ | Matrix encryption files    |
| assets/sounds/    | Ringtones and call sounds  |

These assets are bundled with the application during the build process.

---

# Deployment

The application is deployed as an **Android APK**.

Build command:

```bash
flutter build apk --release
```

Generated output:

```
build/app/outputs/flutter-apk
```

The generated APK can then be installed directly on **ARSpectra Android devices**.
