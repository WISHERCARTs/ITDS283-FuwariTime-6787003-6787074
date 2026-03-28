import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment(-1, -1),
          end: Alignment(-1, 1),
          colors: [
            Color(0xFFFFD6E8),
            Color(0xFFE4D4F4),
          ],
        ),
      ),
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16), // So it isn't flush against the walls
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Logo
          Row(
            children: [
              SizedBox(
                width: 39,
                height: 40,
                child: Image.network("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/ic82vq0p_expires_30_days.png", fit: BoxFit.fill)
              ),
              const SizedBox(width: 8),
              const Text(
                "Fuwari \nTime",
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
            ],
          ),
          
          // Center: Coins
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9999),
              color: const Color(0x4DFFFFFF),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 24,
                  child: Image.network("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/yaixbdgp_expires_30_days.png", fit: BoxFit.fill)
                ),
                const SizedBox(width: 8),
                const Text(
                  "1,250",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Right: Settings
          SizedBox(
            width: 40,
            height: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/90ztxge0_expires_30_days.png", fit: BoxFit.fill)
            )
          ),
        ],
      ),
    );
  }
}
