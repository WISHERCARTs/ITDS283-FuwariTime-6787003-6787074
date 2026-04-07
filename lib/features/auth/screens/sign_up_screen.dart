import 'package:flutter/material.dart';
import '../../../services/supabase_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUpScreen> {
  bool _isObscure = true; // 👁️ สำหรับช่อง Password
  bool _isObscureConfirm = true; // 👁️ สำหรับช่อง Confirm Password

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
                    padding: const EdgeInsets.only(bottom: 165),
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
                        IntrinsicWidth(
                          child: IntrinsicHeight(
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 1),
                              margin: const EdgeInsets.only(
                                bottom: 139,
                                left: 57,
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Fuwari Time",
                                    style: TextStyle(
                                      color: Color(0xFF090909),
                                      fontSize: 48,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        IntrinsicHeight(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 35),
                            width: double.infinity,
                            child: const Column(
                              children: [
                                Text(
                                  "Create an account",
                                  style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // NAME FIELD
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 50,
                            right: 29,
                            bottom: 15,
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Color(0xFFB78403),
                              ),
                              hintText: "Name",
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
                        // EMAIL FIELD
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 50,
                            right: 29,
                            bottom: 15,
                          ),
                          child: TextField(
                            decoration: InputDecoration(
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
                            left: 50,
                            right: 29,
                            bottom: 15,
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
                                onPressed: () =>
                                    setState(() => _isObscure = !_isObscure),
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
                        // CONFIRM PASSWORD FIELD
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 50,
                            right: 29,
                            bottom: 15,
                          ),
                          child: TextField(
                            obscureText: _isObscureConfirm,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFFB78403),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscureConfirm
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFFB78403),
                                ),
                                onPressed: () => setState(
                                  () => _isObscureConfirm = !_isObscureConfirm,
                                ),
                              ),
                              hintText: "Confirm Password",
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
                        IntrinsicHeight(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 28),
                            width: double.infinity,
                            child: Column(
                              children: [
                                IntrinsicWidth(
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              1,
                                            ),
                                            color: const Color(0xFF7AAACE),
                                          ),
                                          margin: const EdgeInsets.only(
                                            right: 9,
                                          ),
                                          width: 12,
                                          height: 12,
                                          child: const SizedBox(),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                            right: 112,
                                          ),
                                          child: const Text(
                                            "Remember me",
                                            style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 8,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          "Forgot password?",
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // SIGN UP BUTTON
                        Container(
                          margin: const EdgeInsets.only(
                            left: 88,
                            right: 29,
                            bottom: 15,
                          ),
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {
                              print('Pressed Sign Up');
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: const Color(0xFFECD4F0),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: const Text(
                                "SIGN UP",
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // GOOGLE SIGN UP BUTTON
                        Container(
                          margin: const EdgeInsets.only(
                            left: 88,
                            right: 29,
                            bottom: 27,
                          ),
                          width: double.infinity,
                          child: InkWell(
                            onTap: () async {
                              print('Pressed Google Sign Up');
                              try {
                                final response =
                                    await SupabaseService.signInWithGoogle();
                                if (response != null) {
                                  print(
                                    '✅ สมัครสมาชิกด้วย Google สำเร็จ: ${response.user?.email}',
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('เกิดข้อผิดพลาด: $e'),
                                    ),
                                  );
                                }
                                print(
                                  '❌ เกิดข้อผิดพลาดในการสมัครสมาชิกด้วย Google: $e',
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

                        // NAVIGATION TO LOGIN
                        Container(
                          margin: const EdgeInsets.only(left: 97),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Already have an account ?  ",
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
