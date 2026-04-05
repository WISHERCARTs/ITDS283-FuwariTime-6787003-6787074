import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';
import 'package:fuwari_time/services/profile_service.dart';
import 'package:fuwari_time/services/inventory_service.dart';
import 'package:fuwari_time/features/music/music_state.dart';
import 'package:fuwari_time/features/shop/shop_pay/qr_code.dart';

class ShopPay extends StatefulWidget {
  final String title;
  final String artist;
  final String img;
  final String path;
  final int price;

  const ShopPay({
    super.key,
    required this.title,
    required this.artist,
    required this.img,
    required this.path,
    required this.price,
  });

  @override
  State<ShopPay> createState() => ShopPayState();
}

class ShopPayState extends State<ShopPay> {
  final ProfileService _profileService = ProfileService();
  final InventoryService _inventoryService = InventoryService();
  bool _isProcessing = false;

  // 💡 ฟังก์ชันหลังกดปุ่ม Buy -> แสดงตัวเลือกการจ่ายเงิน
  void _showPaymentSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Payment Method",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
            ),
            const SizedBox(height: 24),
            
            // 💰 Option 1: Pay with Coins
            _buildPaymentOption(
              icon: Icons.monetization_on_rounded,
              title: "Pay with Coins",
              subtitle: "${widget.price} Coins", 
              color: const Color(0xFFFFD6E8),
              onTap: () {
                Navigator.pop(context);
                _handleCoinPayment();
              },
            ),
            
            const SizedBox(height: 16),
            
            // 💳 Option 2: Pay with PromptPay
            _buildPaymentOption(
              icon: Icons.qr_code_scanner_rounded,
              title: "PromptPay",
              subtitle: "Scan to pay (Real money)",
              color: const Color(0xFF00FF7B).withOpacity(0.2),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopPayment()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: const Color(0xFF1F2937)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // 🚀 ฟังก์ชันหลัก
  Future<void> _handleCoinPayment() async {
    setState(() => _isProcessing = true);

    try {
      // 💡 1. สร้างก้อนข้อมูลเพลงใหม่
      Map<String, String> purchasedSong = {
        "title": widget.title,
        "artist": widget.artist,
        "img": widget.img,
        "path": widget.path,
      };

      // 💡 2. ยัดเข้าคลัง Local ทันที! (เพื่อให้หน้า Shop ขึ้น Sold out ทันที แบบไม่ต้องรอเน็ต)
      musicController.buyNewSong(purchasedSong);

      // 💡 3. เช็คและหักเงินใน Database (Supabase) ถ้ามีการ Login ไว้
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        final profile = await _profileService.getProfile(userId);
        if (profile != null && profile.points >= widget.price) {
          await _profileService.addPoints(userId, -widget.price);
          // ส่ง "Music" ไปให้ Inventory Service
          await _inventoryService.purchaseItem(userId, widget.title, "Music");
        } else {
          _showStatusMessage("Not enough coins! Go focus more. 🔥", Colors.redAccent);
          setState(() => _isProcessing = false);
          return; // ถ้าเงินไม่พอ ให้หยุดการทำงาน
        }
      }

      _showStatusMessage("Successfully purchased ${widget.title}!", Colors.green);

      // 💡 4. หน่วงเวลา 1.5 วินาทีให้โชว์ข้อความสำเร็จ แล้วเด้งกลับหน้า Shop อัตโนมัติ
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        Navigator.pop(context);
      }

    } catch (e) {
      _showStatusMessage("Error processing payment.", Colors.redAccent);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // 💡 ปรับให้ข้อความอยู่ตรงกลาง และขอบมนสวยงาม
  void _showStatusMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center, // 💡 จัดข้อความให้อยู่ตรงกลาง
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // 💡 ขอบมน
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const TopBar(), 
                const SizedBox(height: 50),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                          child: widget.img.startsWith('http')
                              ? Image.network(
                                  widget.img,
                                  height: 300,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: const Color(0xFFF3F4F6),
                                      height: 300,
                                      child: const Center(
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFFD6E8)),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: const Color(0xFFF3F4F6),
                                    height: 300,
                                    child: const Center(child: Icon(Icons.image_not_supported_rounded, color: Colors.grey, size: 50)),
                                  ),
                                )
                              : Image.asset(
                                  widget.img, 
                                  height: 300,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: const Color(0xFFF3F4F6),
                                    height: 300,
                                    child: const Center(child: Icon(Icons.image_not_supported_rounded, color: Colors.grey, size: 50)),
                                  ),
                                ),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              const SizedBox(height: 8),
                              Text(
                                widget.title, 
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                              ),
                              if (widget.artist.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    widget.artist,
                                    style: const TextStyle(fontSize: 16, color: Color(0xFF9CA3AF), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(color: Color(0xFFFEF9C3), shape: BoxShape.circle),
                                    child: Image.network(
                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/siq2ut46_expires_30_days.png",
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "${widget.price} Coins", 
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFA16207)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: _isProcessing ? null : _showPaymentSelection,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF9A8D4),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    elevation: 0,
                                  ),
                                  child: _isProcessing
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text("Buy Now", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Positioned(
            top: 90,
            left: 5,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1F2937)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}