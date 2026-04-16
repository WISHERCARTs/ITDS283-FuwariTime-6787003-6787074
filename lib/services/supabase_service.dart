import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // -------------------------------------------------------------
  // [ส่วนที่ 1] คีย์การเชื่อมต่อฐานข้อมูล Supabase
  // (ดูข้อมูลนี้ได้จากเว็บไซต์ Supabase โปรเจกต์ของเราในเมนู Project Settings > API)
  // -------------------------------------------------------------
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get weatherApiKey => dotenv.env['WeatherAPIkey'] ?? '';

  // -------------------------------------------------------------
  // [ส่วนที่ 2] ค่า Client ID เอาไว้บอกกูเกิ้ลว่าแอปเราชื่ออะไรเวลามีหน้าเว็บเด้งให้ล็อกอิน
  // (สร้างมาจาก Google Cloud Console)
  // -------------------------------------------------------------
  static const String webClientId =
      '572476085892-o7gcvdv87g4i3tcelveejldhi0qk4nm7.apps.googleusercontent.com';

  /// ฟังก์ชันสำหรับโหลดตั้งค่า Auth ทั้งบรรทัดแรกเริ่ม
  /// (โค้ดส่วนนี้จะถูกสั่งให้รันทำงานอัตโนมัติตั้งแต่ตอนเริ่มต้นแอปในไฟล์ main.dart)
  static Future<void> initialize() async {
    // 1. นำแอปของเราเข้าไปผูกกับฐานข้อมูล Supabase
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  // ตัวแปรแบบย่อ (get) เอาไว้เรียกใช้คำสั่งคิวรี่ Supabase ในแอปสะดวกขึ้น
  static SupabaseClient get client => Supabase.instance.client;

  /// ฟังก์ชันเรียกหน้าต่าง Login ด้วยบัญชี Google ขึ้นมาใช้งาน
  /// ฟังก์ชันเรียกหน้าต่าง Login ด้วยบัญชี Google ขึ้นมาใช้งาน
  static Future<AuthResponse?> signInWithGoogle() async {
    try {
      await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb
            ? Uri.base.origin
            : 'io.supabase.fuwaritime://login-callback/',
        // 🚀 เติมโค้ดนี้เข้าไป เพื่อบังคับให้ผู้ใช้เลือกอีเมลใหม่ทุกครั้งตอนล็อกอิน!
        queryParams: {'prompt': 'select_account'},
      );
      return null;
    } catch (e) {
      print('❌ Google Sign-In Error: $e');
      rethrow;
    }
  }

  /// ฟังก์ชันลบบัญชีผู้ใช้ (Delete Account)
  /// จะทำการลบข้อมูลทั้งหมดที่เกี่ยวข้องในตารางต่างๆ แล้วเรียก RPC `delete_user` เพื่อลบออกจาก `auth.users`
  static Future<void> deleteAccount() async {
    try {
      final user = client.auth.currentUser;
      if (user == null) return;

      final userId = user.id;

      // 1. ลบข้อมูลงตาราง public ต่างๆ ก่อน (เพื่อป้องกัน Foreign Key Error ถ้าไม่ได้ตั้ง Cascade ไว้)
      // เผื่อว่าบางตารางลบไม่ได้หรือไม่เจอ ก็ให้ catch แยกแต่ละอันไปเลยเพื่อให้ลบได้มากที่สุด
      try {
        await client.from('todos').delete().eq('user_id', userId);
      } catch (e) {
        print("❌ Could not delete todos: $e");
      }
      try {
        await client.from('timer_sessions').delete().eq('user_id', userId);
      } catch (e) {
        print("❌ Could not delete timer_sessions: $e");
      }
      try {
        await client.from('user_inventory').delete().eq('user_id', userId);
      } catch (e) {
        print("❌ Could not delete user_inventory: $e");
      }
      try {
        await client.from('profiles').delete().eq('id', userId);
      } catch (e) {
        print("❌ Could not delete profile: $e");
      }

      // 2. เรียกใช้ RPC function ในฐานข้อมูลเพื่อลบ User ออกจาก auth.users
      // ข้อควรระวัง: ต้องไปสร้าง SQL Function ชื่อ delete_user() ในหน้า SQL Editor ของ Supabase ก่อน!
      try {
        await client.rpc('delete_user');
      } catch (e) {
        print("❌ RPC delete_user error (Did you create the SQL function?): $e");
        throw Exception("ไม่สามารถลบ User จากระบบล็อกอินได้ (ลืมรันคำสั่ง SQL หรือเปล่า?)\n$e");
      }

      // 3. Sign Out ออกจากระบบ
      await client.auth.signOut();
    } catch (e) {
      print('❌ Delete Account Error: $e');
      rethrow;
    }
  }
}
