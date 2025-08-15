# FirstAid App

Aplikasi informasi pertolongan pertama untuk berbagai kondisi medis yang dapat digunakan di iOS dan Android.

## 📱 Fitur

- **Kategori Utama**: Pendarahan, Tulang dan Otot, Luka Bakar, Cedera Kepala
- **Informasi Lengkap**: Langkah-langkah pertolongan pertama, gejala, pencegahan, dan tanda peringatan
- **UI/UX Modern**: Desain yang bersih dan mudah digunakan dengan Material Design 3
- **Cross-Platform**: Dapat dijalankan di iOS dan Android
- **Offline**: Data tersimpan lokal menggunakan SQLite

## 🚀 Quick Start

### Prerequisites

Sebelum memulai, pastikan Anda telah menginstall:

- **Flutter SDK** (versi 3.0.0 atau lebih baru)
- **Dart SDK** (biasanya sudah include dengan Flutter)
- **Android Studio** (untuk Android development)
- **Xcode** (untuk iOS development, hanya di macOS)
- **VS Code** (opsional, untuk development)

### 📋 Installation Steps

#### 1. Clone Repository

```bash
git clone <repository-url>
cd FirstAid
```

#### 2. Install Dependencies

```bash
flutter pub get
```

#### 3. Run Aplikasi

```bash
# Untuk development (akan memilih device secara otomatis)
flutter run

# Untuk Android
flutter run -d android

# Untuk iOS
flutter run -d ios
```

#### 4. Build Release Version

```bash
# Build APK untuk Android
flutter build apk --release

# Build IPA untuk iOS
flutter build ios --release
```

## 🛠️ Development Setup

### Flutter Installation

Jika belum ada Flutter, ikuti langkah berikut:

#### Windows
1. Download Flutter SDK dari [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
2. Extract ke folder yang diinginkan (misal: `C:\flutter`)
3. Tambahkan `C:\flutter\bin` ke PATH environment variable
4. Restart terminal dan jalankan `flutter doctor`

#### macOS
```bash
# Menggunakan Homebrew
brew install flutter

# Atau manual download
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.16.5-stable.tar.xz
tar xf flutter_macos_3.16.5-stable.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"
```

#### Linux
```bash
# Menggunakan snap
sudo snap install flutter --classic

# Atau manual download
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.5-stable.tar.xz
tar xf flutter_linux_3.16.5-stable.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"
```

### Android Setup

1. **Install Android Studio**
   - Download dari [developer.android.com](https://developer.android.com/studio)
   - Install Android SDK
   - Setup Android Virtual Device (AVD)

2. **Configure Flutter**
   ```bash
   flutter doctor --android-licenses
   flutter doctor
   ```

3. **Setup Environment Variables** (Windows/Linux)
   ```bash
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/tools
   export PATH=$PATH:$ANDROID_HOME/platform-tools
   ```

### iOS Setup (macOS Only)

1. **Install Xcode**
   - Download dari Mac App Store
   - Install Command Line Tools: `xcode-select --install`

2. **Setup iOS Simulator**
   ```bash
   open -a Simulator
   ```

3. **Configure Flutter**
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   flutter doctor
   ```

## 📁 Project Structure

```
FirstAid/
├── android/                  # Android platform code
├── ios/                     # iOS platform code
├── lib/                     # Main Dart application code
│   ├── main.dart           # Entry point aplikasi
│   ├── models/             # Data models
│   │   ├── category.dart
│   │   └── bleeding_category.dart
│   ├── screens/            # UI screens
│   │   ├── home_screen.dart
│   │   ├── bleeding_screen.dart
│   │   ├── severe_bleeding_screen.dart
│   │   └── minor_bleeding_screen.dart
│   ├── services/           # Business logic & services
│   └── widgets/            # Reusable UI components
│       ├── category_card.dart
│       └── bleeding_category_card.dart
├── assets/                 # App assets
│   └── images/            # Image files
├── pubspec.yaml           # Project dependencies
├── .gitignore            # Git ignore rules
└── README.md             # This file
```

## 🔧 Dependencies

Project ini menggunakan beberapa package utama:

- **flutter**: Core Flutter framework
- **provider**: State management
- **sqflite**: Local database
- **google_fonts**: Custom fonts
- **flutter_svg**: SVG image support
- **path_provider**: File system access

## 📱 Running on Device

### Android Device
1. Enable Developer Options di device Android
2. Enable USB Debugging
3. Connect device via USB
4. Jalankan `flutter devices` untuk memastikan device terdeteksi
5. Jalankan `flutter run -d android`

### iOS Device
1. Connect iPhone via USB
2. Trust computer di iPhone
3. Jalankan `flutter devices` untuk memastikan device terdeteksi
4. Jalankan `flutter run -d ios`

## 🐛 Troubleshooting

### Common Issues

#### Flutter Doctor Issues
```bash
flutter doctor -v
```
Ikuti saran yang diberikan untuk mengatasi masalah.

#### Dependencies Issues
```bash
flutter clean
flutter pub get
```

#### Build Issues
```bash
# Android
cd android
./gradlew clean
cd ..
flutter build apk

# iOS
cd ios
pod install
cd ..
flutter build ios
```

#### Device Not Detected
```bash
flutter devices
adb devices  # untuk Android
```

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design Guidelines](https://material.io/design)
- [Provider Package](https://pub.dev/packages/provider)

## 🤝 Contributing

1. Fork repository
2. Buat feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## 📄 License

Project ini dibuat untuk tujuan edukasi dan informasi pertolongan pertama. Silakan gunakan dengan bijak dan selalu konsultasikan dengan tenaga medis profesional untuk situasi darurat yang sebenarnya.

## ⚠️ Disclaimer

Informasi dalam aplikasi ini hanya untuk tujuan edukasi dan tidak menggantikan saran medis profesional. Dalam situasi darurat, selalu hubungi layanan darurat setempat atau kunjungi fasilitas medis terdekat.

## 📞 Support

Jika mengalami masalah atau ada pertanyaan:
1. Cek [Issues](https://github.com/yourusername/FirstAid/issues) di repository
2. Buat issue baru dengan detail error yang lengkap
3. Pastikan sudah mengikuti semua langkah setup di atas 