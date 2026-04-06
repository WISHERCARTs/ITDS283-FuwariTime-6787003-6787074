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
        redirectTo: kIsWeb ? Uri.base.origin : 'io.supabase.fuwaritime://login-callback/',
        // 🚀 เติมโค้ดนี้เข้าไป เพื่อบังคับให้ผู้ใช้เลือกอีเมลใหม่ทุกครั้งตอนล็อกอิน!
        queryParams: {
          'prompt': 'select_account',
        },
      );
      return null;
    } catch (e) {
      print('❌ Google Sign-In Error: $e');
      rethrow;
    }
  }
}
