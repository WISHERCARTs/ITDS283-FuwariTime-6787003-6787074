import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';
import 'package:fuwari_time/services/profile_service.dart';
import 'package:fuwari_time/services/inventory_service.dart';
import 'package:fuwari_time/features/music/music_state.dart';
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
              subtitle: "${widget.itemPrice} Coins",
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

  // 🪙 ฟังก์ชันหักเหรียญจากบัญชีจริงๆ
  Future<void> _handleCoinPayment() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    setState(() => _isProcessing = true);

    try {
      final profile = await _profileService.getProfile(userId);
      if (profile != null) {
        if (profile.points >= widget.itemPrice) {
          // 💸 1. หักแต้ม
          await _profileService.addPoints(userId, -widget.itemPrice);
          
          // 🎶 2. บันทึกลง Inventory (เฉพาะถ้าเป็นเพลง)
          await _inventoryService.purchaseItem(userId, widget.itemName, "Music");
          
          // 🔄 3. ซิงค์ตู้เพลงทันทีเพื่อให้ Sold Out และเพิ่มเพลงในกระเป๋า
          await musicController.syncInventory();

          _showStatusMessage("Successfully purchased ${widget.itemName}!", Colors.green);
        } else {
          _showStatusMessage("Not enough coins! Go focus more. 🔥", Colors.redAccent);
        }
      }
    } catch (e) {
      _showStatusMessage("Error processing payment.", Colors.redAccent);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showStatusMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
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
                TopBar(), // 🚀 ใช้ TopBar แบบ StatefulWidget
                const SizedBox(height: 24),
                
                // 📦 Card รายละเอียดสินค้า
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
                        // 🖼️ รูปสินค้าขนาดใหญ่
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                          child: Image.network(
                            widget.imageUrl,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Product Details",
                                style: TextStyle(color: Color(0xFF6B7280), fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.itemName,
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                              ),
                              const SizedBox(height: 16),
                              
                              // 💎 ราคา
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
                                    "${widget.itemPrice} Coins",
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFA16207)),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 32),
                              
                              // 🛒 ปุ่มสั่งซื้อ
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
          
          // 🔙 ปุ่มย้อนกลับแบบลอย
          Positioned(
            top: 60,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1F2937)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}