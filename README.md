# Realtime Chat Flutter App 💬

A real-time chat application built with Flutter and Supabase. This app allows users to authenticate, join chat rooms, and send messages instantly across devices.

---

## 🚀 Features
- **Realtime messaging** powered by Supabase Realtime
- **Email & password authentication**
- **Persistent message storage** in Supabase Postgres
- **Cross-platform** support for Android & iOS
- **Responsive and clean UI**

---

## 📂 Project Structure
- lib/
- ├── auth/ # Authentication screens
- ├── chat/ # Chat room list & message screens
- ├── models/ # Data models
- ├── services/ # Supabase client and services
- ├── widgets/ # Reusable UI components
- ├── constants.dart # Supabase credentials
- └── main.dart # App entry point

## 📂 Project Screenshots

<p float="left">
  <div align="center">
    <strong>Register Screen</strong><br>
    <img src="https://github.com/UmarTanwar3527/realtime_chat_flutterapp/blob/main/appsereenshots/Media%20(2).jpg" alt="Register Screen" width="250"/>
  </div>

  <div align="center">
    <strong>SignIn Screen</strong><br>
    <img src="https://github.com/UmarTanwar3527/realtime_chat_flutterapp/blob/main/appsereenshots/Media%20(1).jpg" alt="SignIn Screen" width="250"/>
  </div>
</p>

<p float="left">
  <div align="center">
    <strong>Home Screen</strong><br>
    <img src="https://github.com/UmarTanwar3527/realtime_chat_flutterapp/blob/main/appsereenshots/Media.jpg" alt="Home Screen" width="250"/>
  </div>

  <div align="center">
    <strong>Chat Screen</strong><br>
    <img src="https://github.com/UmarTanwar3527/realtime_chat_flutterapp/blob/main/appsereenshots/Media%20(3).jpg" alt="Chat Screen" width="250"/>
  </div>
</p>



---

## 🛠 Getting Started

### 1️⃣ Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Supabase account](https://supabase.com/)

### 2️⃣ Clone the Repository
```bash
git clone https://github.com/UmarTanwar3527/realtime_chat_flutterapp.git
cd realtime_chat_flutterapp
````

### 3️⃣ Install Dependencies

```bash
flutter pub get
```

### 4️⃣ Configure Supabase

Create or update `lib/constants.dart`:

```dart
const String SUPABASE_URL = 'https://your-project-ref.supabase.co';
const String SUPABASE_ANNON_KEY = 'your-anon-key';
```

### 5️⃣ Run the App

```bash
flutter run
```

---

## 📡 How It Works

1. User signs up or logs in via email/password.
2. App fetches available chat rooms from Supabase.
3. User joins a room, messages are fetched from the database.
4. Supabase Realtime listens for new messages and updates instantly.

---

## 📦 Dependencies

* [supabase\_flutter](https://pub.dev/packages/supabase_flutter)
* [flutter\_riverpod](https://pub.dev/packages/flutter_riverpod)
* [uuid](https://pub.dev/packages/uuid)
* [intl](https://pub.dev/packages/intl)
* [flutter\_dotenv](https://pub.dev/packages/flutter_dotenv)

---

## 📋 Database Schema

**rooms**

* `id` (uuid, PK)
* `name` (text)
* `created_at` (timestamp)

**messages**

* `id` (uuid, PK)
* `room_id` (uuid, FK)
* `user_id` (uuid, FK)
* `content` (text)
* `created_at` (timestamp)

---

## 🔮 Future Improvements

* Typing indicators
* Image/file sharing
* Push notifications
* Online user presence
* Dark mode support

---
