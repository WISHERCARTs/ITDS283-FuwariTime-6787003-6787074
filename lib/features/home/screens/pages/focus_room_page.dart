import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/pomodoro_timer_dialog.dart';
import '../../widgets/todo_list_dialog.dart';
import '../../services/background_controller.dart';

/// หน้า Focus Room (ห้องกลาง)
/// เป็นหน้าหลักที่ใช้แสดงตัวละครและโต๊ะทำงาน (ฉากศูนย์กลางภาพ Panorama)
/// ผู้ใช้จะใช้หน้านี้เป็นจุดเริ่มต้นในการกดเริ่มจับเวลา
class FocusRoomPage extends StatefulWidget {
  const FocusRoomPage({super.key});

  @override
  State<FocusRoomPage> createState() => _FocusRoomPageState();
}

class _FocusRoomPageState extends State<FocusRoomPage> {
  final PomodoroController _pomodoroController = PomodoroController();
  final TodoController _todoController = TodoController();
  
  bool _isTodoExpanded = false;

  // ตำแหน่ง Mini Timer (ลากย้ายได้)
  double _miniTimerX = 100;
  double _miniTimerY = 100;

  @override
  void initState() {
    super.initState();
    _pomodoroController.addListener(_onPomodoroChanged);
  }

  @override
  void dispose() {
    _pomodoroController.removeListener(_onPomodoroChanged);
    _pomodoroController.dispose();
    _todoController.dispose();
    super.dispose();
  }

  void _onPomodoroChanged() {
    setState(() {}); // rebuild เมื่อ controller เปลี่ยน state
  }

  @override
  Widget build(BuildContext context) {
    // เอา Container decoration ออกเพื่อให้มองเห็นวิดีโอพื้นหลังที่ซ้อนอยู่ด้านล่าง
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ==========================================
          // เลเยอร์ตัวละคร (Character)
          // ==========================================
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
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

          // ==========================================
          // เมนู (ไอคอนต่างๆ)
          // ==========================================
          Positioned(
            top: 100,
            left: 24,
            child: FocusRoomMenu(
              onClockTap: () {
                setState(() => _isTodoExpanded = false);
                _pomodoroController.expand();
              },
              onDocumentTap: () {
                setState(() {
                  _isTodoExpanded = !_isTodoExpanded;
                });
              },
              isTimerActive: _pomodoroController.sessionActive,
              isTodoActive: _isTodoExpanded,
            ),
          ),

          // ==========================================
          // Mini Timer (โชว์ตอน Timer กำลังเดิน)
          // ==========================================
          if (_pomodoroController.state == PomodoroState.running)
            Positioned(
              top: _miniTimerY,
              left: _miniTimerX,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _miniTimerX += details.delta.dx;
                    _miniTimerY += details.delta.dy;
                    // จำกัดไม่ให้ลากออกนอกจอ
                    final size = MediaQuery.of(context).size;
                    _miniTimerX = _miniTimerX.clamp(0, size.width - 80);
                    _miniTimerY = _miniTimerY.clamp(0, size.height - 80);
                  });
                },
                child: PomodoroMiniTimer(controller: _pomodoroController),
              ),
            ),

          // ==========================================
          // Expanded Overlay (โชว์ตอนตั้งค่า/ดูรายละเอียด Pomodoro)
          // ==========================================
          if (_pomodoroController.state == PomodoroState.expanded)
            Positioned.fill(
              child: PomodoroExpandedOverlay(
                  controller: _pomodoroController),
            ),

          // ==========================================
          // To-Do List Overlay (โชว์ตอนเปิดกระดาษโน้ต)
          // ==========================================
          if (_isTodoExpanded)
            Positioned.fill(
              child: TodoListOverlay(
                controller: _todoController,
                onDismiss: () {
                  setState(() {
                    _isTodoExpanded = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// ==========================================
/// FocusRoomMenu - เมนูไอคอนต่างๆ (กดแล้วกาง)
/// ==========================================
class FocusRoomMenu extends StatefulWidget {
  final VoidCallback onClockTap;
  final VoidCallback onDocumentTap;
  final bool isTimerActive;
  final bool isTodoActive;

  const FocusRoomMenu({
    super.key,
    required this.onClockTap,
    required this.onDocumentTap,
    this.isTimerActive = false,
    this.isTodoActive = false,
  });

  @override
  State<FocusRoomMenu> createState() => _FocusRoomMenuState();
}

class _FocusRoomMenuState extends State<FocusRoomMenu> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // ดึง BackgroundController มาใช้
    final bgController = context.watch<BackgroundController>();

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
                      // ปุ่มพระอาทิตย์ (กลางวัน)
                      _buildIconBtn(
                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/au6pn518_expires_30_days.png",
                        onTap: () => bgController.setTime(TimeState.day),
                        highlight: bgController.timeState == TimeState.day,
                      ),
                      const SizedBox(height: 12),
                      // ปุ่มพระจันทร์ (กลางคืน)
                      _buildIconBtn(
                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/qgtz05wd_expires_30_days.png",
                        onTap: () => bgController.setTime(TimeState.night),
                        highlight: bgController.timeState == TimeState.night,
                      ),
                      const SizedBox(height: 12),
                      // ปุ่มฝนตก
                      _buildIconBtn(
                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/oabfeq7e_expires_30_days.png",
                        onTap: () => bgController.toggleWeather(),
                        highlight: bgController.weatherState == WeatherState.rain,
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
                        onTap: widget.onClockTap,
                        highlight: widget.isTimerActive,
                      ),
                      const SizedBox(width: 12),
                      _buildIconBtn(
                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/azwg4gd4_expires_30_days.png",
                        onTap: widget.onDocumentTap,
                        highlight: widget.isTodoActive,
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

  Widget _buildIconBtn(String url, {VoidCallback? onTap, bool highlight = false}) {
    Widget icon = SizedBox(
      width: 28,
      height: 28,
      child: Image.network(url, fit: BoxFit.contain),
    );

    // ถ้ากำลังเลือกโหมดนี้อยู่ หรือฟีเจอร์นี้ถูกเปิดใช้งาน → เปลี่ยนสีไอคอนเป็นม่วงเข้ม
    if (highlight) {
      icon = ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Color(0xFF6B4B8A),
          BlendMode.srcATop,
        ),
        child: icon,
      );
    }

    return InkWell(
      onTap: onTap ?? () {},
      child: icon,
    );
  }
}
