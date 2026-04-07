import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';
import 'package:fuwari_time/features/shop/shop_pay/shop_pay.dart';
import 'package:fuwari_time/features/home/widgets/pomodoro_timer_dialog.dart';
import 'package:fuwari_time/features/music/music_state.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});
  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  void initState() {
    super.initState();
    // 🔄 ซิงค์ข้อมูลกระเป๋า (Inventory) ทันทีที่เข้าหน้า Shop
    WidgetsBinding.instance.addPostFrameCallback((_) {
      musicController.syncInventory();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🚀 ใช้ context.select แทน context.watch
    final pomodoroState = context.select<PomodoroController, PomodoroState>(
      (controller) => controller.state,
    );
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      body: Stack(
        children: [
          // 1. เนื้อหาร้านค้า (CustomScrollView + SliverGrid = Lazy Loading)
          ValueListenableBuilder<List<Map<String, String>>>(
            valueListenable: globalMusicList,
            builder: (context, ownedMusic, _) {
              return CustomScrollView(
                slivers: [
                  // 1.1 เว้นที่ให้ TopBar
                  SliverToBoxAdapter(
                    child: SizedBox(height: topPadding + 80),
                  ),

                  // 1.2 หัวข้อ "Shop"
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        "Shop",
                        style: TextStyle(
                          color: Color(0xFF1F2937),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // 1.3 Grid ของสินค้า (ใช้ SliverPadding + SliverGrid)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildListDelegate([
                        
                        _buildShopItem(
                          title: "rose water",
                          artist: "massobeats",
                          path: "audio_asset/rosewater-music.mp3",
                          price: 1, // 💡 ทดสอบซื้อด้วยราคา 1
                          img: "assets/image/Massobeats.jpg", 
                          // 🚀 💡 จุดนี้สำคัญมาก! ลืมใส่ isOwned ไปครับ ทำให้มันไม่รู้ว่าซื้อแล้ว
                          isOwned: ownedMusic.any((m) => m['title'] == "rose water"),
                        ),

                        _buildShopItem(
                          title: "Lofi-girl",
                          artist: "Watermello",
                          path: "audio_asset/lofi-girl-music.mp3",
                          price: 1,
                          img: "assets/image/Watermello.webp", 
                          isOwned: ownedMusic.any((m) => m['title'] == "Lofi-girl"),
                        ),
                        
                        // 🎶 ไอเทมเพลง
                        _buildShopItem(
                          title: "Sad-love",
                          artist: "Oliver Hoss",
                          path: "audio_asset/sad-love-music.mp3",
                          price: 800,
                          img: "assets/image/mizuharaaa.jpg",
                          isOwned: ownedMusic.any((m) => m['title'] == "Sad-love"),
                        ),
                        _buildShopItem(
                          title: "Relax",
                          artist: "VibeHorn",
                          path: "audio_asset/relax-Music.mp3",
                          price: 100,
                          img: "assets/image/VibeHorn.webp",
                          isOwned: ownedMusic.any((m) => m['title'] == "Relax"), 
                        ),

                        _buildShopItem(
                          title: "honey jam",
                          artist: "massobeats",
                          path: "audio_asset/honeyjam-music.mp3",
                          price: 200,
                          img: "assets/image/Honeyjam.webp",
                          isOwned: ownedMusic.any((m) => m['title'] == "honey jam"), 
                        ),

                        _buildShopItem(
                          title: "Donut",
                          artist: "Lukrembo",
                          path: "audio_asset/donut-music.mp3",
                          price: 200,
                          img: "assets/image/Lukrembo.webp",
                          isOwned: ownedMusic.any((m) => m['title'] == "Donut"), 
                        ),

                        _buildShopItem(
                          title: "ChocoLate",
                          artist: "Lukrembo",
                          path: "audio_asset/chocolate-music.mp3",
                          price: 50,
                          img: "assets/image/Chocolate.webp",
                          isOwned: ownedMusic.any((m) => m['title'] == "ChocoLate"), 
                        ),

                        _buildShopItem(
                          title: "At Ease",
                          artist: "Hazelwood",
                          path: "audio_asset/at-ease-music.mp3",
                          price: 150,
                          img: "assets/image/AtEase.webp",
                          isOwned: ownedMusic.any((m) => m['title'] == "At Ease"), 
                        ),

                        _buildShopItem(
                          title: "mango tea",
                          artist: "massobeats",
                          path: "audio_asset/mango-tea-music.mp3",
                          price: 150,
                          img: "assets/image/Mangotea.webp",
                          isOwned: ownedMusic.any((m) => m['title'] == "mango tea"), 
                        ),

                        _buildShopItem(
                          title: "Lonely Samurai",
                          artist: "Walen",
                          path: "audio_asset/lonely-samurai-music.mp3",
                          price: 150,
                          img: "assets/image/LonelySamurai.webp",
                          isOwned: ownedMusic.any((m) => m['title'] == "Lonely Samurai"), 
                        ),
                      ]),
                    ),
                  ),

                  // 1.4 ช่องว่างด้านล่าง
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              );
            },
          ),

          // 2. แถบเมนูด้านบน (Top Bar - นิ่งอยู่กับที่)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopBar(currentIndex: 2),
          ),

          // 3. 🕒 Mini Timer
          if (pomodoroState == PomodoroState.running)
            Positioned(
              top: 150,
              right: 20,
              child: Consumer<PomodoroController>(
                builder: (context, controller, _) =>
                    PomodoroMiniTimer(controller: controller),
              ),
            ),

          // 4. ⚙️ Pomodoro Expanded Overlay
          if (pomodoroState == PomodoroState.expanded)
            Consumer<PomodoroController>(
              builder: (context, controller, _) => Positioned.fill(
                child: PomodoroExpandedOverlay(controller: controller),
              ),
            ),
        ],
      ),
    );
  }

  // 🚀 ปรับพารามิเตอร์ให้รับ title, artist, path, price (int), img
  Widget _buildShopItem({
    required String title,
    required String artist,
    required String path,
    required int price,
    required String img,
    bool isOwned = false,
  }) {
    
    // 💡 1. สร้างตัวแปรเก็บรูปภาพ (เช็คว่าเป็นเน็ตหรือไฟล์ในเครื่อง)
    Widget imageWidget = img.startsWith('http')
        ? Image.network(
            img,
            fit: BoxFit.cover,
            width: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: const Color(0xFFF3F4F6),
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFFD6E8)),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFFF3F4F6),
              child: const Center(child: Icon(Icons.image_not_supported_rounded, color: Colors.grey)),
            ),
          )
        : Image.asset(
            img,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFFF3F4F6),
              child: const Center(child: Icon(Icons.image_not_supported_rounded, color: Colors.grey)),
            ),
          );

    // 🚀 💡 2. ใช้ Matrix เพื่อให้รูปกลายเป็นขาวดำชัวร์ 100%
    if (isOwned) {
      imageWidget = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0,      0,      0,      1, 0,
        ]),
        child: Opacity(
          opacity: 0.6, // ทำให้ภาพดูจางลง
          child: imageWidget,
        ),
      );
    }

    return InkWell(
      onTap: isOwned
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$title is already Sold Out!", textAlign: TextAlign.center),
                  backgroundColor: Colors.grey.shade700,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            } 
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopPay(
                    title: title,
                    artist: artist,
                    path: path,
                    price: price,
                    img: img,
                  ),
                ),
              );
            },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  // 💡 เอาตัวแปรรูปภาพที่เราทำไว้ด้านบน มาแสดงตรงนี้เลย
                  child: imageWidget, 
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: isOwned ? Colors.grey : const Color(0xFF1F2937),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (artist.isNotEmpty)
              Text(
                artist,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOwned ? Colors.grey.shade200 : const Color(0xFFFEF9C3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      if (!isOwned) ...[
                        Image.network(
                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/siq2ut46_expires_30_days.png",
                          width: 12,
                          height: 12,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        isOwned ? "Sold Out" : "$price", 
                        style: TextStyle(
                          color: isOwned ? Colors.grey : const Color(0xFFA16207),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}