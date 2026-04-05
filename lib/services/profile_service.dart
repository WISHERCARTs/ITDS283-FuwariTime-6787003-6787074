import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileService {
  final _supabase = Supabase.instance.client;

  // ดึงข้อมูลโปรไฟล์ของ User ที่ล็อกอินอยู่
  Future<ProfileModel?> getProfile(String userId) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return ProfileModel.fromJson(data);
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  // อัปเดตข้อมูลโปรไฟล์ (เช่น ชื่อ หรือแต้ม)
  // ใช้ upsert เพื่อให้สร้างข้อมูลใหม่ถ้ายังไม่มี หรืออัปเดตถ้ามีแล้ว
  Future<void> updateProfile(ProfileModel profile) async {
    try {
      await _supabase.from('profiles').upsert(profile.toJson());
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  // เพิ่มแต้มให้ผู้ใช้ (เช่น หลังจบ Focus Session)
  Future<void> addPoints(String userId, int pointsToAdd) async {
    try {
      final profile = await getProfile(userId);
      if (profile != null) {
        final newPoints = profile.points + pointsToAdd;
        await _supabase
            .from('profiles')
            .update({'points': newPoints})
            .eq('id', userId);
      } else {
        // 💡 กรณีตารางว่าง (ยิงครั้งแรก) ให้สร้างแถวข้อมูลพร้อมพ้อยท์เริ่มต้นเลย
        await _supabase.from('profiles').upsert({
          'id': userId,
          'username': 'New User',
          'points': pointsToAdd,
        });
      }
    } catch (e) {
      print('Error adding points: $e');
    }
  }
}
