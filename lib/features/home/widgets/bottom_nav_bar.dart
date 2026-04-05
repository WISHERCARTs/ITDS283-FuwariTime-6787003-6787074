import 'package:flutter/material.dart';
import 'package:fuwari_time/features/music/music_state.dart';
// 🚀 1. อย่าลืม Import หน้า MusicBar เข้ามาด้วยนะครับ
import 'package:fuwari_time/features/music/music_bar.dart';

import 'package:fuwari_time/features/home/screens/home_screen.dart';
import 'package:fuwari_time/features/profile/profile.dart';
import 'package:fuwari_time/features/shop/shop.dart';
import 'package:fuwari_time/features/stats/stat.dart';

class BottomNavBar extends StatelessWidget {
  // ตัวแปรรับค่าว่าหน้าปัจจุบันคือหน้าไหน (0=Home, 1=Stats, 2=Shop, 3=Profile)
  final int currentIndex;

  const BottomNavBar({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    // ดึงค่าระยะห่างด้านล่างของหน้าจอมือถือแต่ละรุ่น (เช่น ขีด Home ของ iPhone/Android)
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // 🚀 2. ครอบด้วย Column แบบ min size เพื่อให้แถบเพลงซ้อนอยู่บนเมนู
    return Column(
      mainAxisSize:
          MainAxisSize.min, // 💡 สำคัญมาก: ห้ามเอาออก ไม่งั้นมันจะดันจนทะลุจอ
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 🎵 3. ส่วนของ Music Bar (จะโชว์ก็ต่อเมื่อ isMusicBarVisible เป็น true)
        ValueListenableBuilder<bool>(
          valueListenable: isMusicBarVisible,
          builder: (context, isVisible, child) {
            // ถ้าไม่ได้เปิดเพลง ให้ซ่อนแถบไปเลย (คืนค่าเป็นกล่องว่างๆ)
            if (!isVisible) return const SizedBox.shrink();

            // ถ้าเปิดเพลงอยู่ ให้แสดงแถบ MusicBar
            return const LofiMusicBar();
          },
        ),

        // 🔽 ส่วนของ Bottom Navigation Bar ด้านล่าง (ของเดิมของคุณ)
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF), // สีขาวสะอาด
            // เพิ่มเงาให้ดูมีมิติมากขึ้น
            boxShadow: [
              BoxShadow(
                color: Color(0x0D000000), // ดำเจือจางมาก (5%)
                blurRadius: 20,
                offset: Offset(0, -5), // ดันเงาขึ้นด้านบนเล็กน้อย
              ),
            ],
          ),
          // Padding ด้านล่างจะบวกเพิ่มตามความเหมาะสมของโทรศัพท์เครื่องนั้นๆ
          padding: EdgeInsets.only(
            top: 14,
            bottom: bottomPadding > 0 ? bottomPadding : 14,
          ),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(context, Icons.home_rounded, "Home", 0),
              _buildNavItem(context, Icons.bar_chart_rounded, "Stats", 1),
              _buildNavItem(context, Icons.storefront_rounded, "Shop", 2),
              _buildNavItem(context, Icons.person_rounded, "Profile", 3),
            ],
          ),
        ),
      ],
    );
  }

  // ฟังก์ชันสร้างปุ่มเมนูแต่ละอัน
  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    // เช็คว่าปุ่มนี้คือหน้าปัจจุบันที่เราอยู่หรือไม่
    bool isActive = currentIndex == index;

    return InkWell(
      onTap: () {
        if (!isActive) {
          // 🚀 ระบบ Routing เปลี่ยนหน้า
          Widget nextScreen;

          switch (index) {
            case 0:
              nextScreen = const HomeScreen();
              break;
            case 1:
              nextScreen = const Stat();
              break;
            case 2:
              nextScreen = const Shop();
              break;
            case 3:
              nextScreen = const Profile();
              break;
            default:
              return;
          }

          // 🚀 คำสั่งเปลี่ยนหน้าแบบไม่วางซ้อนกัน และปิดแอนิเมชันให้เนียนตา
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => nextScreen,
              transitionDuration: Duration.zero, // ปิดเวลาแอนิเมชัน
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 💡 ส่วนกล่องไอคอน
          Container(
            width: 48,
            height: 48,
            decoration: isActive
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFD6E8), Color(0xFFFFB5C5)],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  )
                : null,
            child: Icon(
              icon,
              size: 28,
              color: isActive ? Colors.white : const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 4),
          // 💡 ส่วนข้อความ
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? const Color(0xFFC8B8E6)
                  : const Color(0xFF9CA3AF),
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
