import 'package:flutter/material.dart';

/// หน้า Task Planner / Work Zone (หน้าซ้ายสุด)
/// ใช้สำหรับจัดการ To-Do list และแสดงผลความสำเร็จ (Recent Achievements)
class TaskPlannerPage extends StatelessWidget {
  const TaskPlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // โหลดรูปภาพพื้นหลังเต็มเฟรมสำหรับ Work Zone (ภาพโซนซ้าย)
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/3wq8cvs8_expires_30_days.png",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // โปร่งใสเพื่อโชว์ฉากหลัง Container
        body: Padding(
          // ดัน UI ทั้งหมดหนีจาก TopBar ระดับ Global เพื่อไม่ให้บังกัน
          padding: const EdgeInsets.only(top: 140, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // การ์ดแสดงผลงานความสำเร็จ (Recent Achievements Card)
              // ==========================================
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFFFFFFFF),
                  // ใส่เงาให้กล่องนูนลอยออกมา (Drop Shadow Concept)
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000), // ดำโปร่งใส 10%
                      blurRadius: 15, // รัศมีความเบลอ
                      offset: Offset(0, 10), // ดันเงาลงด้านล่าง 10px
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                // ใช้ MainAxisSize.min เพื่อให้การ์ดสูงเท่ากับของจริงที่อยู่ข้างใน ไม่ยืดสุดขอบ
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Recent Achievements",
                      style: TextStyle(
                        color: Color(0xFF1F2937),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // แถบไอเทมความสำเร็จ
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        // ไล่สี Gradient จากม่วงอ่อนไปชมพูพาสเทล
                        gradient: const LinearGradient(
                          begin: Alignment(-1, -1),
                          end: Alignment(-1, 1),
                          colors: [Color(0x33E4D4F4), Color(0x33FFD6E8)],
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // กรอบรูปถ้วยรางวัล หรือ ถุงเหรียญ
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.only(right: 16),
                            width: 48,
                            height: 48,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/mhigfhlt_expires_30_days.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          // ชิ้นส่วนข้อความแจ้งสถานการณ์
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "First Week!",
                                  style: TextStyle(
                                    color: Color(0xFF1F2937),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Complete 7 days streak",
                                  style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // โบนัสคะแนน
                          const Text(
                            "+100",
                            style: TextStyle(
                              color: Color(0xFFC8B8E6),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(), // ดันก้อนต่อไปลงด้านล่างสุดของพื้นที่
              // ==========================================
              // ไอคอนลูกศรบอกทาง (Indicator Direction)
              // ==========================================
              // ไอคอนชี้ไปทางขวา เพื่อไกด์ผู้ใช้ว่าหน้าหลัก (Core Room) อยู่ฝั่งขวา
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.network(
                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/r1xmywj6_expires_30_days.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              // สำรองพื้นที่ด้านล่างไว้ไม่ให้ Navigation Bar และ Music Player บังไอคอน
              const SizedBox(height: 160),
            ],
          ),
        ),
      ),
    );
  }
}
