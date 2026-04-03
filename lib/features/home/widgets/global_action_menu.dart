import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/background_controller.dart';

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
