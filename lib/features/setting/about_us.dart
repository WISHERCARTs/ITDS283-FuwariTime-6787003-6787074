import 'package:flutter/material.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:url_launcher/url_launcher.dart'; 

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  Future<void> _launchInstagram(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("ไม่สามารถเปิดลิงก์ได้: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBar(),
              
              const SizedBox(height: 24), 
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 2)),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1F2937), size: 20),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "About Us",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // 💡 รูปที่ 1 (วงกลมและอยู่ตรงกลาง)
              Center(
                child: ClipOval(
                  child: Image.asset(
                    "lib/features/setting/assets/wishercarts.jpg", 
                    width: 160, // กำหนดขนาดกว้างยาวให้เท่ากัน
                    height: 160,
                    fit: BoxFit.cover, // ให้รูปเต็มวงกลมพอดี ไม่บีบไม่ยืด
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 💡 ชื่อคนที่ 1 (อยู่ตรงกลาง)
              const Center(
                child: Text(
                  "Wish Nakthong",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold, // เพิ่มความหนาให้ชื่อดูเด่นขึ้น
                    color: Colors.black,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 💡 ปุ่ม IG Wishercarts
              _buildContactLink(
                iconUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Instagram_icon.png/600px-Instagram_icon.png",
                title: "Wish Nakthong",
                subtitle: "@wishercarts",
                onTap: () {
                  _launchInstagram("https://www.instagram.com/wishercarts/");
                },
              ),

              _buildContactLink(
                iconUrl: "https://cdn-icons-png.flaticon.com/512/1384/1384060.png", 
                title: "WISHERCARTs",
                subtitle: "@wishercarts",
                onTap: () {
                _launchInstagram("https://www.youtube.com/@wishercarts"); // เปลี่ยนลิงก์เป็น YouTube ของคุณ
                },
            ),

              const SizedBox(height: 40),
              
              // 💡 รูปที่ 2 (วงกลมและอยู่ตรงกลาง)
              Center(
                child: ClipOval(
                  child: Image.asset(
                    "lib/features/setting/assets/me.png", 
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover, 
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 💡 ชื่อคนที่ 2 (อยู่ตรงกลาง)
              const Center(
                child: Text(
                  "Krittatee Kerdklinhom",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              
              // 💡 ปุ่ม IG Omyomami
              _buildContactLink(
                iconUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Instagram_icon.png/600px-Instagram_icon.png", 
                title: "omy_Krittatteeeee",
                subtitle: "@omyomamii",
                onTap: () {
                  _launchInstagram("https://www.instagram.com/omyomamii/");
                },
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // ฟังก์ชันย่อยสำหรับปุ่ม IG
  // ==========================================
  Widget _buildContactLink({
    required String iconUrl,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8), // เพิ่ม Padding ซ้ายขวาให้ปุ่มดูสมดุลกับวงกลม
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000), 
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3E8FF), 
                  shape: BoxShape.circle,
                ),
                child: Image.network(iconUrl, fit: BoxFit.cover),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1F2937)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.open_in_new_rounded, color: Color(0xFF9CA3AF), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}