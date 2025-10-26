# Creditech

Creditech adalah aplikasi Flutter berbasis Machine Learning (unsupervised learning) untuk mendeteksi potensi fraud pada transaksi kartu kredit.
Tujuannya adalah mempermudah individu maupun institusi dalam memantau aktivitas mencurigakan secara real-time melalui perangkat seluler lintas platform.

---

## 🚀 Fitur Utama

- **Deteksi Fraud:** Menggunakan model Machine Learning untuk mengenali pola transaksi tidak normal.
- **Visualisasi Transaksi:** Menampilkan data transaksi dan status deteksi dengan antarmuka interaktif.
- **Riwayat Prediksi:** Menyimpan hasil analisis agar pengguna dapat meninjau ulang.
- **Cloudinary SDK:** untuk upload gambar transaksi  
- **Integrasi Backend ML:** Mendukung model yang di-host di server (REST API) atau TFLite on-device.
- **Cloud Firestore:** untuk penyimpanan data transaksi dan prediksi  
- **Antarmuka Responsif:** Desain UI berbasis Material Design dengan performa ringan.

---

## 🧩 Arsitektur Aplikasi

```
Flutter UI (Frontend)
│
├── Provider / Controller Layer (State Management)
│
├── Service Layer (HTTP)
│
└── ML Backend (REST API)
```

---

## ⚙️ Teknologi yang Digunakan

- Flutter SDK: 3.x
- Dart: 3.x
- Provider: untuk state management
- HTTP: untuk komunikasi API
- ML Backend : untuk inference model

---

## 📁 Struktur Direktori

```
lib/
├── main.dart
├── ui/
│   ├── pages/
│   └── widgets/
├── controller/
├── models/
├── services/
│   ├── api_service.dart
│   └── upload_service.dart
└── utils/
```

---

## 🧠 Cara Replikasi Proyek

### 1. Clone repository

```bash
git clone https://github.com/FelyksCode/Creditech-Capstone-Flutter-Project.git
cd creditech
```

### 2. Install dependencies

```bash
flutter pub get
```

## 🔥 Setup Firebase

### 1. Tambahkan Firebase ke Project Flutter
```bash
firebase login
firebase init
flutterfire configure
```

## ☁️ Pindahkan Firebase API ke .env

Untuk menjaga keamanan kredensial Firebase, jangan hardcode API Key langsung di kode Dart.
Gunakan file .env agar konfigurasi bisa dikelola secara aman dan fleksibel di berbagai environment (dev, staging, production).

### Konfigurasi environment

Buat file `.env` di root project dan tambahkan konfigurasi berikut:

```environment
# Firebase
FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_AUTH_DOMAIN=your_project_id.firebaseapp.com
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_STORAGE_BUCKET=your_project_id.appspot.com
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_APP_ID=your_app_id
FIREBASE_MEASUREMENT_ID=your_measurement_id

# Cloudinary
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
CLOUDINARY_UPLOAD_PRESET=your_upload_preset

# Backend API
API_BASE_URL=http://<your-server-ip>:8000

```

Jika menggunakan Firebase ML:

- Pastikan `google-services.json` sudah ditambahkan di `android/app/`.


### Jalankan aplikasi

Untuk debug:

```bash
flutter run
```

Untuk rilis:

```bash
flutter build apk --release
```

---

## 📡 Integrasi Model Machine Learning

**Server REST API:** Flutter memanggil endpoint seperti `/predict` dan menerima hasil deteksi fraud.

---

## 👨‍💻 Tim Pengembang

- **Capstone Team ID:** DB8-PG017
- **Nama Proyek:** Creditech — Credit Card Fraud Detection using Unsupervised Machine Learning
- **Platform:** Flutter
