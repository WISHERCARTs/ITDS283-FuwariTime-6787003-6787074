# 🚢 How to Upload Your App to GitHub (Releases)
### คู่มือการอัปโหลดไฟล์ติดตั้ง (APK & EXE) ขึ้น GitHub

To make your app downloadable for your professors and peers, follow these steps:
เพื่อให้แอปของคุณสามารถดาวน์โหลดได้ง่ายๆ ให้ทำตามขั้นตอนการใช้ **GitHub Releases** ดังนี้ครับ:

---

## 📂 Step 1: Locate your Build Files
I have already built the installation files for you. They are located here:
ผมได้ Build ไฟล์ติดตั้งไว้ให้เรียบร้อยแล้ว โดยคุณสามารถหาได้จากโฟลเดอร์เหล่านี้:

1.  **Android APK**: 
    `build\app\outputs\flutter-apk\app-arm64-v8a-release.apk`
2.  **Windows EXE**: 
    `build\windows\x64\runner\Release\fuwari_time.exe`

---

## ☁️ Step 2: Create a Release on GitHub
1.  Go to your GitHub repository in your web browser.
2.  On the right side of the main page, find the **Releases** section and click **"Create a new release"** (or click the "Releases" header then "Draft a new release").
3.  **Tag version**: Enter `v1.0.0` (or any version number).
4.  **Release title**: Enter `Fuwari Time - Phase 2 Submission`.
5.  **Description**: You can briefly describe the version (e.g., "Full feature build for Phase 2").

---

## 📎 Step 3: Upload the Files (Assets)
1.  Scroll down to the **"Attach binaries by dropping them here or selecting them"** box.
2.  **Drag and Drop** the files from Step 1 into this box:
    -   `app-arm64-v8a-release.apk` (Rename it to `Fuwari_Time_Android.apk` for clarity if you want).
    -   `fuwari_time.exe` (Rename it to `Fuwari_Time_Windows.exe`).
3.  Wait for the upload to complete.

---

## 🚀 Step 4: Publish
1.  Click the **"Publish release"** button.
2.  Done! Now anyone can visit your repository's Releases page and download the installers directly.

---

### 💡 Pro Tip:
In your `README.md`, don't forget to update the download links once you have published the release so they point to the actual files!
อย่าลืมนำลิงก์ที่ได้ไปอัปเดตในไฟล์ `README.md` เพื่อให้ปุ่มดาวน์โหลดใช้งานได้จริงนะครับ!
