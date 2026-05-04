# 🌤️ Flutter Weather App — Full Stack

A premium, production-ready weather application built with **Flutter** (frontend) and **Node.js + Express** (backend). Features glassmorphism UI, animated gradient backgrounds, shimmer loading effects, and real-time weather data from OpenWeatherMap.

---

## 📁 Project Structure

```
Weather-App/
├── backend/                    # Node.js Express server
│   ├── package.json
│   ├── server.js               # Main server with caching
│   ├── .env                    # API key (create from .env.example)
│   └── .env.example
│
├── weather_app/                # Flutter project
│   ├── lib/
│   │   ├── main.dart           # App entry point
│   │   ├── config/
│   │   │   └── constants.dart  # API URLs, colors, gradients
│   │   ├── models/
│   │   │   └── weather_model.dart
│   │   ├── services/
│   │   │   └── weather_service.dart
│   │   ├── screens/
│   │   │   ├── home_screen.dart
│   │   │   └── search_screen.dart
│   │   └── widgets/
│   │       ├── glass_container.dart
│   │       ├── detail_chip.dart
│   │       ├── weather_card.dart
│   │       ├── weather_icon_widget.dart
│   │       ├── shimmer_loading.dart
│   │       └── error_view.dart
│   └── pubspec.yaml
```

---

## 🚀 Setup Instructions

### Prerequisites
- **Node.js** (v18+) and **npm**
- **Flutter SDK** (3.x+) with `flutter doctor` passing
- **OpenWeatherMap API key** (free) — [Sign up here](https://home.openweathermap.org/users/sign_up)

### Step 1: Configure Backend

```bash
cd backend

# 1. Install dependencies
npm install

# 2. Set your API key
# Edit .env and replace 'your_api_key_here' with your actual key
notepad .env

# 3. Start the server
npm start
```

You should see:
```
🌤️  Weather Backend running on http://localhost:3000
   API Key: ✅ Configured
```

### Step 2: Test the Backend

```bash
curl http://localhost:3000/weather?city=London
```

### Step 3: Run Flutter App

```bash
cd weather_app

# Get dependencies
flutter pub get

# Run on connected device / emulator
flutter run
```

### ⚠️ Important Notes

- **Android Emulator**: The app uses `10.0.2.2:3000` which maps to your host machine's `localhost`. The backend must be running on your PC.
- **Physical Device**: Change `baseUrl` in `lib/config/constants.dart` to your PC's local IP address (e.g., `http://192.168.1.x:3000`).
- **Web / Desktop**: Change `baseUrl` to `http://localhost:3000`.

---

## ✨ Features

- 🎨 **Dynamic gradient backgrounds** — Changes based on weather conditions
- 🔮 **Glassmorphism cards** — Blur + transparency with soft borders
- ✨ **Smooth animations** — Fade-in, slide, scale, shimmer
- 🔄 **Pull-to-refresh** — Reload current weather
- 🔍 **City search** — Search any city worldwide
- 🌐 **Popular cities** — Quick-select 12 major cities
- 💾 **Persistence** — Remembers last searched city
- 🌙 **Night mode** — Gradient adapts to sunrise/sunset times
- ⚡ **Backend caching** — 10-minute cache to reduce API calls
- 🛡️ **Error handling** — Friendly error UI with retry button

---

## 🛠️ Tech Stack

| Layer    | Technology          | Purpose                     |
|----------|--------------------|-----------------------------|
| Frontend | Flutter (Dart)     | Cross-platform UI           |
| Backend  | Node.js + Express  | API proxy & caching         |
| API      | OpenWeatherMap     | Real-time weather data      |
| Fonts    | Google Fonts       | Outfit font family          |
| State    | setState           | Simple, clean state mgmt    |

------------------------------------------------------

Made with ❤️ by Piyush Goel | [GitHub](https://github.com/the_piyushgoel)
