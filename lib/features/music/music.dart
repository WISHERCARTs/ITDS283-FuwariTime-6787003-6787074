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
      "img": "image/LemonMusic.webp",
      "path": "audio_asset/lemon-music.mp3" 
    },
    {
      "title": "Dreamy Nostalgia", 
      "artist": "Aventure", 
      "img": "image/AventureMusic.webp",
      "path": "audio_asset/nostalgia-music.mp3"
    },
    {
      "title": "Chill", 
      "artist": "Monda Music", 
      "img": "image/MondaMusic.webp",
      "path": "audio_asset/chill-music.mp3"
    },
  ];

  int currentIndex = 0;
  bool isPlaying = false;
  
  // 🚀 1. เพิ่มตัวแปรสำหรับเก็บสถานะการวนลูป (เริ่มต้นคือไม่วนลูป)
  bool isLooping = false; 
  
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero; 
  Duration _position = Duration.zero; 

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
        isMusicBarVisible.value = isPlaying;
      });
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    // 🚀 2. แก้ไขระบบเมื่อ "เพลงเล่นจบ"
    _audioPlayer.onPlayerComplete.listen((event) {
      if (isLooping) {
        // 👉 ถ้าเปิดลูปไว้: ให้เล่นเพลงเดิมซ้ำ
        setState(() {
          _position = Duration.zero; // กลับไปวิที่ 0
        });
        _playMusic(musicList[currentIndex]['path']!);
      } else {
        // 👉 ถ้าปิดลูปไว้: ให้เช็คว่ามีเพลงถัดไปไหม
        if (currentIndex < musicList.length - 1) {
          // มีเพลงถัดไป -> สั่งเล่นเพลงถัดไป
          _changeSong(currentIndex + 1);
        } else {
          // หมดเพลย์ลิสต์แล้ว -> กลับไปเพลงแรกสุดและหยุดเล่น
          setState(() {
            currentIndex = 0;
            _position = Duration.zero;
            isPlaying = false;
          });
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

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopBar(),
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
                        children: [
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              currentSong['img']!,
                              width: 220,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            currentSong['title']!,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4B5563)),
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
                              max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0,
                              value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0),
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

                          // 🚀 แถวของปุ่มควบคุมการเล่น
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 💡 ใส่ SizedBox ว่างๆ ไว้ทางซ้ายเพื่อถ่วงน้ำหนักปุ่มวนลูปทางขวาให้อยู่ตรงกลางเป๊ะๆ
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

                              // 🚀 3. ปุ่มวนลูป (Loop) เพิ่มไว้ด้านขวาสุด
                              IconButton(
                                icon: Icon(
                                  // เปลี่ยนไอคอนระหว่าง 1 (วนเพลงเดียว) กับ All (ปิดลูป/เล่นตามลำดับ)
                                  isLooping ? Icons.repeat_one_rounded : Icons.repeat_rounded, 
                                  size: 28, 
                                  // เปลี่ยนสีเป็นม่วงพาสเทลเมื่อกดเปิด
                                  color: isLooping ? const Color(0xFFD8B4FE) : const Color(0xFF9CA3AF),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isLooping = !isLooping; // สลับค่าไปมา
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
                                child: Image.asset(music['img']!, width: 60, height: 60, fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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