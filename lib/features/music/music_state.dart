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
// 🚀 3. ระบบควบคุมเพลงส่วนกลาง (สมองหลักที่อัปเกรดให้เสถียรขึ้น!)
class MusicController {
  static final MusicController _instance = MusicController._internal();
  factory MusicController() => _instance;

  final AudioPlayer audioPlayer = AudioPlayer();
  
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

  // 💡 อัปเกรดฟังก์ชันเล่นเพลง
  Future<void> playSong(int index) async {
    try {
      // 🚀 1. สั่ง Stop และเคลียร์ระบบเก่าให้เกลี้ยงก่อนเริ่มเพลงใหม่
      await audioPlayer.stop(); 
      
      currentIndex.value = index;
      String path = globalMusicList[index]['path']!;
      
      // 🚀 2. ค่อยสั่ง Play ไฟล์ใหม่
      await audioPlayer.play(AssetSource(path));
    } catch (e) {
      debugPrint("❌ Error playing audio: $e");
    }
  }

  // 💡 อัปเกรดปุ่ม Play/Pause ให้ถูกต้อง
  Future<void> togglePlayPause() async {
    try {
      if (isPlaying.value) {
        await audioPlayer.pause();
      } else {
        // 🚀 3. ถ้าเพลงถูกหยุดไว้ ให้ใช้คำสั่ง "resume" (เล่นต่อ) แทนที่จะเริ่มใหม่
        if (position.value > Duration.zero && position.value < duration.value) {
          await audioPlayer.resume();
        } else {
          await playSong(currentIndex.value);
        }
      }
    } catch (e) {
      debugPrint("❌ Error toggling audio: $e");
    }
  }

  void skipNext() {
    if (currentIndex.value < globalMusicList.length - 1) {
      playSong(currentIndex.value + 1);
    } else {
      playSong(0); // วนกลับไปเพลงแรก
    }
  }

  void skipPrevious() {
    if (currentIndex.value > 0) {
      playSong(currentIndex.value - 1);
    } else {
      // 💡 ถ้ากด Back หน้าเพลงแรก ให้เด้งไปเพลงสุดท้ายเลย
      playSong(globalMusicList.length - 1); 
    }
  }

  void seek(Duration pos) {
    try {
      audioPlayer.seek(pos);
    } catch (e) {
      debugPrint("❌ Error seeking audio: $e");
    }
  }
  
  void toggleLoop() {
    isLooping.value = !isLooping.value;
  }
}

// สร้างตัวแปรให้เรียกใช้งานง่ายๆ
final musicController = MusicController();