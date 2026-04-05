import 'package:flutter/material.dart';
import 'package:fuwari_time/features/music/music_state.dart'; 

/// หน้า Shop & Inventory (หน้าขวาสุด)
class ShopInventoryPage extends StatefulWidget {
  const ShopInventoryPage({super.key});

  @override
  State<ShopInventoryPage> createState() => _ShopInventoryPageState();
}

class _ShopInventoryPageState extends State<ShopInventoryPage> {
  // 🚀 ตัวควบคุมการเลื่อนขึ้นลง
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Map<String, String>>>(
      valueListenable: globalMusicList,
      builder: (context, musicList, _) {
        
        // 💡 บังคับให้มีขั้นต่ำ 12 ช่อง (4 แถว) เพื่อให้มันล้นตู้และไถเลื่อนได้เสมอ
        int totalSlots = musicList.length;
        if (totalSlots < 12) {
          totalSlots = 12; 
        } else if (totalSlots % 3 != 0) {
          totalSlots = totalSlots + (3 - (totalSlots % 3)); 
        }

        return Scaffold(
          backgroundColor: Colors.transparent, 
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 200),

                const Text(
                  "My Inventory",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),

                // 🚀 2. ตู้เพลงแบบรวมเป็นก้อนเดียว (ซ่อนแถบเลื่อนไว้ข้างใน)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 260, // 💡 ความกว้างของตู้
                        height: 245, // 💡 ความสูงของตู้
                        decoration: BoxDecoration(
                          color: const Color(0xFFDEB887), // สีพื้นตู้
                          borderRadius: BorderRadius.circular(12), // โค้งทั้ง 4 มุม
                          border: Border.all(color: const Color(0xFFC89F65), width: 4), // กรอบสีน้ำตาล
                          boxShadow: const [
                            BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 5)),
                          ],
                        ),
                        
                        // 🚀 RawScrollbar จะลอยอยู่บนสุดของกล่อง
                        child: RawScrollbar(
                          controller: _scrollController,
                          thumbVisibility: true, 
                          interactive: true, 
                          thickness: 6, // ความหนาของแถบเลื่อน
                          radius: const Radius.circular(8),
                          thumbColor: const Color(0xFF8B4513), // 💡 สีเทาเข้ม/ดำ เหมือนในรูป
                          crossAxisMargin: 4, // 💡 ดันให้ห่างจากขอบขวาเล็กน้อย
                          mainAxisMargin: 12, // ดันให้ห่างจากขอบบน/ล่าง
                          
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: GridView.builder(
                              controller: _scrollController, 
                              // 💡 สำคัญ: เว้น Padding ด้านขวา (20) ให้เยอะหน่อย เพื่อไม่ให้ไอเทมโดนแถบเลื่อนบัง
                              padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 20), 
                              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()), 
                              itemCount: totalSlots, 
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 6, 
                                mainAxisSpacing: 6,  
                                childAspectRatio: 1.0,
                              ),
                              itemBuilder: (context, index) {
                                bool hasItem = index < musicList.length;

                                if (!hasItem) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFDF5E6).withOpacity(0.6), 
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  );
                                }

                                final music = musicList[index];

                                return AnimatedBuilder(
                                  animation: Listenable.merge([
                                    musicController.currentIndex,
                                    musicController.isPlaying,
                                  ]),
                                  builder: (context, child) {
                                    bool isActive = musicController.currentIndex.value == index;
                                    bool isPlayingNow = isActive && musicController.isPlaying.value;

                                    return GestureDetector(
                                      onTap: () {
                                        musicController.playSong(index);
                                        isMusicBarVisible.value = true;
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: music['img']!.startsWith('http') 
                                                ? NetworkImage(music['img']!) as ImageProvider
                                                : AssetImage(music['img']!),
                                            fit: BoxFit.cover,
                                          ),
                                          border: isActive 
                                            ? Border.all(color: const Color(0xFFD8B4FE), width: 3.5) 
                                            : null,
                                        ),
                                        child: isActive
                                          ? Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.3), 
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  isPlayingNow ? Icons.equalizer_rounded : Icons.play_circle_fill_rounded,
                                                  color: Colors.white,
                                                  size: 28,
                                                ),
                                              ),
                                            )
                                          : null, 
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}