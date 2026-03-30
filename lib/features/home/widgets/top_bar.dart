import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  // 💡 แก้ไขตรงนี้: เปลี่ยนจาก _buildHeader() เป็น build(BuildContext context)
  Widget build(BuildContext context) { 
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 30, left: 24, right: 24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFD6E8), Color(0xFFE4D4F4)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network(
                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/junj4an5_expires_30_days.png",
                width: 39,
                height: 40,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 12),
              const Text(
                "Fuwari Time",
                style: TextStyle(color: Colors.white, fontSize: 20, height: 1.2, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0x4DFFFFFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Image.network(
                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/hevi4h27_expires_30_days.png",
                  width: 16,
                  height: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  "1,250",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          // รูปโปรไฟล์เล็กมุมขวา
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/959ud1zb_expires_30_days.png",
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}