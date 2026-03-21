import 'package:flutter/material.dart';

/// หน้า Focus Room (ห้องกลาง)
/// เป็นหน้าหลักที่ใช้แสดงตัวละครและโต๊ะทำงาน (ฉากศูนย์กลางภาพ Panorama)
/// ผู้ใช้จะใช้หน้านี้เป็นจุดเริ่มต้นในการกดเริ่มจับเวลา
class FocusRoomPage extends StatelessWidget {
  const FocusRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // โหลดรูปภาพพื้นหลังเต็มเฟรมสำหรับหน้า Focus Room
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/bkel5x1z_expires_30_days.png"),
          fit: BoxFit.cover, // ให้ภาพขยายเต็มโดยรักษาสัดส่วน
        ),
      ),
      child: Scaffold(
        // ตั้งให้ Scaffold โปร่งใสเพื่อโชว์ภาพพื้นหลังของ Container 
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // ==========================================
            // เลเยอร์จัดวางตัวละครหลัก (Character Setup)
            // ==========================================
            // ใช้ Align เพื่อล็อกตำแหน่ง Character ให้อ้างอิงจากขอบขวาล่างเสมอ 
            // โค้ดส่วนนี้ช่วยให้นั่งทับเก้าอี้ตรงตามพิกัด Pixel-perfect ของดีไซน์ Figma ทุกขนาดหน้าจอ
            Align(
              alignment: Alignment.bottomRight, // ดันไปมุมขวาล่าง
              child: Padding(
                // ตั้งค่าระยะห่าง (Margin) จากขอบล่างและขอบขวา ตามพิกัดในดีไซน์ต้นฉบับ
                padding: const EdgeInsets.only(bottom: 218, right: 46), 
                child: SizedBox(
                  width: 172,
                  height: 184,
                  child: Image.network(
                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/122rtjhm_expires_30_days.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
