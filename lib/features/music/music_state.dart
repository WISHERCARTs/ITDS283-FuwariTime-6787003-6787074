import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

// 🚀 1. ตัวแปรโชว์แถบ Music Bar
final ValueNotifier<bool> isMusicBarVisible = ValueNotifier<bool>(true);

// 🚀 2. รายชื่อเพลง (ย้ายมาไว้ตรงกลาง เพื่อให้ดึงไปใช้ได้ทุกหน้า)
final List<Map<String, String>> globalMusicList = [
  {"title": "Lemon Lofi", "artist": "LemonMusicLab", "img": "assets/image/LemonMusic.webp", "path": "audio_asset/lemon-music.mp3"},
  {"title": "Dreamy Nostalgia", "artist": "Aventure", "img": "assets/image/AventureMusic.webp", "path": "audio_asset/nostalgia-music.mp3"},
  {"title": "Chill", "artist": "Monda Music", "img": "assets/image/MondaMusic.webp", "path": "audio_asset/chill-music.mp3"},
];

// 🚀 3. ระบบควบคุมเพลงส่วนกลาง (สมองหลัก)
class MusicController {
  static final MusicController _instance = MusicController._internal();
  factory MusicController() => _instance;

  final AudioPlayer audioPlayer = AudioPlayer();
  
  // ตัวแปรสถานะที่แจ้งเตือนหน้าจอให้อัปเดตอัตโนมัติ
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLooping = ValueNotifier<bool>(false);
  final ValueNotifier<Duration> position = ValueNotifier<Duration>(Duration.zero);
  final ValueNotifier<Duration> duration = ValueNotifier<Duration>(Duration.zero);

  MusicController._internal() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      duration.value = newDuration;
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      position.value = newPosition;
    });
    audioPlayer.onPlayerComplete.listen((event) {
      if (isLooping.value) {
        seek(Duration.zero);
        playSong(currentIndex.value);
      } else {
        skipNext();
      }
    });
  }

  Future<void> playSong(int index) async {
    currentIndex.value = index;
    String path = globalMusicList[index]['path']!;
    await audioPlayer.play(AssetSource(path));
  }

  Future<void> togglePlayPause() async {
    if (isPlaying.value) {
      await audioPlayer.pause();
    } else {
      await playSong(currentIndex.value);
    }
  }

  void skipNext() {
      if (currentIndex.value < globalMusicList.length - 1) {
        // ถ้ายังไม่ใช่เพลงสุดท้าย ก็เล่นเพลงถัดไปปกติ
        playSong(currentIndex.value + 1);
      } else {
        // ถ้าเป็นเพลงสุดท้ายแล้ว ให้วนกลับไปเล่นเพลงแรกสุด (index 0)
        playSong(0);
      }
    }

  void skipPrevious() {
    if (currentIndex.value > 0) {
      playSong(currentIndex.value - 1);
    }
  }

  void seek(Duration pos) {
    audioPlayer.seek(pos);
  }
  
  void toggleLoop() {
    isLooping.value = !isLooping.value;
  }
}

// สร้างตัวแปรให้เรียกใช้งานง่ายๆ
final musicController = MusicController();