import 'package:flutter/material.dart';
// 💡 อย่าลืมเช็ค Path การ Import ให้ตรงกับโฟลเดอร์ในโปรเจกต์ของคุณนะครับ
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';

class Stat extends StatefulWidget {
  const Stat({super.key});
  @override
  StatState createState() => StatState();
}

class StatState extends State<Stat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      // 💡 เรียกใช้ BottomNavBar และส่งค่า 1 เพื่อไฮไลท์ปุ่ม Stats
      bottomNavigationBar: const BottomNavBar(currentIndex: 1), 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 💡 เรียกใช้ TopBar ที่เราแยกไฟล์ไว้
              const TopBar(),
              
              const SizedBox(height: 30),
              
              // กล่องแสดงสถิติ (Stats Card)
              _buildStatsCard(),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // ส่วนสร้างกล่องสถิติ (Stats Card)
  // ==========================================
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
            "Stats",
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // 💡 แถบที่ 1: App Usage Time
          _buildStatRow(
            dotColor: const Color(0xFF3B82F6), // สีน้ำเงิน
            label: "App Usage Time",
            time: "15.2h",
            percent: 0.6, // ความยาวหลอด (0.0 - 1.0)
          ),
          
          const SizedBox(height: 20),
          
          // 💡 แถบที่ 2: Pomodoro Time
          _buildStatRow(
            dotColor: const Color(0xFF22C55E), // สีเขียว
            label: "Pomodo Time",
            time: "10.8h",
            percent: 0.4, // ความยาวหลอด (0.0 - 1.0)
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ฟังก์ชันย่อยสำหรับวาด "แต่ละแถว" ของสถิติ
  // ==========================================
  Widget _buildStatRow({
    required Color dotColor,
    required String label,
    required String time,
    required double percent, // รับค่า % ของความยาวหลอดสี
  }) {
    return Row(
      children: [
        // 1. จุดสี
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        
        // 2. ข้อความ Label
        SizedBox(
          width: 110, // ล็อกความกว้างไว้ให้ข้อความตรงกัน
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF374151), fontSize: 13),
          ),
        ),
        
        // 3. หลอดกราฟ (ใช้ Expanded เพื่อให้ยืดเต็มพื้นที่ที่เหลือ)
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB), // สีพื้นหลังหลอด (สีเทา)
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: percent, // กำหนดความยาวของแถบสีตามค่า percent
              child: Container(
                decoration: BoxDecoration(
                  color: dotColor, // สีหลอดกราฟ
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // 4. ข้อความเวลา
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