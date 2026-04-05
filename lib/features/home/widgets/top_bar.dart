import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// 💡 อย่าลืม Import หน้า Setting เข้ามานะครับ
import 'package:fuwari_time/features/setting/setting.dart';

class TopBar extends StatelessWidget {
  // 🚀 1. เพิ่มตัวแปรเพื่อรับค่าว่าตอนนี้อยู่หน้าไหน
  final int currentIndex;

  // 🚀 2. ใส่ this.currentIndex เข้ามา (กำหนดให้ค่าเริ่มต้นเป็น 0)
  const TopBar({super.key, this.currentIndex = 0});

  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  @override
  Widget build(BuildContext context) {
    // ดึงค่าระยะห่างจากขอบจอด้านบน (ติ่งหน้าจอ หรือ แถบสถานะ)
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      // ตัวพื้นหลังจะรวมระยะ Top Padding เข้าไปด้วยเพื่อให้สีมันคลุมไปถึงขอบบนสุด
      padding: EdgeInsets.only(
        top: topPadding > 0 ? topPadding + 10 : 20,
        bottom: 30,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        // ปรับขอบล่างให้โค้งมนดูนุ่มนวล
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000), // เงาสีดำจางๆ
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
        // ไล่สีจากมุมบนซ้ายไปล่างขวา
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFD6E8), // ชมพูพาสเทล
            Color(0xFFE4D4F4), // ม่วงพาสเทล
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network(
                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/junj4an5_expires_30_days.png",
                width: 39,
                height: 40,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 12),
              const Text(
                "Fuwari Time",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // 💰 [ส่วนที่แก้] ใช้ StreamBuilder ดึงแต้ม Real-time จาก Supabase
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _currentUserId != null
                ? Supabase.instance.client
                      .from('profiles')
                      .stream(primaryKey: ['id'])
                      .eq('id', _currentUserId!)
                : null,
            builder: (context, snapshot) {
              int points = 0;
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                points = snapshot.data!.first['points'] ?? 0;
              }

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x4DFFFFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Image.network(
                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/hevi4h27_expires_30_days.png",
                      width: 16,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      points.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 💡 วาง Material ครอบไว้เพื่อให้โชว์เอฟเฟกต์ Hover/Splash ได้
          Material(
            color: Colors.transparent, // ให้พื้นหลังใส จะได้เห็นไล่สีของ TopBar
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  // 🚀 3. แนบ currentIndex ส่งต่อไปให้หน้า Setting ด้วย!
                  MaterialPageRoute(
                    builder: (context) => Setting(currentIndex: currentIndex),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(25),
              // 💡 ตั้งค่าสีตอนเอาเมาส์ชี้ (Hover) หรือตอนกด (Splash) ให้เป็นสีขาวจางๆ
              hoverColor: Colors.white.withOpacity(0.3),
              splashColor: Colors.white.withOpacity(0.4),
              highlightColor: Colors.white.withOpacity(0.2),

              // 💡 เปลี่ยนจาก ClipRRect มาใช้ Ink()
              child: Ink(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/959ud1zb_expires_30_days.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
