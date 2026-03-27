import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io' show Platform;

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

    // 2. ตั้งค่าแพ็กเกจล็อกอินกูเกิ้ล (Google Sign-In) เอาไว้ตั้งแต่เริ่มแอป
    // google_sign_in รองรับเฉพาะ Android/iOS เท่านั้น! (ไม่รองรับ Web และ Desktop)
    final bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
    if (isMobile) {
      await GoogleSignIn.instance.initialize(
        clientId: webClientId,
        serverClientId: webClientId,
      );
    }
  }

  // ตัวแปรแบบย่อ (get) เอาไว้เรียกใช้คำสั่งคิวรี่ Supabase ในแอปสะดวกขึ้น
  static SupabaseClient get client => Supabase.instance.client;

  /// ฟังก์ชันเรียกหน้าต่าง Login ด้วยบัญชี Google ขึ้นมาใช้งาน
  static Future<AuthResponse?> signInWithGoogle() async {
    // เช็คว่าเป็น Mobile (Android/iOS) หรือไม่
    final bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    try {
      if (!isMobile) {
        // [สำหรับ Web / Windows Desktop] ใช้ Supabase OAuth โดยตรง
        // signInWithOAuth จะทำการ redirect ไปที่ Google
        // เมื่อกลับมา AuthGate จะดึง session ให้อัตโนมัติ
        await client.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: kIsWeb ? Uri.base.origin : null,
        );
        return null;
      } else {
        // [สำหรับ iOS/Android]
        // 1. โชว์หน้าต่างของ Google ให้ผู้ใช้เลือกคลิกเมลที่ต้องการเข้าใช้งาน
        final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();

        if (googleUser == null) {
          throw 'ผู้ใช้ยกเลิกการเข้าระบบ';
        }

        // 2. เมื่อกูเกิ้ลอนุญาตและยืนยันตัวตนสำเร็จ เราจะนำข้อมูลการยืนยันมาใช้งานต่อ (Authentication)
        final googleAuth = await googleUser.authentication;

        // 3. ดึง "ป้ายบัตรยืนยันตัวตน" (idToken) ที่กูเกิลประทับตรามาให้ออกมาเพื่อส่งต่อให้ฝั่งเรา
        final idToken = googleAuth.idToken;

        if (idToken == null) {
          throw 'ไม่สามารถดึงข้อมูล Token จาก Google ได้ กรุณาลองใหม่อีกครั้ง';
        }

        // 4. ขั้นตอนสุดท้าย! โยน idToken ที่กูเกิ้ลให้มา ส่งบอกป้อมยาม Supabase ว่าคนนี้ผ่านการอนุมัติแล้วนะ
        return await client.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
        );
      }
    } catch (e) {
      // พิมพ์ข้อความ Error ออกมาดูว่าเกิดจากอะไรที่เบื้องหลังหน้าเว็บ
      print('❌ Google Sign-In Error: $e');
      rethrow;
    }
  }
}
