import 'package:flutter/material.dart';
// 💡 อย่าลืม Import หน้า Setting เข้ามานะครับ
import 'package:fuwari_time/features/setting/setting.dart'; 

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) { 
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 30, left: 24, right: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFD6E8), Color(0xFFE4D4F4)],
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
                style: TextStyle(color: Colors.white, fontSize: 20, height: 1.2, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                const Text(
                  "1,250",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          
          // 💡 แก้ไขส่วนนี้: วาง Material ครอบไว้เพื่อให้โชว์เอฟเฟกต์ Hover/Splash ได้
          Material(
            color: Colors.transparent, // ให้พื้นหลังใส จะได้เห็นไล่สีของ TopBar
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Setting()),
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
                    image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/959ud1zb_expires_30_days.png"),
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