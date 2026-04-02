import 'package:flutter/material.dart';
import 'pages/task_planner_page.dart';
import 'pages/focus_room_page.dart';
import 'pages/shop_inventory_page.dart';
import '../widgets/top_bar.dart';
import '../widgets/bottom_music_player.dart';
import '../widgets/bottom_nav_bar.dart';

/// หน้าจอหลักของแอปพลิเคชัน (HomeScreen)
/// ทำหน้าที่เป็นตลับใหญ่สุดในการจัดการ UI แบบ "Seamless Panorama"
/// โดยใช้โครงสร้างแบบ Stack เพื่อซ้อนเลเยอร์ของหน้าจอที่ปัดได้ (PageView)
/// ไว้ข้างใต้ UI ที่ลอยอยู่กับที่ (เช่น แถบเมนูด้านล่าง และด้านบน)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // สร้าง Controller สำหรับจัดการหน้า PageView โดยตั้งค่าหน้าเริ่มต้นเป็นหน้าที่ 1 (FocusRoomPage)
  final PageController _pageController = PageController(initialPage: 1);

  @override
  void dispose() {
    // ทำลาย Controller เพื่อคืนหน่วยความจำ (Memory Management) เมื่อปิดหน้าจอ
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // กำหนดสีพื้นหลังโทนอุ่นของแอปพลิเคชัน
      backgroundColor: const Color(0xFFFFF8F0),
      body: Stack(
        children: [
          // ==========================================
          // เลเยอร์ที่ 1: พื้นที่แสดงผลแบบเลื่อนปัดได้ (PageView)
          // ==========================================
          // ใช้ Positioned.fill เพื่อตรึง PageView ให้เต็มความกว้างและความสูงของจอ
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              // ใช้ ClampingScrollPhysics เพื่อให้ปัดหน้าจอสมูทและไม่ขยับทะลุขอบ (No Overscroll)
              physics: const ClampingScrollPhysics(), 
              children: const [
                // หน้าจอย่อยทั้ง 3 หน้า (เรียงลำดับจากซ้ายไปขวา)
                TaskPlannerPage(),    // Index 0: หน้า Work Zone สำหรับแสดง Planner
                FocusRoomPage(),      // Index 1: หน้า Focus Room จุดศูนย์กลาง
                ShopInventoryPage(),  // Index 2: หน้า Inventory สำหรับดูไอเทม
              ],
            ),
          ),

          // ==========================================
          // เลเยอร์ที่ 2: Global UI Overlays (ส่วนติดต่อผู้ใช้แบบคงที่)
          // ==========================================
          
          // 2.1 แถบเมนูด้านบน (Top Bar)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            // ครอบ SafeArea ป้องกันการแสดงผลทับรอยแหว่ง (Notch) ด้านบนของสมาร์ทโฟน
            child: SafeArea(child: TopBar()), 
          ),

          // 2.2 วาง Music Player และ Navigation Bar ซ้อนกันด้านล่างสุด
          // ใช้ Column ผสม MainAxisSize.min เพื่อให้แพ็กตัวกันแน่นโดยไม่ซ้อนทับกัน
          const Positioned(
            bottom: 0, 
            left: 0, 
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min, // จำกัดความสูงของ Column ให้พอดีกับ Widget ด้านใน
              children: [
                BottomMusicPlayer(), // เครื่องเล่นเพลงส่วนล่าง
                SafeArea(
                  top: false, // ต้องการ Safe area เฉพาะส่วนขอบจอด้านล่าง
                  child: BottomNavBar(), // แถบปุ่มกดเมนู 4 หน้า
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
