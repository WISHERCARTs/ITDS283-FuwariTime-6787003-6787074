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
  {"title": "rose water", "artist": "massobeats", "img": "assets/image/Massobeats.jpg", "path": "audio_asset/rosewater-music.mp3"},
  {"title": "Lofi-girl", "artist": "Watermello", "img": "assets/image/Watermello.webp", "path": "audio_asset/lofi-girl-music.mp3"},
  {"title": "Sad-love", "artist": "Oliver Hoss", "img": "assets/image/mizuharaaa.jpg", "path": "audio_asset/sad-love-music.mp3"},
  {"title": "Relax", "artist": "VibeHorn", "img": "assets/image/VibeHorn.webp", "path": "audio_asset/relax-Music.mp3"},
  {"title": "honey jam", "artist": "massobeats", "img": "assets/image/Honeyjam.webp", "path": "audio_asset/honeyjam-music.mp3"},
  {"title": "Donut", "artist": "Lukrembo", "img": "assets/image/Lukrembo.webp", "path": "audio_asset/donut-music.mp3"},
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

  // 💡 สร้างตัวแปรเก็บระดับเสียงปัจจุบัน (ค่าเริ่มต้นที่ 0.5 หรือ 50%)
  double currentVolume = 0.5;

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

    // เซ็ตระดับเสียงเริ่มต้นให้ audioPlayer ตอนเปิดแอปมาครั้งแรก
    audioPlayer.setVolume(currentVolume);
  }

  // 🚀 ฟังก์ชันปรับระดับเสียงที่ถูกเรียกใช้จากหน้า Setting
  void setVolume(double volume) {
    currentVolume = volume;
    try {
      audioPlayer.setVolume(volume);
    } catch (e) {
      debugPrint("❌ Error setting volume: $e");
    }
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

  // 🚀 ฟังก์ชันสำหรับเอาเพลงใหม่เข้าคลังแบบฉับพลัน (Local Update)
  void buyNewSong(Map<String, String> newSong) {
    // ก๊อปปี้ List เดิมออกมาก่อน
    List<Map<String, String>> currentList = List.from(globalMusicList.value);
    
    // เช็คว่ามีเพลงนี้อยู่แล้วหรือยัง
    if (!currentList.any((song) => song['title'] == newSong['title'])) {
      currentList.add(newSong);
      
      // 💥 สำคัญมาก! การใส่ค่ากลับไปแบบนี้ จะไปสะกิดให้หน้า Shop เปลี่ยนเป็น Sold Out 
      // และสะกิดให้หน้า Inventory กับ Music สร้างปุ่มเพลงใหม่ทันทีครับ!
      globalMusicList.value = currentList; 
      debugPrint("✅ ซื้อเพลง ${newSong['title']} เข้าคลังสำเร็จ!");
    }
  }
}

final musicController = MusicController();