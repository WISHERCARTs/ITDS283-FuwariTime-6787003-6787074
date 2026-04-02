import 'package:flutter/material.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';
import 'package:fuwari_time/features/music/music_state.dart';
import 'package:fuwari_time/features/music/music_bar.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final List<Map<String, String>> musicList = [
    {
      "title": "Lemon Lofi", 
      "artist": "LemonMusicLab", 
      "img": "assets/image/LemonMusic.webp",
      "path": "audio_asset/lemon-music.mp3" 
    },
    {
      "title": "Dreamy Nostalgia", 
      "artist": "Aventure", 
      "img": "assets/image/AventureMusic.webp",
      "path": "audio_asset/nostalgia-music.mp3"
    },
    {
      "title": "Chill", 
      "artist": "Monda Music", 
      "img": "assets/image/MondaMusic.webp",
      "path": "audio_asset/chill-music.mp3"
    },
  ];

  int currentIndex = 0;
  bool isPlaying = false;
  bool isLooping = false; 
  
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero; 
  Duration _position = Duration.zero; 

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
          // 💡 ถ้าตัวแปร isMusicBarVisible อยู่ในไฟล์อื่น และมี Error ให้ลองคอมเมนต์บรรทัดล่างนี้ดูนะครับ
          isMusicBarVisible.value = isPlaying; 
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) setState(() => _duration = newDuration);
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) setState(() => _position = newPosition);
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (isLooping) {
        if (mounted) setState(() => _position = Duration.zero);
        _playMusic(musicList[currentIndex]['path']!);
      } else {
        if (currentIndex < musicList.length - 1) {
          _changeSong(currentIndex + 1);
        } else {
          if (mounted) {
            setState(() {
              currentIndex = 0;
              _position = Duration.zero;
              isPlaying = false;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playMusic(String path) async {
    await _audioPlayer.play(AssetSource(path));
  }

  Future<void> _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _playMusic(musicList[currentIndex]['path']!);
    }
  }

  void _changeSong(int newIndex) {
    setState(() {
      currentIndex = newIndex;
      _position = Duration.zero; 
    });
    _playMusic(musicList[currentIndex]['path']!);
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = musicList[currentIndex];

    // 🚀 ปรับตรรกะ Slider ให้ปลอดภัย 100% ป้องกันแอปค้างตอนคำนวณเวลาผิดพลาด
    final double maxDuration = _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1.0;
    final double currentValue = _position.inSeconds.toDouble().clamp(0.0, maxDuration);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopBar(), // 💡 ถ้ายังมีจอขาว ให้ลองคอมเมนต์บรรทัด TopBar() นี้ทิ้งดูครับ
              const SizedBox(height: 10),

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
                        mainAxisSize: MainAxisSize.min, // 🚀 ล็อกไม่ให้ Column ทะลุกล่อง
                        children: [
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              currentSong['img']!,
                              width: 220,
                              height: 220,
                              fit: BoxFit.cover,
                              // 💡 เผื่อรูปโหลดไม่ขึ้น จะได้ไม่พัง
                              errorBuilder: (context, error, stackTrace) => 
                                Container(width: 220, height: 220, color: Colors.grey.shade300, child: const Icon(Icons.music_note, size: 50)),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            currentSong['title']!,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4B5563)),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            currentSong['artist']!,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 6,
                              activeTrackColor: const Color(0xFFD8B4FE),
                              inactiveTrackColor: Colors.white,
                              thumbColor: const Color(0xFFF9A8D4),
                              overlayColor: const Color(0xFFF9A8D4).withOpacity(0.2),
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                            ),
                            child: Slider(
                              min: 0.0,
                              max: maxDuration, // 🚀 ใช้ค่าที่ประมวลผลให้ปลอดภัยแล้ว
                              value: currentValue, // 🚀 ใช้ค่าที่ประมวลผลให้ปลอดภัยแล้ว
                              onChanged: (value) {
                                final position = Duration(seconds: value.toInt());
                                _audioPlayer.seek(position);
                              },
                            ),
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(formatTime(_position), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                Text(formatTime(_duration), style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
                                onPressed: () {
                                  if (currentIndex > 0) _changeSong(currentIndex - 1);
                                },
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: _togglePlayPause, 
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Color(0xFFF9A8D4), Color(0xFFD8B4FE)],
                                    ),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
                                    ],
                                  ),
                                  child: Icon(
                                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.skip_next_rounded, size: 36, color: Color(0xFF6B7280)),
                                onPressed: () {
                                  if (currentIndex < musicList.length - 1) _changeSong(currentIndex + 1);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  isLooping ? Icons.repeat_one_rounded : Icons.repeat_rounded, 
                                  size: 28, 
                                  color: isLooping ? const Color(0xFFD8B4FE) : const Color(0xFF9CA3AF),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isLooping = !isLooping; 
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8B4FE).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: musicList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final music = musicList[index];
                      bool isActive = currentIndex == index;

                      return InkWell(
                        onTap: () {
                          _changeSong(index); 
                          // 💡 ลองเช็คบรรทัดนี้นะครับ ถ้า isMusicBarVisible มีปัญหาอาจจะเกิดจากตรงนี้
                          isMusicBarVisible.value = true;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white.withOpacity(0.5) : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  music['img']!, 
                                  width: 60, height: 60, fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(width: 60, height: 60, color: Colors.grey.shade300),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min, // 🚀 นี่คือพระเอกตัวจริง! บังคับไม่ให้ Column เด้งทะลุ ListView
                                  children: [
                                    Text(
                                      music['title']!,
                                      style: TextStyle(
                                        fontSize: 18, 
                                        color: const Color(0xFF1F2937),
                                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      music['artist']!,
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              if (isActive && isPlaying)
                                const Icon(Icons.equalizer_rounded, color: Color(0xFFD8B4FE)),
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
          ),
        ),
      ),
    );
  }
}