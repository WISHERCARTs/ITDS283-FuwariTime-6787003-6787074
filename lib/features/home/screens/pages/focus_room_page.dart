import 'package:flutter/material.dart';

/// หน้า Focus Room (ห้องกลาง)
/// เป็นหน้าหลักที่ใช้แสดงตัวละครและโต๊ะทำงาน
/// ผู้ใช้จะใช้หน้านี้เป็นจุดเริ่มต้นในการกดเริ่มจับเวลาอ่านหนังสือ
class FocusRoomPage extends StatelessWidget {
  const FocusRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/bkel5x1z_expires_30_days.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // เลเยอร์จัดวางตัวละคร: 
            // ใช้ Align เพื่อล็อกตำแหน่ง Character ให้อ้างอิงจากขอบขวาล่าง 
            // เพื่อให้นั่งทับเก้าอี้ตรงตามพิกัดของรูปพื้นหลังพอดี
            Align(
              alignment: Alignment.bottomRight, // Mirrors the Expanded logic stretching to the right
              child: Padding(
                padding: const EdgeInsets.only(bottom: 218, right: 46), // Exact margin specs from original code
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
