import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';
import 'package:fuwari_time/features/shop/shop_pay/shop_pay.dart';
import 'package:fuwari_time/features/home/widgets/pomodoro_timer_dialog.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});
  @override
  ShopState createState() => ShopState();
}

class ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    // 🚀 ดึง Timer Controller จาก Global
    final pomodoroController = context.watch<PomodoroController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      body: SafeArea(
        child: Stack(
          children: [
            // 1. เนื้อหาร้านค้า
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopBar(currentIndex: 2),
                  const SizedBox(height: 24),
                  const Padding(
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
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                      children: [
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
                          title: "Slava",
                          category: "Furniture",
                          price: "350",
                          imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/i36w7fh5_expires_30_days.png",
                        ),
                        _buildShopItem(
                          title: "Orange 7",
                          category: "Decoration",
                          price: "120",
                          imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/h94kqwgy_expires_30_days.png",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            // 2. 🕒 Mini Timer (ลอยทับหน้า Shop เมื่อรันอยู่)
            if (pomodoroController.state == PomodoroState.running)
              Positioned(
                top: 150,
                right: 20,
                child: PomodoroMiniTimer(controller: pomodoroController),
              ),

             // 3. ⚙️ Pomodoro Expanded Overlay
            if (pomodoroController.state == PomodoroState.expanded)
              Positioned.fill(
                child: PomodoroExpandedOverlay(controller: pomodoroController),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopItem({
    required String title,
    required String category,
    required String price,
    required String imageUrl,
  }) {
    return InkWell(
      onTap: () {
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
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1F2937),
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
                    color: const Color(0xFFFEF9C3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.network(
                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/siq2ut46_expires_30_days.png",
                        width: 12,
                        height: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        price,
                        style: const TextStyle(
                          color: Color(0xFFA16207),
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