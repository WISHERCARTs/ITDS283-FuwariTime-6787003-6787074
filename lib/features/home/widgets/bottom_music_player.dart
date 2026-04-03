import 'package:flutter/material.dart';

/// แถบ Music Player (แสดงผลด้านล่างของจอ เหนือ Navigation Bar)
/// ออกแบบ UI เลียนแบบ YouTube Music Mini-Player สไตล์ Dark Theme เพื่อความทันสมัย
class BottomMusicPlayer extends StatelessWidget {
  const BottomMusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64, // กำหนดความสูงมาตรฐานสำหรับ Mini Player
      decoration: const BoxDecoration(
        color: Color(0xFF212121), // Theme
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment
            .end, // ดันชิ้นส่วนต่างๆ ให้ชิดขอบล่าง (ช่วยดัน Progress bar ติดขอบ)
        children: [
          Expanded(
            child: Row(
              children: [
                // ส่วนที่ 1: รูปภาพหน้าปก (Album Art)
                Container(
                  width: 44,
                  height: 44,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      4,
                    ), // ลบเหลี่ยมขอบรูปเล็กน้อย
                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/5f9gjw3c_expires_30_days.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // ส่วนที่ 2: ข้อมูลเพลง (Track Info)
                // ใช้ Expanded เพื่อให้ดึงพื้นที่ว่างที่เหลือดันไอคอนปุ่มไปด้านขวาสุด
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Lofi Study Beats",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow
                            .ellipsis, // หากข้อความยาวเกินให้จบด้วย "..."
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Fuwari Time ✨",
                        style: TextStyle(
                          color: Color(
                            0xFFAAAAAA,
                          ), // ตัวอักษรสีเทาบางๆ สำหรับชื่อศิลปิน
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // ส่วนที่ 3: แผงควบคุม (Cast และ Play)
                // หุ้มด้วย Material โปร่งใสเพื่อให้แสดง Animation กระเพื่อม (Ripple Effect) เวลากด
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: const Icon(Icons.cast, color: Colors.white, size: 24),
                    onPressed:
                        () {}, // ฟังก์ชันเชื่อมโยงเปิดทีวีนอก (ต่อเติมในอนาคต)
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () {}, // ฟังก์ชันจับเวลาเปิดเพลง
                  ),
                ),
                const SizedBox(width: 8), // เว้นระยะห่างขอบจอด้านขวา
              ],
            ),
          ),

          // ==========================================
          // แถบหลอดความคืบหน้าของเพลง (Bottom Progress Bar)
          // ==========================================
          const LinearProgressIndicator(
            value: 0.35, // ระดับความคืบหน้า (35%)
            backgroundColor: Color(0xFF424242), // พื้นทึบแถบที่ยังไม่ถึง
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xFFD8B4FE),
            ), // สีหลักแนวคิด Fuwari Purple
            minHeight: 2, // ให้แถบเป็นเส้นนำสายตาบางเฉียบที่สุด
          ),
        ],
      ),
    );
  }
}
