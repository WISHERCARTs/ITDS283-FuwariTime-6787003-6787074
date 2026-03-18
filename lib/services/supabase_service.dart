import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SupabaseService {
  // -------------------------------------------------------------
  // [ส่วนที่ 1] คีย์การเชื่อมต่อฐานข้อมูล Supabase
  // (ดูข้อมูลนี้ได้จากเว็บไซต์ Supabase โปรเจกต์ของเราในเมนู Project Settings > API)
  // -------------------------------------------------------------
  static const String supabaseUrl = 'https://amshfbnlupanuykjpcph.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFtc2hmYm5sdXBhbnV5a2pwY3BoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM3MjY4MDcsImV4cCI6MjA4OTMwMjgwN30.95ihe4TCf3mvYXIv-SB6u-5WKEyNJIj9PPmWBGfZjus';

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

    // 2. ตั้งค่าแพ็กเกจล็อกอินกูเกิ้ล (Google Sign-In) เอาไว้ตั้งแต่เริ่มแอป เพื่อลดปัญหา Error โดนเรียกซ้ำซ้อน
    await GoogleSignIn.instance.initialize(
      clientId: webClientId,
      // ทริคสำคัญ (แก้ไขบัค v7): เราต้องใส่เงื่อนไข kIsWeb เช็คว่า "ถ้ารันบน Browser ห้ามส่งค่า serverClientId ไปเด็ดขาด ไม่งั้นบนเว็บจะบัค"
      serverClientId: kIsWeb ? null : webClientId,
    );
  }

  // ตัวแปรแบบย่อ (get) เอาไว้เรียกใช้คำสั่งคิวรี่ Supabase ในแอปสะดวกขึ้น
  static SupabaseClient get client => Supabase.instance.client;

  /// ฟังก์ชันเรียกหน้าต่าง Login ด้วยบัญชี Google ขึ้นมาใช้งาน
  static Future<AuthResponse?> signInWithGoogle() async {
    GoogleSignInAccount googleUser;

    try {
      // 1. โชว์หน้าต่างของ Google ให้ผู้ใช้เลือกคลิกเมลที่ต้องการเข้าใช้งาน
      googleUser = await GoogleSignIn.instance.authenticate();
    } catch (e) {
      // กรณีผู้ใช้กดปุ่ม X เพื่อปิดหน้าต่างหนี หรือเน็ตหลุด จะหยุดการทำงานและส่งกลับเป็นค่าว่าง (null)
      return null;
    }

    // 2. เมื่อกูเกิ้ลอนุญาตและยืนยันตัวตนสำเร็จ เราจะนำข้อมูลการยืนยันมาใช้งานต่อ (Authentication)
    final googleAuth = await googleUser.authentication;

    // 3. ดึง "ป้ายบัตรยืนยันตัวตน" (idToken) ที่กูเกิลประทับตรามาให้ออกมาเพื่อส่งต่อให้ฝั่งเรา
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      throw 'ไม่สามารถดึงข้อมูล Token จาก Google ได้ กรุณาลองใหม่อีกครั้ง';
    }

    // 4. ขั้นตอนสุดท้าย! โยน idToken ที่กูเกิ้ลให้มา ส่งบอกป้อมยาม Supabase ว่าคนนี้ผ่านการอนุมัติแล้วนะ
    // เอาสิทธิ์ Supabase ล็อกอินของผู้ใช้คนนี้บันทึกลงระบบสมัครสมาชิกอัตโนมัติได้เลยผ่าน .signInWithIdToken!
    return await client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );
  }
}
