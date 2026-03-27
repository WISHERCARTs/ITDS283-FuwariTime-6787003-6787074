import 'package:flutter/material.dart';
import '../../../services/supabase_service.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  String textField1 = '';

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
                                colors: [
                                  Color(0xFFFFD6E8),
                                  Color(0xFFE4D4F4),
                                ],
                              ),
                            ),
                            margin: const EdgeInsets.only(bottom: 71),
                            height: 120,
                            width: double.infinity,
                            child: const SizedBox(),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 1),
                            margin: const EdgeInsets.only(bottom: 30, left: 57),
                            child: const Text(
                              "Fuwari Time",
                              style: TextStyle(
                                color: Color(0xFF090909),
                                fontSize: 48,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 70, left: 70),
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
                            padding: const EdgeInsets.only(left: 50, right: 29, bottom: 20),
                            child: TextField(
                              onChanged: (val) => textField1 = val,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined, color: Color(0xFFB78403)),
                                hintText: "Email",
                                hintStyle: TextStyle(color: Color(0xFF888888), fontSize: 16),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0x4FB78403)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFB78403), width: 2),
                                ),
                              ),
                            ),
                          ),
                          // PASSWORD FIELD
                          const Padding(
                            padding: EdgeInsets.only(left: 50, right: 29, bottom: 14),
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline, color: Color(0xFFB78403)),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Color(0xFF888888), fontSize: 16),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0x4FB78403)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFB78403), width: 2),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 42, left: 95),
                            child: const Text(
                              "Remember me",
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 8,
                              ),
                            ),
                          ),
                          
                          // LOGIN BUTTON
                          Container(
                            margin: const EdgeInsets.only(left: 88, right: 29, bottom: 15),
                            width: double.infinity,
                            child: InkWell(
                              onTap: () {
                                print('Pressed Login');
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
                            margin: const EdgeInsets.only(left: 88, right: 29, bottom: 27),
                            width: double.infinity,
                            child: InkWell(
                              onTap: () async {
                                print('Pressed Google Login');
                                try {
                                  final response = await SupabaseService.signInWithGoogle();
                                  if (response != null) {
                                    print('✅ ล็อกอินด้วย Google สำเร็จ: ${response.user?.email}');
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                                    );
                                  }
                                  print('❌ เกิดข้อผิดพลาดในการล็อกอินด้วย Google: $e');
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: const Color(0xFFFFFFFF),
                                  border: Border.all(color: const Color(0xFFECD4F0), width: 2),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login, color: Colors.blue, size: 20),
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

                          Container(
                            margin: const EdgeInsets.only(left: 97),
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
                                  fontSize: 12,
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
