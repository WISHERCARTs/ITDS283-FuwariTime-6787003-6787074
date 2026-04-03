import 'package:flutter/material.dart';

/// หน้า Shop & Inventory (หน้าขวาสุด)
/// แสดงประวัติและไอเทมของตัวละครที่ได้จากการ Focus
class ShopInventoryPage extends StatelessWidget {
  const ShopInventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // โปร่งใสเพื่อโชว์วิดีโอพื้นหลัง
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Push past the Global Top Bar
            const SizedBox(height: 100),

            // Inner Item Display Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/3xnnri8u_expires_30_days.png",
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Column(
                  children: [
                    // Badges Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBadge(
                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/vmqes3k7_expires_30_days.png",
                          "7 days",
                        ),
                        _buildBadge(
                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/a6fwtz5b_expires_30_days.png",
                          "Level 12",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String iconUrl, String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9999),
        color: const Color(0xCCFFFFFF),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 13, // Standardized icon fit
            height: 16,
            child: Image.network(iconUrl, fit: BoxFit.contain),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
