import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 50,
            offset: Offset(0, 25),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/s0fn0hlf_expires_30_days.png", "Home", const Color(0xFFC8B8E6)),
          _buildNavItem("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/qmf16e1u_expires_30_days.png", "Stats", const Color(0xFF9CA3AF)),
          _buildNavItem("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/uekapo5z_expires_30_days.png", "Shop", const Color(0xFF9CA3AF)),
          _buildNavItem("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/jwej7qx2_expires_30_days.png", "Profile", const Color(0xFF9CA3AF)),
        ],
      ),
    );
  }

  Widget _buildNavItem(String imageUrl, String label, Color textColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: Image.network(imageUrl, fit: BoxFit.fill),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
