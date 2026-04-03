import 'dart:async';
import 'package:flutter/material.dart';

/// สถานะของ Pomodoro Timer
enum PomodoroState { idle, expanded, running }

/// ===================================================
/// PomodoroController - จัดการ Logic ทั้งหมดของ Timer
/// ===================================================
class PomodoroController extends ChangeNotifier {
  PomodoroState _state = PomodoroState.idle;
  PomodoroState get state => _state;

  bool _sessionActive = false;
  bool get sessionActive => _sessionActive;

  // ค่าที่ User ตั้ง
  int workMinutes = 25;
  int breakMinutes = 5;
  int loopCount = 3;

  // สถานะขณะ Timer ทำงาน
  int currentLoop = 1;
  bool isWorkPhase = true;
  int timeRemaining = 0;
  int totalTime = 0;
  Timer? _timer;
  bool isPaused = false;

  /// เปิดวงกลมใหญ่ (Expanded)
  void expand() {
    _state = PomodoroState.expanded;
    notifyListeners();
  }

  /// ปิดวงกลมใหญ่ (กลับไป running ถ้า session ยังเดินอยู่, ไม่งั้น idle)
  void dismiss() {
    _state = _sessionActive ? PomodoroState.running : PomodoroState.idle;
    notifyListeners();
  }

  /// เริ่มจับเวลา
  void start() {
    currentLoop = 1;
    isWorkPhase = true;
    totalTime = workMinutes * 60;
    timeRemaining = totalTime;
    isPaused = false;
    _sessionActive = true;
    _state = PomodoroState.running;
    notifyListeners();
    _tick();
  }

  void _tick() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timeRemaining > 0) {
        timeRemaining--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _onPhaseComplete();
      }
    });
  }

  void _onPhaseComplete() {
    if (isWorkPhase) {
      // Work จบ
      if (breakMinutes > 0) {
        // เข้า Break อัตโนมัติ
        isWorkPhase = false;
        totalTime = breakMinutes * 60;
        timeRemaining = totalTime;
        notifyListeners();
        _tick();
      } else {
        // Break = 0 ข้าม Break ไปเลย เช็ค Loop ต่อ
        _checkNextLoop();
      }
    } else {
      // Break จบ → เช็ก Loop
      _checkNextLoop();
    }
  }

  void _checkNextLoop() {
    if (loopCount > 0 && currentLoop < loopCount) {
      currentLoop++;
      isWorkPhase = true;
      totalTime = workMinutes * 60;
      timeRemaining = totalTime;
      notifyListeners();
      _tick();
    } else {
      // ครบทุก Loop แล้ว (หรือ loop=0 คือทำรอบเดียว)
      _sessionActive = false;
      _state = PomodoroState.idle;
      notifyListeners();
    }
  }

  /// สลับ Pause / Resume
  void togglePause() {
    if (isPaused) {
      isPaused = false;
      _tick();
    } else {
      isPaused = true;
      _timer?.cancel();
    }
    notifyListeners();
  }

  /// หยุด Timer ทั้งหมด
  void stop() {
    _timer?.cancel();
    _timer = null;
    _sessionActive = false;
    isPaused = false;
    _state = PomodoroState.idle;
    notifyListeners();
  }

  double get progress {
    if (totalTime == 0) return 0;
    return timeRemaining / totalTime;
  }

  String get timeString {
    final m = (timeRemaining ~/ 60).toString().padLeft(2, '0');
    final s = (timeRemaining % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  // ปุ่ม +/- สำหรับตั้งค่า
  void incrementWork() {
    if (workMinutes + 1 <= 60) { workMinutes += 1; notifyListeners(); }
  }
  void decrementWork() {
    if (workMinutes - 1 >= 1) { workMinutes -= 1; notifyListeners(); }
  }
  void incrementBreak() {
    if (breakMinutes + 1 <= 15) { breakMinutes += 1; notifyListeners(); }
  }
  void decrementBreak() {
    if (breakMinutes - 1 >= 0) { breakMinutes -= 1; notifyListeners(); }
  }
  void incrementLoop() {
    if (loopCount + 1 <= 10) { loopCount += 1; notifyListeners(); }
  }
  void decrementLoop() {
    if (loopCount - 1 >= 0) { loopCount -= 1; notifyListeners(); }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// ===================================================
/// PomodoroExpandedOverlay - วงกลมใหญ่ ตรงกลางจอ
/// ===================================================
class PomodoroExpandedOverlay extends StatelessWidget {
  final PomodoroController controller;
  const PomodoroExpandedOverlay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.dismiss, // แตะนอกวงกลม → ปิด
      child: Container(
        color: Colors.black26,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // ป้องกัน tap ทะลุวงกลม
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: controller.sessionActive
                  ? _buildRunningDetails()
                  : _buildSetupContent(),
            ),
          ),
        ),
      ),
    );
  }

  /// ========== โหมดตั้งค่า (ยังไม่ได้กด Start) ==========
  Widget _buildSetupContent() {
    return Container(
      width: 240,
      height: 240,
      decoration: _circleDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Work & Break แถวบน
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPicker("Work", controller.workMinutes,
                  controller.incrementWork, controller.decrementWork),
              _buildPicker("Break", controller.breakMinutes,
                  controller.incrementBreak, controller.decrementBreak),
            ],
          ),
          // Loop แถวล่าง
          _buildPicker("Loop", controller.loopCount,
              controller.incrementLoop, controller.decrementLoop),
          const SizedBox(height: 2),
          // ปุ่ม Start
          GestureDetector(
            onTap: controller.start,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF6B4B8A),
              ),
              child: const Icon(
                  Icons.play_arrow_rounded, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  /// ========== โหมดดูรายละเอียดขณะ Timer เดิน ==========
  Widget _buildRunningDetails() {
    final phaseLabel = controller.isWorkPhase ? "Focus" : "Break";
    final phaseColor = controller.isWorkPhase
        ? const Color(0xFF6B4B8A)
        : const Color(0xFF4B8A6B);

    return Container(
      width: 260,
      height: 260,
      decoration: _circleDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Phase label + Loop info
          Text(phaseLabel,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: phaseColor)),
          Text("Loop ${controller.currentLoop}/${controller.loopCount}",
              style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
          const SizedBox(height: 12),
          // Countdown ring + time
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: controller.progress,
                    strokeWidth: 6,
                    backgroundColor: Colors.white30,
                    valueColor: AlwaysStoppedAnimation<Color>(phaseColor),
                  ),
                ),
                Text(controller.timeString,
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Pause / Stop buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: controller.togglePause,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: phaseColor),
                  child: Icon(
                    controller.isPaused
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: controller.stop,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  child: const Icon(
                      Icons.stop_rounded, color: Colors.black54, size: 24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _circleDecoration() {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: const Color(0xFFE9D4F1),
      border: Border.all(color: Colors.grey.shade400, width: 3),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  Widget _buildPicker(
      String label, int value, VoidCallback onUp, VoidCallback onDown) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B4B8A))),
        GestureDetector(
          onTap: onUp,
          child: const Icon(Icons.keyboard_arrow_up_rounded,
              size: 18, color: Color(0xFF6B4B8A)),
        ),
        Container(
          width: 46,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: Text("$value",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333))),
        ),
        GestureDetector(
          onTap: onDown,
          child: const Icon(Icons.keyboard_arrow_down_rounded,
              size: 18, color: Color(0xFF6B4B8A)),
        ),
      ],
    );
  }
}

/// ===================================================
/// PomodoroMiniTimer - วงเล็ก แสดงเวลานับถอยหลัง
/// ===================================================
class PomodoroMiniTimer extends StatelessWidget {
  final PomodoroController controller;
  const PomodoroMiniTimer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final phaseColor = controller.isWorkPhase
        ? const Color(0xFF6B4B8A)
        : const Color(0xFF4B8A6B);
    final bgColor = controller.isWorkPhase
        ? const Color(0xFFE9D4F1)
        : const Color(0xFFD4F1E9);

    return GestureDetector(
      onTap: controller.expand, // กดวงเล็ก → เปิดวงกลมใหญ่
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
          border: Border.all(color: Colors.grey.shade400, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // วงแหวน Progress
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: controller.progress,
                strokeWidth: 5,
                backgroundColor: Colors.white30,
                valueColor: AlwaysStoppedAnimation<Color>(phaseColor),
              ),
            ),
            // ตัวเลข + Loop
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.isWorkPhase ? "Focus" : "Break",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: phaseColor,
                  ),
                ),
                const SizedBox(height: 1),
                Text(controller.timeString,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333))),
                Text("${controller.currentLoop}/${controller.loopCount}",
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFF666666))),
              ],
            ),
          ],
        ),
      ),
    );
  }

}


