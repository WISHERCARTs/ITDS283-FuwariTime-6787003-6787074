import 'package:flutter/material.dart';

/// แถบ Music Player (แสดงผลด้านล่างของจอ เหนือ Navigation Bar)
/// ออกแบบ UI เลียนแบบ YouTube Music Mini-Player สไตล์ Dark Theme เพื่อความทันสมัย
class BottomMusicPlayer extends StatelessWidget {
  const BottomMusicPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64, // Exact mini-player standard height
      decoration: const BoxDecoration(
        color: Color(0xFF212121), // YT Music premium dark theme
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              children: [
                // Album Art
                Container(
                  width: 44,
                  height: 44,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: const DecorationImage(
                      image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/5f9gjw3c_expires_30_days.png"), // Using Logo as Album Art placeholder
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // Track Info
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Lofi Study Beats",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Fuwari Time ✨",
                        style: TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                // YT Music Controls
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: const Icon(Icons.cast, color: Colors.white, size: 24),
                    onPressed: () {},
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          
          // Bottom Progress Bar
          const LinearProgressIndicator(
            value: 0.35, 
            backgroundColor: Color(0xFF424242), // Dark line background
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD8B4FE)), // Fuwari purple for progress highlight
            minHeight: 2, // Thin sleek line at the very bottom
          ),
        ],
      ),
    );
  }
}
