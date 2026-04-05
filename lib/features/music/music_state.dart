import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fuwari_time/services/inventory_service.dart';

// 🚀 1. ตัวแปรโชว์แถบ Music Bar
final ValueNotifier<bool> isMusicBarVisible = ValueNotifier<bool>(true);

// 🚀 2. คลังเพลงเริ่มต้น (Default ที่ทุกคนต้องมี)
final List<Map<String, String>> baseMusicList = [
  {"title": "Lemon Lofi", "artist": "LemonMusicLab", "img": "assets/image/LemonMusic.webp", "path": "audio_asset/lemon-music.mp3"},
  {"title": "Dreamy Nostalgia", "artist": "Aventure", "img": "assets/image/AventureMusic.webp", "path": "audio_asset/nostalgia-music.mp3"},
  {"title": "Chill", "artist": "Monda Music", "img": "assets/image/MondaMusic.webp", "path": "audio_asset/chill-music.mp3"},
];

// 🚀 3. แคตตาล็อกเพลงใน Shop (ใช้แมตช์ข้อมูลเวลาซื้อสำเร็จ)
final List<Map<String, String>> shopMusicCatalog = [
  {"title": "Lofi Study", "artist": "Study Beats", "img": "assets/image/LemonMusic.webp", "path": "audio_asset/lemon-music.mp3"}, // 💡 ใช้ไฟล์ตัวอย่างไปก่อน
  {"title": "Summer Vibe", "artist": "Ocean Waves", "img": "assets/image/AventureMusic.webp", "path": "audio_asset/nostalgia-music.mp3"},
  {"title": "Midnight Jazz", "artist": "Jazz Club", "img": "assets/image/MondaMusic.webp", "path": "audio_asset/chill-music.mp3"},
  {"title": "Rainy Day", "artist": "Nature Sound", "img": "assets/image/LemonMusic.webp", "path": "audio_asset/lemon-music.mp3"},
];

// 🚀 4. รายชื่อเพลงปัจจุบัน (Base + Purchased)
final ValueNotifier<List<Map<String, String>>> globalMusicList = ValueNotifier<List<Map<String, String>>>(baseMusicList);

// 🚀 5. ระบบควบคุมเพลงส่วนกลาง
class MusicController {
  static final MusicController _instance = MusicController._internal();
  factory MusicController() => _instance;

  final AudioPlayer audioPlayer = AudioPlayer();
  final InventoryService _inventoryService = InventoryService();
  
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

  // 🔄 ซิงค์ข้อมูลเพลงจาก Supabase
  Future<void> syncInventory() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      globalMusicList.value = baseMusicList;
      return;
    }

    try {
      final ownedTitles = await _inventoryService.fetchOwnedItems(userId);
      
      // รวม Base เข้ากับเพลงที่ซื้อเพิ่ม (กรองเอาเฉพาะที่มีใน Catalog)
      List<Map<String, String>> mergedList = List.from(baseMusicList);
      
      for (String title in ownedTitles) {
        // ค้นหาข้อมูลเพลงเต็มใน Catalog
        var purchasedMusic = shopMusicCatalog.firstWhere(
          (m) => m['title'] == title,
          orElse: () => {},
        );
        
        if (purchasedMusic.isNotEmpty) {
          // ป้องกันการแอดซ้ำ
          if (!mergedList.any((m) => m['title'] == title)) {
            mergedList.add(purchasedMusic);
          }
        }
      }
      
      globalMusicList.value = mergedList;
    } catch (e) {
      debugPrint("❌ Error syncing inventory: $e");
    }
  }

  Future<void> playSong(int index) async {
    try {
      await audioPlayer.stop(); 
      currentIndex.value = index;
      String path = globalMusicList.value[index]['path']!;
      await audioPlayer.play(AssetSource(path));
    } catch (e) {
      debugPrint("❌ Error playing audio: $e");
    }
  }

  Future<void> togglePlayPause() async {
    try {
      if (isPlaying.value) {
        await audioPlayer.pause();
      } else {
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
    if (currentIndex.value < globalMusicList.value.length - 1) {
      playSong(currentIndex.value + 1);
    } else {
      playSong(0);
    }
  }

  void skipPrevious() {
    if (currentIndex.value > 0) {
      playSong(currentIndex.value - 1);
    } else {
      playSong(globalMusicList.value.length - 1); 
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

final musicController = MusicController();