import 'package:flutter/material.dart';
import 'package:fuwari_time/features/home/screens/home_screen.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0), // สีพื้นหลัง
      // ลบ SafeArea ชั้นนอกสุดออก เพื่อให้กล่องสีทะลุขอบบนสุดได้
      body: Column(
        children: [
          // 1. กล่อง Gradient ด้านบน (อยู่แยกออกมา ไม่โดน Padding บีบ)
          Container(
            height: 140, // เพิ่มความสูงเผื่อพื้นที่ Status Bar ด้านบนมือถือ
            width: double.infinity,
            decoration: const BoxDecoration(
              // ปรับให้ขอบมนแค่ 'ด้านล่าง' ด้านบนจะได้ตัดตรงติดขอบจอ
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 15,
                  offset: Offset(0, 10),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFD6E8), Color(0xFFE4D4F4)],
              ),
            ),
          ),

          // 2. ส่วนเนื้อหาข้อความ (ใช้ Expanded เพื่อให้ใช้พื้นที่จอที่เหลือทั้งหมด)
          Expanded(
            child: SafeArea(
              top: false, // ปิดการเว้นระยะขอบบน เพราะเรามี Navbar แล้ว
              child: SingleChildScrollView(
                // เว้นระยะขอบซ้ายขวาล่างให้ส่วนข้อความ
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF090909),
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "TO",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF090909),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Fuwari Time",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF090909),
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 3. ข้อความรายละเอียด
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        "Fuwari Time is your intuitive productivity companion, blending minimalist Pomodoro timers with relaxing Lofi soundscapes to create a distraction-free sanctuary for deep work.\n\n"
                        "Created by Krittatee Kerdklinhom and Wish Nakthong, this project was born from a desire to make productivity feel more like a retreat than a chore. Our mission is to support your daily goals while maintaining your mental well-being.\n\n"
                        "We are committed to constant improvement and appreciate your patience as we work to perfect the experience. Let’s make every minute count, together.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF4B5563),
                          fontSize: 14, // ปรับเล็กลงนิดนึงเพื่อให้ดูคลีน
                          height: 1.5,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    // 4. ปุ่ม GOTCHA
                    ElevatedButton(
                      onPressed: () {
                        print('Pressed');
                        // สั่งเปลี่ยนหน้าแบบทับหน้าเดิมไปเลย (กด Back กลับมาไม่ได้)
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HomeScreen(), // 💡 เปลี่ยนชื่อคลาสให้ตรงกับหน้าของคุณ
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFECD4F0,
                        ), // สีพื้นหลังปุ่ม
                        foregroundColor:
                            Colors.black, // สีข้อความและเอฟเฟกต์ตอนกด/Hover
                        elevation:
                            0, // ตั้งค่าเงาเป็น 0 เพื่อให้ปุ่มแบนเรียบตามดีไซน์เดิม
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // ขอบมน
                        ),
                      ),
                      child: const Text(
                        "GOTCHA",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}