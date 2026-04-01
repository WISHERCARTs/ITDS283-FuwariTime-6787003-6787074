import 'package:flutter/material.dart';
import 'package:fuwari_time/features/music/music_state.dart';

class LofiMusicBar extends StatelessWidget {
  const LofiMusicBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // 💡 ใช้สีม่วงพาสเทลตามธีมคุณ
      decoration: const BoxDecoration(
        color: Color(0xFFD8B4FE), 
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // 🎵 ไอคอนหรือรูปปกจิ๋ว
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Colors.white24,
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.music_note, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              
              // 📝 ชื่อเพลง (ดึงมาจากตัวแปรส่วนกลาง)
              Expanded(
                child: ValueListenableBuilder<String>(
                  valueListenable: currentSongTitle,
                  builder: (context, title, child) {
                    return Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
              ),

              // ⏯ ปุ่มควบคุม
              IconButton(
                icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                onPressed: () {
                  // TODO: ใส่คำสั่งเล่น/หยุดเพลงจริง
                },
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                onPressed: () {
                  // 💡 กดกากบาทเพื่อปิดแถบเพลง
                  isMusicBarVisible.value = false;
                },
              ),
            ],
          ),
          
          // 📊 หลอด Progress Bar เล็กๆ ด้านล่าง
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.3, // สมมติว่าเล่นไปแล้ว 30%
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }
}