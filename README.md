# 🌸 Fuwari Time (ฟุวาริ ไทม์) 🌸

### Gamified Pomodoro & Study Companion for Mental Well-being

**แอปพลิเคชันช่วยบริหารเวลาเรียนและนิสัยรักการอ่าน พร้อมเพื่อนเสมือนจริงเพื่อสุขภาพจิต**

<p align="center">
  <img src="assets/image/app_icon.png" width="150" alt="Fuwari Time Logo">
</p>

<div align="center">
  <h1>🌸 Fuwari Time (ฟุวาริ ไทม์) 🌸</h1>
  <p><i>"แอปพลิเคชันช่วยบริหารเวลาเรียนและเพื่อนเสมือนจริงเพื่อสุขภาพจิต"</i></p>

  <p>
    <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter">
    <img src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
    <img src="https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white" alt="Supabase">
    <img src="https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL">
    <img src="https://img.shields.io/badge/OpenWeather-EB6E4B?style=for-the-badge&logo=openweathermap&logoColor=white" alt="WeatherAPI">
  </p>

  <h4>ITDS283 Mobile Application Development Project - Section 2 Group 13</h4>
</div>

---

## 📖 Introduction / บทนำ

**Fuwari Time** เป็นแอปพลิเคชันช่วยบริหารเวลาที่ประยุกต์ใช้เทคนิค **Pomodoro** ร่วมกับแนวคิด **Gamification** ในรูปแบบของ **"เพื่อนเสมือนจริง (Virtual Companion)"** เพื่อสร้างสภาพแวดล้อมที่ผ่อนคลาย ลดความเครียด และเพิ่มสมาธิในการเรียนรู้ โดยตัวแอปมีจุดเด่นคือบรรยากาศภายในที่จะเปลี่ยนไปตามสภาพอากาศจริงของผู้ใช้งาน

---

## ✨ Key Features / ฟีเจอร์หลัก

- ⏱️ **Pomodoro Timer with Global Overlay**: A focus timer that can be minimized into a floating mini-timer for multi-tasking.
- 📝 **Gamified To-do List**: Manage tasks and earn coins as rewards for completion.
- 🎶 **Lo-fi Music Shop & Player**: Purchase relaxing Lo-fi tracks with earned coins to create the perfect study vibe.
- 📊 **Insightful Statistics**: Track your focus progress and app usage over time with visual charts.
- 🧸 **Virtual Companion**: Meet "Fuwari", your study buddy who stays with you through every session.

---

## 🛠️ Tech Stack / เทคโนโลยีที่ใช้

- **Framework**: [Flutter](https://flutter.dev/) (Cross-platform)
- **Database & Auth**: [Supabase](https://supabase.com/) (Real-time DB / Google Auth)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **APIs**: [OpenWeatherMap API](https://openweathermap.org/api) (Real-time Weather Sync)
- **Advanced Features**: Geolocator, Geocoding, Global Overlays, Local Notifications.

---

## 📱 Screenshots / ภาพตัวอย่างหน้าจอ

|                    Home (Day)                     |                 Home (Night/Rain)                 |                       Shop                        |
| :-----------------------------------------------: | :-----------------------------------------------: | :-----------------------------------------------: |
| <img src="assets/image/app_icon.png" width="200"> | <img src="assets/image/app_icon.png" width="200"> | <img src="assets/image/app_icon.png" width="200"> |

_(Note: Replace app_icon.png with actual screenshots for the final submission)_

---

## 🚀 Getting Started / เริ่มต้นใช้งาน

### 1. Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Tested on Flutter 3.11.0+)
- [Dart SDK](https://dart.dev/get-started/sdk)

### 2. Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/WISHERCARTS/ITDS283-FuwariTime-6787003-6787074.git
   cd ITDS283-FuwariTime-6787003-6787074
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Setup Environment Variables:
   - Create a `.env` file in the root directory.
   - Use the template from `.env.example`.
   - Add your **Supabase URL**, **Anon Key**, and **OpenWeather API Key**.

### 3. Run the App

```bash
flutter run
```

> [!WARNING]
> **Mobile Emulator Required for Google Login**: Please test the application using a **Mobile Emulator (Android/iOS)**. Google Login is currently configured to work only on mobile platforms and will not function on Windows or Web versions.
> 
> **ต้องใช้ Mobile Emulator สำหรับ Google Login**: กรุณาทดสอบแอปพลิเคชันผ่าน **Mobile Emulator** เท่านั้น เนื่องจากระบบ Google Login ถูกตั้งค่าไว้สำหรับแพลตฟอร์มมือถือ และจะไม่สามารถใช้งานบนเวอร์ชัน Windows หรือ Web ได้

---

## 📥 Download Installation Files / ดาวน์โหลดไฟล์ติดตั้ง

You can download the latest version of the app for your platform here:

- **Android Mobile**: [📱 Download Fuwari_Time.apk](https://github.com/WISHERCARTS/ITDS283-FuwariTime-6787003-6787074/releases/download/v1.0.0/app-arm64-v8a-release.apk)
- **Windows Desktop**: [💻 Download Fuwari_Time_Windows.zip](https://github.com/WISHERCARTS/ITDS283-FuwariTime-6787003-6787074/releases/download/v1.0.0/Fuwari_Time_Windows.zip)
- **iOS**: (Requires Manual Build via Xcode)

---

_(System Integrity Check - SHA256 Checksum)_

- Android APK: `89b16bab3ad5e1dc38149f942caf4069781624512e6ba3af523b4dd1242ca37d`
- Windows ZIP: `77fd91fbc08f648a186553b2e5b3aa4fc799593b36994ec032187adf6c6b7ffe`

---

## 🎥 Demo & Presentation / วิดีโอสาธิตและสไลด์นำเสนอ

- 📺 **Demo Video**: [Watch on YouTube](https://youtu.be/ss8YnDs0DTE)

---

## 👥 The Team / คณะผู้จัดทำ

**Group 13 (Section 2)** - Faculty of ICT, Mahidol University

1. **Wish Nakthong** (6787074) - [GitHub](https://github.com/wishercarts)
2. **Krittatee Kerdklinhom** (6787003) - [GitHub](https://github.com/Krittatee)

---

_Developed with ❤️ by ICT Mahidol Students_
