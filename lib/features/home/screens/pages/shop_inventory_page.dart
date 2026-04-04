import 'package:flutter/material.dart';
// 🚀 1. Import ระบบเพลงส่วนกลางมาใช้
import 'package:fuwari_time/features/music/music_state.dart'; 

/// หน้า Shop & Inventory (หน้าขวาสุด)
class ShopInventoryPage extends StatefulWidget {
  const ShopInventoryPage({super.key});

  @override
  State<ShopInventoryPage> createState() => _ShopInventoryPageState();
}

class _ShopInventoryPageState extends State<ShopInventoryPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (globalMusicList.length / 9).ceil();
    if (totalPages == 0) totalPages = 1;

    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 200),

            // 🚀 หัวข้อตู้เพลง
            const Text(
              "My Inventory",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),

            // 🚀 ตู้หนังสือ 3x3
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start, // ให้ดันขึ้นไปชิดด้านบน
                  children: [
                    // ⬅️ ลูกศรซ้าย
                    Padding(
                      padding: const EdgeInsets.only(top: 100), // ดันลูกศรให้ลงมาอยู่ตรงกลางตู้พอดี (ครึ่งนึงของ 240 คือ 120 หักลบขนาดไอคอน)
                      child: Opacity(
                        opacity: _currentPage > 0 ? 1.0 : 0.0,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFFD8B4FE), size: 28),
                          onPressed: _currentPage > 0 ? () {
                            _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          } : null,
                        ),
                      ),
                    ),

                    // 📚 ตัวตู้หนังสือ (💡 ล็อกขนาดให้เล็กลงตรงนี้ครับ!)
                    SizedBox(
                      width: 240,  // 💡 ถ้าอยากให้เล็กกว่านี้อีก เปลี่ยนเป็น 220 หรือ 200 ได้เลยครับ
                      height: 240, // 💡 ตั้งให้เท่ากับ width เพื่อให้ตู้เป็น สี่เหลี่ยมจัตุรัสเป๊ะๆ
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFDEB887), 
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFC89F65), width: 4), 
                          boxShadow: const [
                            BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 5)),
                          ],
                        ),
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() { _currentPage = index; });
                          },
                          itemCount: totalPages,
                          itemBuilder: (context, pageIndex) {
                            return GridView.builder(
                              padding: const EdgeInsets.all(4), 
                              physics: const NeverScrollableScrollPhysics(), 
                              itemCount: 9, 
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4, 
                                mainAxisSpacing: 4,  
                                childAspectRatio: 1.0,
                              ),
                              itemBuilder: (context, slotIndex) {
                                int actualIndex = (pageIndex * 9) + slotIndex;
                                bool hasItem = actualIndex < globalMusicList.length;

                                if (!hasItem) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFDF5E6).withOpacity(0.6), 
                                      borderRadius: BorderRadius.circular(8), // 💡 ใส่โค้งให้ช่องว่างด้วย
                                    ),
                                  );
                                }

                                final music = globalMusicList[actualIndex];

                                return AnimatedBuilder(
                                  animation: Listenable.merge([
                                    musicController.currentIndex,
                                    musicController.isPlaying,
                                  ]),
                                  builder: (context, child) {
                                    bool isActive = musicController.currentIndex.value == actualIndex;
                                    bool isPlayingNow = isActive && musicController.isPlaying.value;

                                    return GestureDetector(
                                      onTap: () {
                                        musicController.playSong(actualIndex);
                                        isMusicBarVisible.value = true;
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8), // 🚀 1. เติมโค้งให้ขอบรูปภาพ
                                          image: DecorationImage(
                                            image: AssetImage(music['img']!),
                                            fit: BoxFit.cover,
                                          ),
                                          // ขอบสีม่วงตอน Active ก็จะโค้งตาม
                                          border: isActive 
                                            ? Border.all(color: const Color(0xFFD8B4FE), width: 3.5) 
                                            : null,
                                        ),
                                        child: isActive
                                          ? Container(
                                              // 🚀 2. เติมโค้งให้แถบสีดำตอนที่เพลงกำลังเล่น
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.3), 
                                                borderRadius: BorderRadius.circular(8), // ต้องโค้งเท่ากันกับรูปภาพ
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  isPlayingNow ? Icons.equalizer_rounded : Icons.play_circle_fill_rounded,
                                                  color: Colors.white,
                                                  size: 28, // 💡 ลดขนาดไอคอนตรงกลางลงนิดนึงให้สมส่วน
                                                ),
                                              ),
                                            )
                                          : null, 
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),

                    // ➡️ ลูกศรขวา
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Opacity(
                        opacity: _currentPage < totalPages - 1 ? 1.0 : 0.0,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFD8B4FE), size: 28),
                          onPressed: _currentPage < totalPages - 1 ? () {
                            _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          } : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}