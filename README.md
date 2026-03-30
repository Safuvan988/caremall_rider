# Caremall Rider

**Caremall Rider** is the dedicated delivery partner application for the Care Mall platform, built with Flutter. It provides riders with the tools they need to receive, manage, and fulfill customer orders efficiently, featuring integrated map navigation and seamless communication functionality.

## 📱 Core Features
- **Delivery Management:** View, accept, and update the status of incoming delivery requests.
- **Real-time Navigation:** Integrated with Google Maps for accurate routing and trip tracking.
- **Responsive UI:** Fully responsive design using `flutter_screenutil` to ensure a consistent experience across all mobile devices.
- **State Management:** Powered by GetX for snappy, reactive state management and seamless app routing.
- **Secure Local Storage:** Handles user preferences and session data safely using `shared_preferences`.

## 🛠️ Tech Stack & Architecture

- **Framework:** Flutter (SDK: ^3.10.7)
- **State Management & Routing:** [GetX](https://pub.dev/packages/get)
- **Networking:** [http](https://pub.dev/packages/http)
- **Maps Integration:** [google_maps_flutter](https://pub.dev/packages/google_maps_flutter)
- **UI Elements:**
  - [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) (for scaling UI)
  - [google_fonts](https://pub.dev/packages/google_fonts) (for typography)
  - [flutter_svg](https://pub.dev/packages/flutter_svg) (for scalable icons & illustrations)
- **Utilities:** `logger`, `intl`, `image_picker`, `url_launcher`

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (`^3.10.7` or newer recommended)
- Android Studio / Visual Studio Code
- Properly configured API Keys (e.g., Google Maps API Key)

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd caremall_rider
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Set up API Keys:**
   - Define your Google Maps API key in `android/app/src/main/AndroidManifest.xml`.
   - Ensure iOS map configurations in `ios/Runner/AppDelegate.swift` are set up.

4. **Run the application:**
   ```bash
   flutter run
   ```

## 📦 Key Dependencies
- `get`: robust routing and state management
- `google_maps_flutter`: displaying maps & polyline routes
- `flutter_screenutil`: making UI uniform across varying screen dimensions
- `http`: REST API communication
- `shared_preferences`: cache and local persistence

## 📄 License
This project is proprietary and intended for internal use by the Care Mall delivery system.
