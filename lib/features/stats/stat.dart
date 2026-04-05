import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';
import 'package:fuwari_time/features/home/widgets/pomodoro_timer_dialog.dart';
import '../../services/timer_service.dart';

class Stat extends StatefulWidget {
  const Stat({super.key});
  @override
  StatState createState() => StatState();
}

class StatState extends State<Stat> {
  final TimerService _timerService = TimerService();
  double focusHours = 0.0;
  double breakHours = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final stats = await _timerService.getTodayStats(user.id);
    setState(() {
      focusHours = stats['focus_hours'] ?? 0.0;
      breakHours = stats['break_hours'] ?? 0.0;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🚀 ดึง Timer Controller จาก Global
    final pomodoroController = context.watch<PomodoroController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1), 
      body: SafeArea(
        child: Stack(
          children: [
            // 1. เนื้อหาสถิติ
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const TopBar(currentIndex: 1),
                  const SizedBox(height: 30),
                  _isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : _buildStatsCard(),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            // 2. 🕒 Mini Timer (ลอยทับหน้า Stats เมื่อรันอยู่)
            if (pomodoroController.state == PomodoroState.running)
              Positioned(
                top: 150,
                right: 20,
                child: PomodoroMiniTimer(controller: pomodoroController),
              ),

             // 3. ⚙️ Pomodoro Expanded Overlay
            if (pomodoroController.state == PomodoroState.expanded)
              Positioned.fill(
                child: PomodoroExpandedOverlay(controller: pomodoroController),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // เงาบางๆ
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Stats Today",
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // 💡 แถบที่ 1: Focus Time
          _buildStatRow(
            dotColor: const Color(0xFFEF4444), // สีแดง
            label: "Focus Time",
            time: "${focusHours.toStringAsFixed(1)}h",
            percent: (focusHours / 8).clamp(0.0, 1.0), // เต็มหลอดที่ 8 ชม.
          ),
          
          const SizedBox(height: 20),
          
          // 💡 แถบที่ 2: Break Time
          _buildStatRow(
            dotColor: const Color(0xFF22C55E), // สีเขียว
            label: "Break Time",
            time: "${breakHours.toStringAsFixed(1)}h",
            percent: (breakHours / 4).clamp(0.0, 1.0), // เต็มหลอดที่ 4 ชม.
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow({
    required Color dotColor,
    required String label,
    required String time,
    required double percent,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF374151), fontSize: 13),
          ),
        ),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: percent,
              child: Container(
                decoration: BoxDecoration(
                  color: dotColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 40,
          child: Text(
            time,
            textAlign: TextAlign.right,
            style: const TextStyle(color: Color(0xFF4B5563), fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}