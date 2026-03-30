import 'package:flutter/material.dart';
// 💡 1. อย่าลืม Import หน้า ShopPay เข้ามาด้วยนะครับ (แก้ path ให้ตรงกับโฟลเดอร์ของคุณ)
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';
import 'package:fuwari_time/features/shop/shop_pay/shop_pay.dart'; // 👈 แก้ Path ให้ตรงกับไฟล์ ShopPay ของคุณ

class Shop extends StatefulWidget {
  const Shop({super.key});
  @override
  ShopState createState() => ShopState();
}

class ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopBar(),
              
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
      ),
    );
  }

  // ==========================================
  // ฟังก์ชันย่อยสำหรับวาด "การ์ดสินค้า" แต่ละชิ้น
  // ==========================================
  Widget _buildShopItem({
    required String title,
    required String category,
    required String price,
    required String imageUrl,
  }) {
    // 💡 2. เอา InkWell มาครอบการ์ดไว้เลยครับ เพื่อให้กดตรงไหนของการ์ดก็ไปหน้า ShopPay
    return InkWell(
      onTap: () {
        // 💡 3. สั่งเปลี่ยนหน้า พร้อมโยนข้อมูลส่งไปให้หน้า ShopPay
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopPay(
              itemName: title,
              itemPrice: int.parse(price), // แปลง String เป็น Int
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16), // ทำแอนิเมชันตอนกดให้โค้งตามการ์ด
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
                // 💡 เปลี่ยนตรงนี้เป็น Container ธรรมดา (เพราะเราให้กดได้ทั้งการ์ดแล้ว)
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