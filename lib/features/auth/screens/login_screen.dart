import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_service.dart';
import 'sign_up_screen.dart';
// 🚀 อย่าลืม Import หน้า Welcome เข้ามานะครับ
import 'package:fuwari_time/features/welcome/welcome.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  String textField1 = '';
  bool _isObscure = true; // 👁️ สำหรับเปิด/ปิดการมองเห็นรหัสผ่าน

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: const Color(0xFFFFFFFF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xFFFFF8F0),
                  ),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 137),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1A000000),
                                blurRadius: 15,
                                offset: Offset(0, 10),
                              ),
                            ],
                            gradient: const LinearGradient(
                              begin: Alignment(-1, -1),
                              end: Alignment(-1, 1),
                              colors: [Color(0xFFFFD6E8), Color(0xFFE4D4F4)],
                            ),
                          ),
                          margin: const EdgeInsets.only(bottom: 71),
                          height: 120,
                          width: double.infinity,
                          child: const SizedBox(),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 1),
                          margin: const EdgeInsets.only(bottom: 30, left: 50),
                          child: const Text(
                            "Fuwari Time",
                            style: TextStyle(
                              color: Color(0xFF090909),
                              fontSize: 48,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 50, left: 50),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // EMAIL FIELD
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 40,
                            right: 40,
                            bottom: 20,
                          ),
                          child: TextField(
                            onChanged: (val) => textField1 = val,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Color(0xFFB78403),
                              ),
                              hintText: "Email",
                              hintStyle: TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 16,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x4FB78403),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFB78403),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // PASSWORD FIELD
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 40,
                            right: 40,
                            bottom: 14,
                          ),
                          child: TextField(
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFFB78403),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFFB78403),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                              hintText: "Password",
                              hintStyle: const TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 16,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x4FB78403),
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFB78403),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(bottom: 42, left: 40),
                          child: const Text(
                            "Remember me",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 10,
                            ),
                          ),
                        ),

                        // LOGIN BUTTON
                        Container(
                          margin: const EdgeInsets.only(
                            left: 40,
                            right: 40,
                            bottom: 15,
                          ),
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {
                              print('Pressed Login');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Welcome(),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: const Color(0xFFECD4F0),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: const Text(
                                "LOGIN",
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // GOOGLE LOGIN BUTTON
                        Container(
                          margin: const EdgeInsets.only(
                            left: 40,
                            right: 40,
                            bottom: 27,
                          ),
                          width: double.infinity,
                          child: InkWell(
                            onTap: () async {
                              print('Pressed Google Login');
                              try {
                                // 🚀 1. เรียกใช้ SupabaseService ที่เราไปทำระบบเด้งกลับแอปเอาไว้
                                await SupabaseService.signInWithGoogle();
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('เกิดข้อผิดพลาด: $e'),
                                    ),
                                  );
                                }
                                print(
                                  '❌ เกิดข้อผิดพลาดในการล็อกอินด้วย Google: $e',
                                );
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: const Color(0xFFFFFFFF),
                                border: Border.all(
                                  color: const Color(0xFFECD4F0),
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.login,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      "Continue with Google",
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // SIGN UP BUTTON
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Don’t have an account ?  ",
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
