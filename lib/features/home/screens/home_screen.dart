import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/task_planner_page.dart';
import 'pages/focus_room_page.dart';
import 'pages/shop_inventory_page.dart';
import '../widgets/top_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/video_background_layer.dart';
import '../widgets/global_action_menu.dart';
import '../widgets/pomodoro_timer_dialog.dart';
import '../widgets/todo_list_dialog.dart';
import 'package:fuwari_time/features/home/services/background_controller.dart';
import 'package:fuwari_time/features/music/music_state.dart';

/// หน้าจอหลักของแอปพลิเคชัน (HomeScreen)
/// ปรับปรุงใหม่: รองรับ Global Action Menu และ Overlays ที่ลอยคงที่ทับทุกหน้า
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 1);

  bool _isTodoExpanded = false;

  // ตำแหน่ง Mini Timer (ลากย้ายได้)
  double _miniTimerX = 100;
  double _miniTimerY = 150;

  @override
  void initState() {
    super.initState();
    // ซิงค์ข้อมูลคลังเก็บของ (Inventory) จาก Supabase ทันทีที่เข้าแอป
    musicController.syncInventory();

    // เริ่มซิงค์พิกัดหลังจากเข้าหน้า Home 3 วินาท เพื่อความเสถียรที่สุด
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.read<BackgroundController>().syncLocationAndWeather();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🚀 ดึง Controllers จาก Global Provider
    final pomodoroController = context.watch<PomodoroController>();
    final todoController = context.watch<TodoController>();

    return Scaffold(
      extendBody: true,
      body: VideoBackgroundLayer(
        pageController: _pageController,
        child: Stack(
          children: [
            // 1. เลเยอร์พื้นหลังปัดได้ (PageView)
            Positioned.fill(
              child: PageView(
                controller: _pageController,
                physics: const ClampingScrollPhysics(),
                children: const [
                  TaskPlannerPage(),
                  FocusRoomPage(),
                  ShopInventoryPage(),
                ],
              ),
            ),

            // 2. แถบเมนูด้านบน (Top Bar)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: TopBar(currentIndex: 0),
            ),

            // 3. เครื่องเล่นเพลงและ Navigation Bar ด้านล่าง
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [BottomNavBar()],
              ),
            ),

            // ==========================================
            // GLOBAL OVERLAYS (ส่วนที่ลอยนิ่งทับทุกหน้า)
            // ==========================================

            // 4. Global Action Menu (เมนูก้อนกลม - ตรึงตำแหน่ง)
            Positioned(
              top: 140,
              left: 24,
              child: GlobalActionMenu(
                onClockTap: () {
                  setState(() => _isTodoExpanded = false);
                  pomodoroController.expand();
                },
                onDocumentTap: () {
                  setState(() {
                    _isTodoExpanded = !_isTodoExpanded;
                  });
                },
                isTimerActive: pomodoroController.sessionActive,
                isTodoActive: _isTodoExpanded,
              ),
            ),

            // 5. Mini Timer (ลอยนิ่งและลากได้ข้ามหน้า)
            if (pomodoroController.state == PomodoroState.running)
              Positioned(
                top: _miniTimerY,
                left: _miniTimerX,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _miniTimerX += details.delta.dx;
                      _miniTimerY += details.delta.dy;
                      // จำกัดขอบเขตการลาก
                      final size = MediaQuery.of(context).size;
                      _miniTimerX = _miniTimerX.clamp(0, size.width - 80);
                      _miniTimerY = _miniTimerY.clamp(0, size.height - 200);
                    });
                  },
                  child: PomodoroMiniTimer(controller: pomodoroController),
                ),
              ),

            // 6. Pomodoro Expanded Overlay (หน้าตั้งค่าเวลา)
            if (pomodoroController.state == PomodoroState.expanded)
              Positioned.fill(
                child: PomodoroExpandedOverlay(controller: pomodoroController),
              ),

            // 7. To-Do List Overlay (หน้าสมุดโน้ต)
            if (_isTodoExpanded)
              Positioned.fill(
                child: TodoListOverlay(
                  controller: todoController,
                  onDismiss: () {
                    setState(() {
                      _isTodoExpanded = false;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
