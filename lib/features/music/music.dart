import 'package:flutter/material.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';
import 'package:fuwari_time/features/home/widgets/music_state.dart'; // 💡 สำหรับเปิดแถบเพลง
import 'package:fuwari_time/features/home/widgets/lofi_music_bar.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  // 💡 ข้อมูลจำลองรายการเพลง
  final List<Map<String, String>> musicList = [
    {"title": "Serious", "artist": "Lofi Boy", "img": "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/jzbp6j9l_expires_30_days.png"},
    {"title": "Punk", "artist": "Retro Girl", "img": "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/jzbp6j9l_expires_30_days.png"},
    {"title": "Chill Day", "artist": "Fuwari", "img": "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/jzbp6j9l_expires_30_days.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: isMusicBarVisible,
            builder: (context, isVisible, child) {
              return isVisible ? const LofiMusicBar() : const SizedBox.shrink();
            },
          ),
          const BottomNavBar(currentIndex: 0), // ไฮไลท์ที่หน้า Home/Music
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopBar(),
              
              const SizedBox(height: 10),

              // 💡 1. ส่วนบัตรศิลปินแนะนำ (Featured Card)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5D5F2).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          // รูปศิลปิน
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/jzbp6j9l_expires_30_days.png", // เปลี่ยนเป็นรูปดาราที่คุณส่งมาได้เลย
                              width: 220,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "7,910,613",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4B5563)),
                          ),
                          const Text(
                            "Monthly listeners",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          // ปุ่มควบคุมจำลอง
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildMiniBtn(Icons.person_add_alt_1, "Following", isText: true),
                              const SizedBox(width: 10),
                              _buildMiniBtn(Icons.more_horiz, ""),
                              const SizedBox(width: 10),
                              _buildMiniBtn(Icons.shuffle, ""),
                              const SizedBox(width: 10),
                              _buildMiniBtn(Icons.play_arrow, "", isBlue: true),
                            ],
                          )
                        ],
                      ),
                    ),
                    // ปุ่มย้อนกลับมุมซ้าย
                    Positioned(
                      left: 10, top: 10,
                      child: IconButton(
                        icon: const Icon(Icons.chevron_left, size: 40, color: Color(0xFFD8B4FE)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),

              // 💡 2. รายการเพลง (Music List)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8B4FE).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true, // สำคัญ: ให้ขยายตามจำนวนลูก
                    physics: const NeverScrollableScrollPhysics(), // ปิดการ scroll ของ list
                    itemCount: musicList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final music = musicList[index];
                      return InkWell(
                        onTap: () {
                          // 💡 เมื่อกดเพลง ให้โชว์แถบเพลงด้านล่างทันที
                          isMusicBarVisible.value = true;
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(music['img']!, width: 60, height: 60, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              music['title']!,
                              style: const TextStyle(fontSize: 18, color: Color(0xFF1F2937)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Widget สร้างปุ่มเล็กๆ ในการ์ด
  Widget _buildMiniBtn(IconData icon, String label, {bool isText = false, bool isBlue = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isText ? 15 : 8, vertical: 8),
      decoration: BoxDecoration(
        color: isBlue ? const Color(0xFF00A3FF) : const Color(0xFF374151),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          if (isText) ...[
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ]
        ],
      ),
    );
  }
}