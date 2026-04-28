import 'package:flutter/material.dart';

/// หน้า Focus Room (ห้องกลาง)
/// อัปเกรดใหม่: ทำหน้าที่แสดงผลตัวละครและโต๊ะทำงาน
/// ส่วนเมนูและนาฬิกาถูกย้ายไปที่ HomeScreen (Global) เพื่อให้ลอยคงที่ทับทุกหน้า
class FocusRoomPage extends StatelessWidget {
  const FocusRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // โปร่งใสเพื่อโชว์วิดีโอพื้นหลัง
      body: Stack(
        children: [
          // ==========================================
          // เลเยอร์ตัวละคร (Character) - คงเหลือไว้เฉพาะงานศิลป์
          // ==========================================
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 287, right: 80),
              child: SizedBox(
                width: 172,
                height: 184,
                child: Image.asset(
                  "assets/image/princess.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),

          // พื้นที่ด้านบนว่างเพื่อไม่ให้บัง Global Action Menu ที่ลอยอยู่หน้า Home
        ],
      ),
    );
  }
}
