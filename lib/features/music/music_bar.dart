import 'package:flutter/material.dart';
import 'package:fuwari_time/features/music/music.dart'; 
import 'package:fuwari_time/features/music/music_state.dart'; 

class LofiMusicBar extends StatelessWidget {
  const LofiMusicBar({super.key});

  // 🚀 ฟังก์ชันช่วยแปลงเวลาให้ออกมาเป็นรูปแบบ 00:00
  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        musicController.currentIndex,
        musicController.isPlaying,
        musicController.position,
        musicController.duration,
        musicController.isLooping, 
      ]),
      builder: (context, child) {
        final currentSong = globalMusicList[musicController.currentIndex.value];
        final isPlaying = musicController.isPlaying.value;
        final isLooping = musicController.isLooping.value; 
        
        final double pos = musicController.position.value.inSeconds.toDouble();
        final double dur = musicController.duration.value.inSeconds.toDouble();
        final double progress = dur > 0 ? (pos / dur).clamp(0.0, 1.0) : 0.0;

        // 🚀 ดึงข้อความเวลามาเตรียมไว้
        final String posText = formatTime(musicController.position.value);
        final String durText = formatTime(musicController.duration.value);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MusicScreen()),
            );
          },
          child: Container(
            width: double.infinity,
            color: const Color(0xFFD4B4FB), 
            // 💡 ลดขอบซ้ายขวาลงนิดนึงเพื่อให้มีพื้นที่วางรูปมากขึ้น
            padding: const EdgeInsets.only(top: 8, bottom: 4, left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    // 🚀 1. ฝั่งซ้าย: รูปภาพ + (ชื่อเพลง & เวลา)
                    Expanded(
                      child: Row(
                        children: [
                          // 🖼️ รูปปกเพลง
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              currentSong['img']!, 
                              width: 38, 
                              height: 38, 
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 38, height: 38, color: Colors.white.withOpacity(0.5),
                                child: const Icon(Icons.music_note, color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          
                          // 🎵 ชื่อเพลง และ เวลา
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currentSong['title']!, 
                                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // ⏱️ ตัวเลขบอกเวลาที่เพิ่มเข้ามา
                                Text(
                                  "$posText / $durText",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8), // สีขาวโปร่งแสงให้ดูเป็นรองจากชื่อเพลง
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🚀 2. ฝั่งขวา: กลุ่มปุ่มกด
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 26),
                          onPressed: () => musicController.skipPrevious(), 
                        ),
                        const SizedBox(width: 8), // 💡 บีบช่องว่างลงนิดนึงกันล้น
                        GestureDetector(
                          onTap: () => musicController.togglePlayPause(), 
                          child: Container(
                            width: 38, height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFF9A8D4), Color(0xFFD8B4FE)]),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
                            ),
                            child: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 24),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(), 
                          icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 26),
                          onPressed: () => musicController.skipNext(), 
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(), 
                          icon: Icon(
                            isLooping ? Icons.repeat_one_rounded : Icons.repeat_rounded, 
                            color: isLooping ? Colors.white : Colors.white.withOpacity(0.5), 
                            size: 22,
                          ),
                          onPressed: () => musicController.toggleLoop(),
                        ),
                      ],
                    ),
                  ],
                ),
                
                // 🚀 3. แถบเลื่อนเวลา (Slider)
                SizedBox(
                  height: 16, // 💡 ลดความสูงส่วน Slider ลงอีกนิด เพราะเรามีข้อความเวลาโชว์ข้างบนแล้ว
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 3, activeTrackColor: Colors.white, inactiveTrackColor: Colors.white.withOpacity(0.3),
                      thumbColor: Colors.white, overlayColor: Colors.white.withOpacity(0.2),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5), overlayShape: const RoundSliderOverlayShape(overlayRadius: 10), 
                    ),
                    child: Slider(
                      value: progress,
                      min: 0.0, max: 1.0,
                      onChanged: (value) {
                        final seekSeconds = (value * dur).toInt();
                        musicController.seek(Duration(seconds: seekSeconds)); 
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}