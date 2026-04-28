import 'package:supabase_flutter/supabase_flutter.dart';

class InventoryService {
  final _supabase = Supabase.instance.client;

  // ดึงรายชื่อไอเทมที่ User เป็นเจ้าของแล้ว
  Future<List<String>> fetchOwnedItems(String userId) async {
    try {
      final data = await _supabase
          .from('user_inventory')
          .select('item_name')
          .eq('user_id', userId);
      
      return (data as List).map((item) => item['item_name'] as String).toList();
    } catch (e) {
      print('Error fetching inventory: $e');
      return [];
    }
  }

  // บันทึกการซื้อไอเทมใหม่ลง Supabase
  Future<void> purchaseItem(String userId, String itemName, String category) async {
    try {
      await _supabase.from('user_inventory').insert({
        'user_id': userId,
        'item_name': itemName,
        'category': category,
      });
    } catch (e) {
      print('Error recording purchase: $e');
      rethrow;
    }
  }
}
