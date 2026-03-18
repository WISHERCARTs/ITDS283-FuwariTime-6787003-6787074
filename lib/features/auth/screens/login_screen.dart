import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/supabase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6), // Cozy Cream Background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Fuwari Time',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6B4E3D),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome back, study buddy!',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: const Color(0xFFA68B7C),
                ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement Login Logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B4E3D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              // ==========================================
              // ปุ่มล็อกอินด้วยบัญชี Google
              // ==========================================
              OutlinedButton.icon(
                onPressed: () async {
                  try {
                    // เรียกใช้งานฟังก์ชัน Google Login ตัวเก่งที่เราเขียนรอไว้ใน Service
                    final response = await SupabaseService.signInWithGoogle();
                    
                    // ถ้าข้อมูลที่ส่งกลับมาไม่ว่าง (null) แปลว่า Supabase อนุญาตผู้ใช้คนนี้เข้าสู่ระบบผ่านฉลุย
                    if (response != null) {
                      // TODO: เมื่อทุกอย่างเสร็จสมบูรณ์ สามารถสั่ง Navigator เด้งเปลี่ยนฉากไปหน้าถัดไป (Home) ได้เลย
                      print('✅ ล็อกอินสำเร็จ ยินดีต้อนรับ: ${response.user?.email}');
                    }
                  } catch (e) {
                    // ถ้าล็อกอินพังๆ หรือติด Error ให้ Print ข้อความมาดูว่ามีอะไรผิดพลาดแบบหล่อๆ
                    print('❌ เกิดข้อผิดพลาดในการล็อกอินด้วย Google: $e');
                  }
                },
                icon: const Icon(Icons.login, color: Colors.blue),
                label: const Text(
                  'Sign in with Google',
                  style: TextStyle(color: Colors.black87),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to Register
                },
                child: const Text('Don\'t have an account? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
