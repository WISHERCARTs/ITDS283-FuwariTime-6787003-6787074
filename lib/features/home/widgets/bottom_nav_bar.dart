import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  // ตัวแปรรับค่าว่าหน้าปัจจุบันคือหน้าไหน (0=Home, 1=Stats, 2=Shop, 3=Profile)
  final int currentIndex;

  const BottomNavBar({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    // ดึงค่าระยห่างด้านล่างของหน้าจอมือถือแต่ละรุ่น (เช่น ขีด Home ของ iPhone/Android)
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
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
          // TODO: ใส่คำสั่ง Navigator เพื่อเปลี่ยนหน้าตรงนี้
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
                ? BoxDecoration(
                    // ถ้า Active ให้วาดกล่องสีชมพู Gradient
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
