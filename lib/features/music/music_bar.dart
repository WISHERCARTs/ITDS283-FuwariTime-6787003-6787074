import 'package:flutter/material.dart';
import 'package:fuwari_time/features/music/music.dart'; // 💡 เช็ค Path ให้ตรงด้วยนะครับ

class LofiMusicBar extends StatefulWidget {
  const LofiMusicBar({super.key});

  @override
  State<LofiMusicBar> createState() => _LofiMusicBarState();
}

class _LofiMusicBarState extends State<LofiMusicBar> {
  bool isPlaying = false;
  
  // 🚀 เพิ่มตัวแปรจำลองค่าความคืบหน้าของเพลง (0.0 ถึง 1.0)
  double currentProgress = 0.3; 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ดันหน้า Music ขึ้นมา
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MusicScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        color: const Color(0xFFD4B4FB), 
        padding: const EdgeInsets.only(top: 12, bottom: 24, left: 24, right: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 32),
                  onPressed: () {
                    // TODO: สั่งย้อนกลับเพลง
                  },
                ),
                const SizedBox(width: 16),
                
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFF9A8D4), Color(0xFFD8B4FE)], 
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, 
                      color: Colors.white, 
                      size: 36,
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 32),
                  onPressed: () {
                    // TODO: สั่งข้ามเพลง
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 4),

            const Text(
              "Lemon Lofi", // 💡 เปลี่ยนชื่อเพลงให้ตรงกับที่คุณใช้ได้เลย
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 6),

            // 🚀 เปลี่ยนจาก Container เป็น Slider แบบเดียวกับหน้า MusicScreen
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 4, // ทำให้เส้นบางลงนิดนึงให้ดูมินิมอล
                activeTrackColor: Colors.white, // สีเส้นที่เล่นไปแล้วเป็นสีขาวให้ตัดกับพื้นหลัง
                inactiveTrackColor: Colors.white.withOpacity(0.3), // สีเส้นที่ยังไม่เล่นเป็นขาวใสๆ
                thumbColor: Colors.white, // ตุ่มจับสีขาว
                overlayColor: Colors.white.withOpacity(0.2), // สีเงาตอนกด
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6), // ตุ่มจับขนาดเล็กน่ารัก
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              ),
              child: Slider(
                value: currentProgress,
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  // 🚀 ให้หลอดเลื่อนตามนิ้ว
                  setState(() {
                    currentProgress = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}