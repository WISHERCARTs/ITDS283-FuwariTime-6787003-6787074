import 'package:flutter/material.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';
import 'package:fuwari_time/features/setting/about_us.dart';

class Setting extends StatefulWidget {
  // 🚀 1. เพิ่มตัวแปรรับค่า index ของหน้าที่กดเข้ามา (ค่าเริ่มต้นให้เป็น 0 คือหน้า Home)
  final int currentIndex;

  const Setting({super.key, this.currentIndex = 0});

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  double soundVolume = 0.5; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      // 🚀 2. โยนค่า widget.currentIndex ไปให้ BottomNavBar ใช้
      bottomNavigationBar: BottomNavBar(currentIndex: widget.currentIndex), 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopBar(),
              
              const SizedBox(height: 20), // 💡 ปรับระยะห่างนิดหน่อยให้พอดีกับปุ่ม
              
              // 🚀 3. ใช้ Stack จัดปุ่ม Back ไว้ซ้าย และข้อความไว้ตรงกลาง
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded, 
                          color: Color(0xFF1F2937),
                          size: 24,
                        ),
                        onPressed: () {
                          // 🚀 คำสั่งสำหรับกดย้อนกลับไปหน้าก่อนหน้า
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  const Text(
                    "Setting",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
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
                    
                    Expanded(
                      child: Slider(
                        value: soundVolume,
                        min: 0.0,
                        max: 1.0,
                        activeColor: const Color(0xFFDAB7FD), 
                        inactiveColor: Colors.grey.shade300,  
                        onChanged: (value) {
                          setState(() {
                            soundVolume = value;
                          });
                          print("ระดับเสียงตอนนี้: ${(soundVolume * 100).toInt()}%");
                        },
                      ),
                    ),
                    
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUs()),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 30,
                          color: Color(0xFF1F2937),
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
              
              const SizedBox(height: 30),
              
              // 💡 ปุ่ม Log out
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: InkWell(
                  onTap: () {
                    print("กด Log out");
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