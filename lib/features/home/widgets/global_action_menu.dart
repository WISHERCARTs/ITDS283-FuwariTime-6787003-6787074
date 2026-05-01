import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fuwari_time/features/home/services/background_controller.dart';

/// ==========================================
/// GlobalActionMenu - เมนูก้อนกลมที่ลอยนิ่งอยู่ทุกหน้า
/// ==========================================
class GlobalActionMenu extends StatefulWidget {
  final VoidCallback onClockTap;
  final VoidCallback onDocumentTap;
  final bool isTimerActive;
  final bool isTodoActive;

  const GlobalActionMenu({
    super.key,
    required this.onClockTap,
    required this.onDocumentTap,
    this.isTimerActive = false,
    this.isTodoActive = false,
  });

  @override
  State<GlobalActionMenu> createState() => _GlobalActionMenuState();
}

class _GlobalActionMenuState extends State<GlobalActionMenu> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // ดึง BackgroundController มาใช้ (Day/Night/Rain)
    final bgController = context.watch<BackgroundController>();

    return SizedBox(
      width: 200,
      height: 300,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Vertical Pill Background (Sun, Moon, Rain) - ควบคุมวิดีโอ
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
                        "assets/image/Sun.png", // 💡 แก้ชื่อไฟล์ตรงนี้ให้ตรงกับรูปที่มี
                        onTap: () => bgController.setTime(TimeState.day),
                        highlight: bgController.timeState == TimeState.day,
                      ),
                      const SizedBox(height: 12),
                      // ปุ่มพระจันทร์ (กลางคืน)
                      _buildIconBtn(
                        "assets/image/Moon.png", // 💡 แก้ชื่อไฟล์ตรงนี้ให้ตรงกับรูปที่มี
                        onTap: () => bgController.setTime(TimeState.night),
                        highlight: bgController.timeState == TimeState.night,
                      ),
                      const SizedBox(height: 12),
                      // ปุ่มฝนตก
                      _buildIconBtn(
                        "assets/image/Rain.png", // 💡 แก้ชื่อไฟล์ตรงนี้ให้ตรงกับรูปที่มี
                        onTap: () => bgController.toggleWeather(),
                        highlight: bgController.weatherState == WeatherState.rain,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Horizontal Pill Background (Clock, Document) - ควบคุมฟีเจอร์แอป
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
                        "assets/image/Clock.png", // 💡 แก้ชื่อไฟล์ตรงนี้ให้ตรงกับรูปที่มี
                        onTap: widget.onClockTap,
                        highlight: widget.isTimerActive,
                      ),
                      const SizedBox(width: 12),
                      _buildIconBtn(
                        "assets/image/Document.png", // 💡 แก้ชื่อไฟล์ตรงนี้ให้ตรงกับรูปที่มี
                        onTap: widget.onDocumentTap,
                        highlight: widget.isTodoActive,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main Circular Button (ก้อนกลมตัวแม่)
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
                child: Image.asset(
                  "assets/image/gom.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🚀 เปลี่ยนจากการรับ String url เป็น assetPath
  Widget _buildIconBtn(String assetPath, {VoidCallback? onTap, bool highlight = false}) {
    Widget icon = SizedBox(
      width: 28,
      height: 28,
      // 🚀 เปลี่ยนไปใช้ Image.asset แทน Image.network
      child: Image.asset(assetPath, fit: BoxFit.contain),
    );

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