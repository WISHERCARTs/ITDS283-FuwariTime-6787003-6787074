import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fuwari_time/features/home/services/background_controller.dart';
// 💡 อย่าลืม Import หน้า Setting เข้ามานะครับ
import 'package:fuwari_time/features/setting/setting.dart';

class TopBar extends StatefulWidget {
  final int currentIndex;
  const TopBar({super.key, this.currentIndex = 0});

  @override
  TopBarState createState() => TopBarState();
}

class TopBarState extends State<TopBar> {
  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;
  late Stream<List<Map<String, dynamic>>> _pointsStream;

  @override
  void initState() {
    super.initState();
    // 🚀 ย้ายการสร้าง Stream มาไว้ที่นี่ เพื่อไม่ให้สร้างใหม่ทุกครั้งที่ Build (ป้องกัน ANR)
    if (_currentUserId != null) {
      _pointsStream = Supabase.instance.client
          .from('profiles')
          .stream(primaryKey: ['id'])
          .eq('id', _currentUserId!);
    } else {
      _pointsStream = const Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ดึงค่าระยะห่างจากขอบจอด้านบน (ติ่งหน้าจอ หรือ แถบสถานะ)
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      // ตัวพื้นหลังจะรวมระยะ Top Padding เข้าไปด้วยเพื่อให้สีมันคลุมไปถึงขอบบนสุด
      padding: EdgeInsets.only(
        top: topPadding > 0 ? topPadding : 10,
        bottom: 20,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        // ปรับขอบล่างให้โค้งมนดูนุ่มนวล
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000), // เงาสีดำจางๆ
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
        // ไล่สีจากมุมบนซ้ายไปล่างขวา
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFD6E8), // ชมพูพาสเทล
            Color(0xFFE4D4F4), // ม่วงพาสเทล
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🚀 1. ฝั่งซ้าย (Icon + Title + Location) - หุ้มด้วย Expanded เพื่อให้มีขอบเขตแน่นอน
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🚀 เปลี่ยนเป็นใช้ Asset ของแอปจริงๆ
                Image.asset(
                  "assets/image/app_icon.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 12),
                // 🚀 2. ใช้ Flexible ตรงนี้เพื่อป้องกันข้อความล้น (ยังอยู่ในขอบเขตของ Expanded)
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Fuwari Time",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // 🗺️📍 แสดงชื่อสถานที่ (อำเภอ จังหวัด ประเทศ) จาก GPS
                      GestureDetector(
                        onTap: () => context
                            .read<BackgroundController>()
                            .syncLocationAndWeather(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 10,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4),
                            // 🚀 3. ใช้ Flexible ชั้นเดียวพอ เพื่อคุมข้อความที่อยู่ (Address)
                            Flexible(
                              child: Text(
                                context
                                    .watch<BackgroundController>()
                                    .currentAddress,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 9,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12), // เว้นที่ให้กดง่ายขึ้นแยกจาก Coins
          // 💰 [ส่วนที่แก้] ใช้ Icon มาตรฐานเพื่อความถาวร
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _pointsStream,
            builder: (context, snapshot) {
              int points = 0;
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                points = snapshot.data!.first['points'] ?? 0;
              }

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x4DFFFFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.monetization_on_rounded,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      points.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 💡 วาง Material ครอบไว้เพื่อให้โชว์เอฟเฟกต์ Hover/Splash ได้
          Material(
            color: Colors.transparent, // ให้พื้นหลังใส จะได้เห็นไล่สีของ TopBar
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  // 🚀 3. แนบ currentIndex ส่งต่อไปให้หน้า Setting ด้วย!
                  MaterialPageRoute(
                    builder: (context) =>
                        Setting(currentIndex: widget.currentIndex),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(25),
              // 💡 ตั้งค่าสีตอนเอาเมาส์ชี้ (Hover) หรือตอนกด (Splash) ให้เป็นสีขาวจางๆ
              hoverColor: Colors.white.withOpacity(0.3),
              splashColor: Colors.white.withOpacity(0.4),
              highlightColor: Colors.white.withOpacity(0.2),

              // 💡 เปลี่ยนมาใช้ Icon โปรไฟล์มาตรฐานเพื่อความทนทาน
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
