import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';
import 'package:fuwari_time/features/home/widgets/pomodoro_timer_dialog.dart';
import 'package:fuwari_time/features/home/services/background_controller.dart';

class Stat extends StatefulWidget {
  const Stat({super.key});
  @override
  StatState createState() => StatState();
}

class StatState extends State<Stat> {
  @override
  Widget build(BuildContext context) {
    // 🚀 ใช้ select เฝ้าดูเฉพาะสถานะ ไม่ rebuild ทุกวินาที
    final pomodoroState = context.select<PomodoroController, PomodoroState>(
      (c) => c.state,
    );
    final backgroundController = context.watch<BackgroundController>();
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Please log in")));
    }

    final now = DateTime.now();

    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      body: Stack(
        children: [
          // 📊 1. Main Statistics Content (Scrollable)
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: topPadding + 80), // 🚀 Space for TopBar dynamic

                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: Supabase.instance.client
                      .from('timer_sessions')
                      .stream(primaryKey: ['id'])
                      .eq('user_id', user.id),
                  builder: (context, snapshot) {
                    double focusHours = 0.0;
                    double breakHours = 0.0;

                    if (snapshot.hasData) {
                      // 💡 Filter only today's data manually from the stream results
                      final todaySessions = snapshot.data!.where((s) {
                        final createdAt = DateTime.parse(s['created_at']);
                        return createdAt.isAfter(
                          DateTime(now.year, now.month, now.day),
                        );
                      }).toList();

                      for (var s in todaySessions) {
                        final duration =
                            (s['duration_mins'] as int).toDouble() / 60;
                        if (s['session_type'] == 'focus') {
                          focusHours += duration;
                        } else {
                          breakHours += duration;
                        }
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          // 🍎 1.1 Main Focus Chart (Circular)
                          _buildMainChart(focusHours),
                          const SizedBox(height: 24),

                          // 📈 1.2 Detail Stats Grid
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatMiniCard(
                                  label: "Focus Time",
                                  value: "${focusHours.toStringAsFixed(1)}h",
                                  icon: Icons.timer_rounded,
                                  color: const Color(0xFFEF4444),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatMiniCard(
                                  label: "Break Time",
                                  value: "${breakHours.toStringAsFixed(1)}h",
                                  icon: Icons.coffee_rounded,
                                  color: const Color(0xFF22C55E),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 🕒 1.3 App Usage Card (Live Timer)
                          _buildAppUsageCard(
                            backgroundController.appUsageDuration,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),

          // 🏗️ 2. Fixed Top Bar (Fixed position)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopBar(currentIndex: 1),
          ),

          // 🕘 3. Mini Timer Overlay
          if (pomodoroState == PomodoroState.running)
            Positioned(
              top: 150,
              right: 24,
              child: Consumer<PomodoroController>(
                builder: (context, controller, _) =>
                    PomodoroMiniTimer(controller: controller),
              ),
            ),

          // ⚙️ 4. Pomodoro Expanded Overlay
          if (pomodoroState == PomodoroState.expanded)
            Consumer<PomodoroController>(
              builder: (context, controller, _) => Positioned.fill(
                child: PomodoroExpandedOverlay(controller: controller),
              ),
            ),
        ],
      ),
    );
  }

  // 🍩 1.1 Main Focus Chart Widget (Circular Glow)
  Widget _buildMainChart(double hours) {
    const double goalHours = 8.0; // Goal is 8 hours focus per day
    final double percent = (hours / goalHours).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Overall Focus Progress",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 32),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 16,
                  backgroundColor: const Color(0xFFF3F4F6),
                  color: const Color(0xFFFFD6E8),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  Text(
                    "${(percent * 100).toInt()}%",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDAB7FD),
                    ),
                  ),
                  const Text(
                    "Today's Goal",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 📊 1.2 Mini Card Info
  Widget _buildStatMiniCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  // 🕒 1.3 Live App Usage Tracker Card
  Widget _buildAppUsageCard(Duration duration) {
    String format(Duration d) {
      String h = d.inHours.toString().padLeft(2, '0');
      String m = (d.inMinutes % 60).toString().padLeft(2, '0');
      String s = (d.inSeconds % 60).toString().padLeft(2, '0');
      return "$h:$m:$s";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE4D4F4), Color(0xFFFFD6E8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "App Usage Today",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Live tracking since app opened",
                style: TextStyle(color: Color(0xB3FFFFFF), fontSize: 10),
              ),
            ],
          ),
          Text(
            format(duration),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
