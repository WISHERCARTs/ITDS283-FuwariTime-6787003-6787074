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
                          title: "Rythm",
                          category: "Decoration",
                          price: "150",
                          imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/kl3914on_expires_30_days.png",
                        ),
                        _buildShopItem(
                          title: "Bacon Hotdog",
                          category: "Decoration",
                          price: "200",
                          imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/0kgsyagc_expires_30_days.png",
                        ),
                        _buildShopItem(
                          title: "Lofi Study",
                          category: "Music",
                          price: "500",
                          imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/o3p7q6p9_expires_30_days.png",
                          isOwned: ownedMusic.any((m) => m['title'] == "Lofi Study"),
                        ),
                        _buildShopItem(
                          title: "Summer Vibe",
                          category: "Music",
                          price: "500",
                          imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/v71r6p7k_expires_30_days.png",
                          isOwned: ownedMusic.any((m) => m['title'] == "Summer Vibe"),
                        ),
                        _buildShopItem(
                          title: "Midnight Jazz",
                          category: "Music",
                          price: "800",
                          imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/i36w7fh5_expires_30_days.png",
                          isOwned: ownedMusic.any((m) => m['title'] == "Midnight Jazz"),
                        ),
                        _buildShopItem(
                          title: "Rainy Day",
                          category: "Music",
                          price: "300",
                          imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/h94kqwgy_expires_30_days.png",
                          isOwned: ownedMusic.any((m) => m['title'] == "Rainy Day"),
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

  Widget _buildShopItem({
    required String title,
    required String category,
    required String price,
    required String imageUrl,
    bool isOwned = false,
  }) {
    return InkWell(
      onTap: isOwned
          ? null // 🚫 ถ้าซื้อแล้ว ห้ามกดเข้าไป
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopPay(
                    itemName: title,
                    itemPrice: int.parse(price),
                    imageUrl: imageUrl,
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
                  child: Opacity(
                    opacity: isOwned ? 0.6 : 1.0, // 💡 จางลงถ้าซื้อแล้ว
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: const Color(0xFFF3F4F6),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFFFD6E8),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF3F4F6),
                          child: const Center(
                            child: Icon(Icons.image_not_supported_rounded,
                                color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),
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
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 11,
                  ),
                ),
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
                        isOwned ? "Sold Out" : price,
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