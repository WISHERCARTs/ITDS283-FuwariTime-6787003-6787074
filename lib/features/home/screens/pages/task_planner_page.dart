import 'package:flutter/material.dart';

/// หน้า Task Planner / Work Zone (หน้าซ้ายสุด)
/// ใช้สำหรับจัดการ To-Do list และแสดงผลความสำเร็จ (Recent Achievements)
class TaskPlannerPage extends StatelessWidget {
  const TaskPlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // โปร่งใสเพื่อโชว์วิดีโอพื้นหลัง
      body: Padding(
        // ดัน UI ทั้งหมดหนีจาก TopBar ระดับ Global เพื่อไม่ให้บังกัน
        padding: const EdgeInsets.only(top: 140, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // การ์ดแสดงผลงานความสำเร็จ (Recent Achievements Card)
            // ==========================================
            

            // สำรองพื้นที่ด้านล่างไว้ไม่ให้ Navigation Bar และ Music Player บังเนื้อหา
            const SizedBox(height: 160),
          ],
        ),
      ),
    );
  }
}