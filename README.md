# HD Images

HD Images is a Flutter application designed to enhance the quality of user photos directly on the device. It allows users to select images from their gallery, improve image resolution using local processing methods, and save the output without uploading any content to a remote server.

## Features

- Select photos from the gallery
- Improve image quality using local processing
- Sign in with Google account
- Support regular user sign-in flow
- Keep all data and processed output on the device
- User-friendly and responsive interface
- Clean Architecture-based structure
- Firebase Authentication integration
- Local caching and performance-focused data flow

## Purpose

The main goal of this project is to transform low-resolution user photos into sharper and higher-quality images using device-side processing. The app is designed to prioritize:

- privacy
- local processing
- no cloud storage of user images
- fast and efficient user experience

## Tech Stack

- Flutter
- Dart
- Clean Architecture
- Firebase Authentication
- Google Sign-In
- Dio
- Go Router
- GetIt
- Flutter Bloc
- Shared Preferences
- Image Picker
- TensorFlow Lite / local model-based image enhancement
- JSON Serializable
- Very Good Analysis

## Architecture

The project is structured according to Clean Architecture principles:

- features
  - feature_1
    - data
      - data_sources
      - models
      - repositories_impl
    - domain
      - models
      - repositories
      - usecases
    - presentation
      - cubit
      - pages
      - widgets
- core
  - utils
  - constants
  - theme
  - navigation
  - localization
  - notifications
  - responsive_screen
  - extensions

This structure helps keep the project:
- modular
- testable
- maintainable
- scalable
- decoupled across layers

## Project Principles

The following standards are recommended for this project:

- Repository layer should be abstracted with abstract classes
- Models should use `json_serializable` for JSON serialization
- `build_runner` should be used to generate code automatically
- Use case names should end with `_usecase`
- Cubits should not be overused or unnecessarily reinitialized
- API calls should use `dio` and include interceptor-based logging
- Prefer atomic widgets while keeping code readable
- Reusable widgets should be placed in the `widgets` folder
- Text should be managed through `app_text.dart`
- Navigation should use `go_router`
- Layout sizing and padding should use `responsive_screen.dart`
- Use `debugPrint` for logs and error tracking
- Use `fluttertoast` for user feedback
- Use `very_good_analysis` for linting rules
- Use `get_it` for dependency injection
- Use Firebase Authentication for authentication flows

## Project Structure

```text
hd_images/
├── android/
├── ios/
├── linux/
├── macos/
├── windows/
├── web/
├── assets/
│   ├── translations/
│   └── models/
├── lib/
│   ├── core/
│   ├── features/
│   ├── main.dart
│   └── app.dart
├── test/
├── tools/
├── .metadata
├── .gitignore
├── analysis_options.yaml
├── firebase.json
├── pubspec.yaml
├── README.md
└── instructions.txt
```

## Requirements

Make sure the following tools are installed:

- Flutter SDK 3.11+
- Dart SDK 3.11+
- Android Studio or VS Code
- Xcode (for macOS only)
- Firebase CLI (optional)
- Python (for research and experimentation with image enhancement models)

## Installation

1. Clone the repository:

```bash
git clone https://github.com/aguCompbbky/hd_images.git
cd hd_images
```

2. Install dependencies:

```bash
flutter pub get
```

3. Generate code if needed:

```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Run the app:

```bash
flutter run
```

## Firebase and Authentication

The project uses Firebase Authentication and Google Sign-In for user login. To configure it:

1. Create a new project in Firebase Console
2. Add Android and iOS apps
3. Download and place `google-services.json` and `GoogleService-Info.plist`
4. Enable the required authentication methods in Firebase
5. Configure Google Sign-In and required certificate settings

## Image Enhancement Approach

The enhancement process should run locally on the user's device. This ensures:

- images are not uploaded to external servers
- the processed output remains on the device
- the app works without requiring a constant network connection

### Recommended approach

Python can be used during the research and model experimentation phase. Possible methods include:

- ESRGAN / Real-ESRGAN
- lightweight super-resolution models
- TensorFlow Lite conversion
- local execution through `tflite_flutter` in Flutter

This approach preserves both device performance and user privacy.

## Local Workflow

The expected app workflow is:

1. User selects an image
2. The image is processed locally on the device
3. The model enhances the image quality
4. The output is displayed to the user
5. The improved image is saved locally
6. No external data is transmitted

## Privacy and Security

- User data remains on the device
- Images are not uploaded to third-party servers
- Privacy is treated as a core requirement
- Processed files remain in local storage

## Roadmap

- [ ] Set up the base Flutter project
- [ ] Create Clean Architecture layers
- [ ] Integrate authentication flow
- [ ] Set up Firebase
- [ ] Implement gallery and image selection
- [ ] Develop image enhancement logic
- [ ] Integrate a local model
- [ ] Save enhanced output
- [ ] Improve caching and performance
- [ ] Add testing and error handling
- [ ] Improve the overall user experience

## Contributing

If you would like to contribute:

1. Fork the repository
2. Create a new branch
3. Make your changes
4. Open a pull request
