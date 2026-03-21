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
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 1);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: Stack(
        children: [
          // เลเยอร์ที่ 1: เลื่อนปัดได้ (PageView)
          // รวมหน้าจอย่อย 3 หน้าเข้าด้วยกัน ผู้ใช้สามารถสไลด์นิ้วซ้าย-ขวาเพื่อเปลี่ยนห้องได้
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              physics: const ClampingScrollPhysics(), // ใช้ Clamping เพื่อให้ปัดหน้าจอสมูทและไม่ขยับทะลุขอบ
              children: const [
                TaskPlannerPage(), // Work Zone
                FocusRoomPage(), // Center
                ShopInventoryPage(), // Inventory
              ],
            ),
          ),

          // 2. Global UI Overlays
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(child: TopBar()),
          ),
          // Stack the music player and nav bar seamlessly at the bottom
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Hugs bottom tightly
              children: [
                BottomMusicPlayer(),
                SafeArea(
                  top: false, // Only safe area for bottom device bezel needed
                  child: BottomNavBar(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
