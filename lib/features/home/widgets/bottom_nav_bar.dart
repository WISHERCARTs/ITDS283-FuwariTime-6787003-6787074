import 'package:flutter/material.dart';
import 'package:fuwari_time/features/home/screens/home_screen.dart';
import 'package:fuwari_time/features/shop/shop.dart';
// import 'package:fuwari_time/features/profile/profile.dart'; // ยังไม่มีใน branch นี้

class BottomNavBar extends StatelessWidget {
  // ตัวแปรรับค่าว่าหน้าปัจจุบันคือหน้าไหน (0=Home, 1=Stats, 2=Shop, 3=Profile)
  final int currentIndex;

  const BottomNavBar({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 50,
            offset: Offset(0, 25),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
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
    );
  }

  // ฟังก์ชันสร้างปุ่มเมนูแต่ละอัน
  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    // เช็คว่าปุ่มนี้คือหน้าปัจจุบันที่เราอยู่หรือไม่
    bool isActive = currentIndex == index; 

    return InkWell(
      onTap: () {
        if (!isActive) {
          // จัดการเปลี่ยนหน้าไปที่ต่างๆ ตาม Index
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => const HomeScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 2) { // 2 = Shop
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => const Shop(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 3) { // 3 = Profile
            // Navigator.pushReplacement(
            //   context,
            //   PageRouteBuilder(
            //     pageBuilder: (context, animation1, animation2) => const Profile(),
            //     transitionDuration: Duration.zero,
            //     reverseTransitionDuration: Duration.zero,
            //   ),
            // );
          }
          print('เปลี่ยนไปหน้า $label');
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
                ? BoxDecoration( // ถ้า Active ให้วาดกล่องสีชมพู Gradient
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFD6E8), Color(0xFFFFB5C5)],
                    ),
                    boxShadow: const [
                      BoxShadow(color: Color(0x1A000000), blurRadius: 6, offset: Offset(0, 4)),
                    ],
                  )
                : null, // ถ้าไม่ Active ก็ไม่ต้องมีกล่องพื้นหลัง
            child: Icon(
              icon,
              size: 28,
              // ถ้า Active ให้ไอคอนสีขาว ถ้าไม่ให้เป็นสีเทา
              color: isActive ? Colors.white : const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 4),
          // 💡 ส่วนข้อความ
          Text(
            label,
            style: TextStyle(
              // ข้อความสีม่วงเมื่อ Active สีเทาเมื่อไม่ Active
              color: isActive ? const Color(0xFFC8B8E6) : const Color(0xFF9CA3AF),
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}