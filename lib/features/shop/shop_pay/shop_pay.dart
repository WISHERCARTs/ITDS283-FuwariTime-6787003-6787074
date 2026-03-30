import 'package:flutter/material.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';
// 💡 1. อย่าลืม Import หน้า ShopPayment เข้ามาด้วยนะครับ (เช็ค Path ให้ตรงกับของคุณ)
import 'package:fuwari_time/features/shop/shop_pay/qr_code.dart'; 

class ShopPay extends StatefulWidget {
  final String itemName;
  final int itemPrice;
  final String imageUrl;

  const ShopPay({
    super.key,
    required this.itemName,
    required this.itemPrice,
    required this.imageUrl,
  });

  @override
  ShopPayState createState() => ShopPayState();
}

class ShopPayState extends State<ShopPay> {

  // 💡 2. ฟังก์ชันกดปุ่ม Buy (เปลี่ยนให้เด้งไปหน้า QR Code)
  void _goToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ShopPayment(), // 👈 สั่งเปลี่ยนไปหน้า ShopPayment
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2), 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopBar(),
              
              const SizedBox(height: 24),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
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
                            child: const Icon(
                              Icons.arrow_back_rounded, 
                              color: Color(0xFF1F2937), 
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          "Shop",
                          style: TextStyle(color: Color(0xFF1F2937), fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x1A000000), blurRadius: 6, offset: Offset(0, 4)),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              widget.imageUrl,
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            widget.itemName,
                            style: const TextStyle(color: Color(0xFF1F2937), fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Music",
                                style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEF9C3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.network("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/51tkk9j2_expires_30_days.png", width: 14),
                                        const SizedBox(width: 6),
                                        Text(
                                          "${widget.itemPrice}",
                                          style: const TextStyle(color: Color(0xFFA16207), fontWeight: FontWeight.bold)
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton(
                                    onPressed: _goToPayment, // 💡 3. เรียกใช้ฟังก์ชันเด้งไปหน้า QR ตรงนี้
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00FF7B),
                                      foregroundColor: Colors.black,
                                      shape: const StadiumBorder(),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 32),
                                    ),
                                    child: const Text("Buy", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}