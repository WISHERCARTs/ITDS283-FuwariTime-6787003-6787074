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
      // 1. อัปเดตข้อมูลในตาราง profiles (ใช้แสดงผลในแอป)
      await _supabase.from('profiles').upsert(profile.toJson());

      // 2. อัปเดตข้อมูลในระบบ Auth ของ Supabase ด้วย (เพื่อให้หน้า Dashboard หลังบ้านตรงกับในแอป)
      if (profile.username != null && profile.username!.isNotEmpty) {
        await _supabase.auth.updateUser(
          UserAttributes(
            data: {'full_name': profile.username, 'name': profile.username},
          ),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  // 🎁 ฟังก์ชันกดรับเหรียญขวัญถุง 200 เหรียญ (แบบกดรับเองจากหน้า Profile)
  Future<void> claimWelcomeBonus(String userId) async {
    try {
      final profile = await getProfile(userId);

      if (profile == null) {
        // ✨ ถ้ายังไม่มี Profile เลย ให้สร้างใหม่พร้อมเริ่มที่ 200
        await _supabase.from('profiles').upsert({
          'id': userId,
          'username': 'Fuwari User',
          'points': 200,
          'has_claimed_bonus': true,
        });
      } else if (!profile.hasClaimedBonus) {
        // 💰 ถ้ามี Profile แล้วแต่ยังไม่เคยรับโบนัส ให้บวกเพิ่ม 200 และเซ็ตสถานะเป็นรับแล้ว
        final newPoints = profile.points + 200;
        await _supabase
            .from('profiles')
            .update({'points': newPoints, 'has_claimed_bonus': true})
            .eq('id', userId);
      }
    } catch (e) {
      print('Error claiming welcome bonus: $e');
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
        // 💡 กรณีตารางว่าง (ยิงครั้งแรก) ให้สร้างแถวข้อมูลพร้อมพุซซิ่งแต้มแค่ตัวกิจกรรม (ไม่มีโบนัส 200 แล้ว)
        await _supabase.from('profiles').upsert({
          'id': userId,
          'username': 'New User',
          'points': pointsToAdd, // 🎁 เริ่มต้นที่ 0 + แต้มกิจกรรม
          'has_claimed_bonus': false,
        });
      }
    } catch (e) {
      print('Error adding points: $e');
    }
  }
}
