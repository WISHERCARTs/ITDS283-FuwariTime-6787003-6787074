import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fuwari_time/features/auth/screens/auth_gate.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';
import 'package:fuwari_time/features/setting/about_us.dart';

// 🚀 1. Import ไฟล์ music_state.dart เข้ามาเพื่อจะได้สั่งการตัวเล่นเพลงได้
import 'package:fuwari_time/features/music/music_state.dart';
import 'package:provider/provider.dart';
import 'package:fuwari_time/features/home/widgets/pomodoro_timer_dialog.dart';

class Setting extends StatefulWidget {
  final int currentIndex;
  const Setting({super.key, this.currentIndex = 0});

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  // 💡 กำหนดค่าเริ่มต้น (เดี๋ยวเราจะไปดึงค่าจริงจาก musicController ตอน initState)
  double soundVolume = 0.5;

  @override
  void initState() {
    super.initState();
    // 🚀 2. ดึงระดับเสียงปัจจุบันจากตัวเล่นเพลง มาตั้งเป็นค่าเริ่มต้นให้ Slider (ถ้าดึงไม่ได้ให้เริ่มที่ 0.5)
    // ตรงนี้สมมติว่าใน musicController ของคุณมีตัวแปร/ฟังก์ชันเก็บระดับเสียงไว้นะครับ
    // ถ้ายังไม่มีเดี๋ยวเราไปเติมใน สเต็ปที่ 2 ครับ
    try {
      soundVolume = musicController.currentVolume;
    } catch (e) {
      soundVolume = 0.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      bottomNavigationBar: BottomNavBar(currentIndex: widget.currentIndex),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopBar(),

              const SizedBox(height: 20),

              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF1F2937),
                          size: 24,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  const Text(
                    "Setting",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Image.network(
                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/c7j0cbib_expires_30_days.png",
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Sound",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Expanded(
                      child: Slider(
                        value: soundVolume,
                        min: 0.0,
                        max: 1.0,
                        activeColor: const Color(0xFFDAB7FD),
                        inactiveColor: Colors.grey.shade300,
                        onChanged: (value) {
                          setState(() {
                            soundVolume = value;
                          });
                          // 🚀 3. สั่งให้ตัวเล่นเพลงปรับระดับเสียงตาม Slider ทันที!
                          musicController.setVolume(value);
                        },
                      ),
                    ),

                    SizedBox(
                      width: 40,
                      child: Text(
                        "${(soundVolume * 100).toInt()}%",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 💡 เมนู About Us
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUs()),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 30,
                          color: Color(0xFF1F2937),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          "About Us",
                          style: TextStyle(
                            color: Color(0xFF1F2937),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 💡 ปุ่ม Log out
              // 💡 ปุ่ม Log out
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: InkWell(
                  onTap: () async {
                    // 🛑 0. หยุดการทำงานเบื้องหลังทุกอย่างก่อน!
                    await musicController.audioPlayer.stop();
                    musicController.isPlaying.value = false;

                    if (context.mounted) {
                      context.read<PomodoroController>().stop();
                    }

                    // 🚀 1. สั่ง Sign Out จาก Supabase
                    await Supabase.instance.client.auth.signOut();

                    // 🚀 3. พากลับไปหน้า AuthGate ล้างหน้ากระดานทั้งหมด
                    if (context.mounted) {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const AuthGate(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/bo4l4cgu_expires_30_days.png",
                          width: 30,
                          height: 30,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          "Log out",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
