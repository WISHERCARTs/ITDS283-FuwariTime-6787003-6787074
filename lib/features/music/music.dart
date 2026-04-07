import 'package:flutter/material.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/music/music_state.dart'; // 💡 ดึงสมองกลางมาใช้

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopBar(currentIndex: -1), // 🚀 ไม่ได้อยู่ในหน้า Nav หลัก
              const SizedBox(height: 10),

              // 🚀 AnimatedBuilder ดึงค่าจากสมองกลางมาแสดงผล
              AnimatedBuilder(
                animation: Listenable.merge([
                  musicController.currentIndex, 
                  musicController.isPlaying, 
                  musicController.position, 
                  musicController.duration, 
                  musicController.isLooping,
                  globalMusicList, // 🔄 เพิ่มการ Listen เมื่อลิสต์เพลงอัปเดต
                ]),
                builder: (context, child) {
                  // 🚀 เข้าถึงข้อมูลผ่าน .value
                  final musicList = globalMusicList.value;
                  
                  // ป้องกัน Error ถ้า Index หลุดขอบ
                  final songIndex = musicController.currentIndex.value;
                  if (songIndex >= musicList.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final currentSong = musicList[songIndex];
                  final isPlaying = musicController.isPlaying.value;
                  final isLooping = musicController.isLooping.value;
                  
                  final double pos = musicController.position.value.inSeconds.toDouble();
                  final double dur = musicController.duration.value.inSeconds.toDouble();
                  final double maxDuration = dur > 0 ? dur : 1.0;
                  final double currentValue = pos.clamp(0.0, maxDuration);

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: const Color(0xFFE5D5F2).withOpacity(0.5), borderRadius: BorderRadius.circular(40)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 10),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: musicImage(currentSong['img']!),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(currentSong['title']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4B5563)), textAlign: TextAlign.center),
                                  Text(currentSong['artist']!, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                                  const SizedBox(height: 10),
                                  
                                  SliderTheme(
                                    data: SliderThemeData(
                                      trackHeight: 6, activeTrackColor: const Color(0xFFD8B4FE), inactiveTrackColor: Colors.white,
                                      thumbColor: const Color(0xFFF9A8D4), overlayColor: const Color(0xFFF9A8D4).withOpacity(0.2),
                                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8), overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                                    ),
                                    child: Slider(
                                      min: 0.0, max: maxDuration, value: currentValue,
                                      onChanged: (value) => musicController.seek(Duration(seconds: value.toInt())),
                                    ),
                                  ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(formatTime(musicController.position.value), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                        Text(formatTime(musicController.duration.value), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 40), 
                                      IconButton(
                                        icon: const Icon(Icons.skip_previous_rounded, size: 36, color: Color(0xFF6B7280)),
                                        onPressed: () => musicController.skipPrevious(),
                                      ),
                                      const SizedBox(width: 16),
                                      GestureDetector(
                                        onTap: () => musicController.togglePlayPause(), 
                                        child: Container(
                                          width: 64, height: 64,
                                          decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFF9A8D4), Color(0xFFD8B4FE)]), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))]),
                                          child: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 40),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      IconButton(
                                        icon: const Icon(Icons.skip_next_rounded, size: 36, color: Color(0xFF6B7280)),
                                        onPressed: () => musicController.skipNext(),
                                      ),
                                      IconButton(
                                        icon: Icon(isLooping ? Icons.repeat_one_rounded : Icons.repeat_rounded, size: 28, color: isLooping ? const Color(0xFFD8B4FE) : const Color(0xFF9CA3AF)),
                                        onPressed: () => musicController.toggleLoop(),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Positioned(left: 10, top: 10, child: IconButton(icon: const Icon(Icons.chevron_left, size: 40, color: Color(0xFFD8B4FE)), onPressed: () => Navigator.pop(context))),
                          ],
                        ),
                      ),

                      // 🎵 Playlist ด้านล่าง
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          decoration: BoxDecoration(color: const Color(0xFFD8B4FE).withOpacity(0.3), borderRadius: BorderRadius.circular(30)),
                          child: ListView.separated(
                            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                            itemCount: musicList.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              final music = musicList[index];
                              bool isActive = musicController.currentIndex.value == index;

                              return InkWell(
                                onTap: () {
                                  musicController.playSong(index);
                                  isMusicBarVisible.value = true;
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: isActive ? Colors.white.withOpacity(0.5) : Colors.transparent, borderRadius: BorderRadius.circular(16)),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: musicImage(music['img']!, size: 60),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(music['title']!, style: TextStyle(fontSize: 18, color: const Color(0xFF1F2937), fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
                                            Text(music['artist']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                      if (isActive && isPlaying) const Icon(Icons.equalizer_rounded, color: Color(0xFFD8B4FE)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget musicImage(String imgPath, {double size = 220}) {
    return imgPath.startsWith('assets/')
      ? Image.asset(imgPath, width: size, height: size, fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => errorWidget(size))
      : Image.network(imgPath, width: size, height: size, fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => errorWidget(size));
  }

  Widget errorWidget(double size) {
    return Container(width: size, height: size, color: Colors.grey.shade300, child: const Icon(Icons.music_note, size: 50));
  }
}