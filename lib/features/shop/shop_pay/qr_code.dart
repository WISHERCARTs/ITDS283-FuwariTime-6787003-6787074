import 'package:flutter/material.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';

class ShopPayment extends StatefulWidget {
  const ShopPayment({super.key});

  @override
  ShopPaymentState createState() => ShopPaymentState();
}

class ShopPaymentState extends State<ShopPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      // 💡 ใช้ BottomNavBar เหมือนเดิม (ไฮไลท์ที่ Shop)
      bottomNavigationBar: const BottomNavBar(currentIndex: 2), 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // จัดให้อยู่กึ่งกลาง
            children: [
              // 💡 1. เรียกใช้ TopBar
              const TopBar(),
              
              const SizedBox(height: 40),
              
              // 💡 2. หัวข้อ "QR payment"
              const Text(
                "QR payment",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32, // ปรับขนาดให้พอดีจอสวยๆ
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // 💡 3. กล่องแสดงรูป QR Code
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 15,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/xwip3n0d_expires_30_days.png",
                    width: 280, // ปรับขนาดให้สมดุลกับหน้าจอ
                    height: 280,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              const SizedBox(height: 50),
              
              // 💡 4. ปุ่ม Cancel สีแดง (กดแล้วย้อนกลับ)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Align(
                  alignment: Alignment.centerRight, // จัดให้อยู่ขวาๆ ตามดีไซน์เดิมของคุณ
                  child: InkWell(
                    onTap: () {
                      // 💡 คำสั่งย้อนกลับไปหน้าก่อนหน้า
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFFF51010), // สีแดง
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
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