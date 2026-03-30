import 'package:flutter/material.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  // 💡 1. เปลี่ยนตัวแปรมาเก็บ "ระดับเสียง" (ค่าตั้งแต่ 0.0 ถึง 1.0)
  // ค่าเริ่มต้น 0.5 คือ 50%
  double soundVolume = 0.5; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3), 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopBar(),
              
              const SizedBox(height: 30),
              
              const Center(
                child: Text(
                  "Setting",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // 💡 2. เมนูตั้งค่าระดับเสียง (ปรับเป็น Slider)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24), // ปรับ padding นิดหน่อยให้ Slider มีพื้นที่
                child: Row(
                  children: [
                    // ไอคอนลำโพง
                    Image.network(
                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/c7j0cbib_expires_30_days.png",
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Sound",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    
                    // 💡 ใช้ Expanded เพื่อให้หลอด Slider ยืดเต็มพื้นที่ที่เหลือ
                    Expanded(
                      child: Slider(
                        value: soundVolume,
                        min: 0.0,
                        max: 1.0,
                        activeColor: const Color(0xFFDAB7FD), // สีม่วงอ่อน (ธีมแอป)
                        inactiveColor: Colors.grey.shade300,  // สีตอนที่ยังไม่เลื่อนไป
                        onChanged: (value) {
                          setState(() {
                            soundVolume = value;
                          });
                          // TODO: เอาค่า soundVolume ไปปรับระดับเสียงแพ็กเกจเล่นเพลงตรงนี้
                          print("ระดับเสียงตอนนี้: ${(soundVolume * 100).toInt()}%");
                        },
                      ),
                    ),
                    
                    // 💡 (แถม) โชว์ตัวเลข % ไว้ด้านหลังให้ดูง่ายขึ้น
                    SizedBox(
                      width: 40,
                      child: Text(
                        "${(soundVolume * 100).toInt()}%",
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6B7280)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // 💡 เมนู About Us
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: InkWell(
                  onTap: () {
                    // TODO: ใส่ Action เปิดหน้าโชว์รายละเอียดแอป หรือโชว์ Dialog
                    print("กด About Us");
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12), // เพิ่มพื้นที่ให้กดง่ายขึ้น
                    child: Row(
                      children: [
                        // ไอคอนตัว i (Info)
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 30,
                          color: Color(0xFF1F2937), // สีเทาเข้ม
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          "About Us",
                          style: TextStyle(
                            color: Color(0xFF1F2937),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
              
               // ระยะห่างก่อนถึงปุ่ม Log out

              const SizedBox(height: 30),
              
              // 💡 ปุ่ม Log out
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: InkWell(
                  onTap: () {
                    print("กด Log out");
                    // ตัวอย่าง: Navigator.pushReplacement(context, ...);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/bo4l4cgu_expires_30_days.png",
                          width: 30,
                          height: 30,
                          color: Colors.redAccent, 
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          "Log out",
                          style: TextStyle(
                            color: Colors.redAccent, 
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 100), 
            ],
          ),
        ),
      ),
    );
  }
}