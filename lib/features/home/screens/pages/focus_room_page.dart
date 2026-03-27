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
          image: NetworkImage(
            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/bkel5x1z_expires_30_days.png",
          ),
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

            // เมนู Component 1 (ไอคอนต่างๆ)
            const Positioned(top: 100, left: 24, child: FocusRoomMenu()),
          ],
        ),
      ),
    );
  }
}

class FocusRoomMenu extends StatefulWidget {
  const FocusRoomMenu({Key? key}) : super(key: key);

  @override
  State<FocusRoomMenu> createState() => _FocusRoomMenuState();
}

class _FocusRoomMenuState extends State<FocusRoomMenu> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 300,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Vertical Pill Background (Sun, Moon, Rain)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            top: isExpanded ? 35 : 15,
            left: 14,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isExpanded ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: !isExpanded,
                child: Container(
                  width: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9D4F1),
                    borderRadius: BorderRadius.circular(21),
                  ),
                  padding: const EdgeInsets.only(top: 45, bottom: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildIconBtn(
                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/au6pn518_expires_30_days.png",
                      ),
                      const SizedBox(height: 12),
                      _buildIconBtn(
                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/qgtz05wd_expires_30_days.png",
                      ),
                      const SizedBox(height: 12),
                      _buildIconBtn(
                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/oabfeq7e_expires_30_days.png",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Horizontal Pill Background (Clock, Document)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            top: 14,
            left: isExpanded ? 35 : 15,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isExpanded ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: !isExpanded,
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9D4F1),
                    borderRadius: BorderRadius.circular(21),
                  ),
                  padding: const EdgeInsets.only(left: 45, right: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildIconBtn(
                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/n66fm0vh_expires_30_days.png",
                      ),
                      const SizedBox(width: 12),
                      _buildIconBtn(
                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/azwg4gd4_expires_30_days.png",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main Circular Button
          Positioned(
            top: 0,
            left: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: SizedBox(
                width: 70,
                height: 70,
                child: Image.network(
                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/p3g6a86q_expires_30_days.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconBtn(String url) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        width: 28,
        height: 28,
        child: Image.network(url, fit: BoxFit.contain),
      ),
    );
  }
}
