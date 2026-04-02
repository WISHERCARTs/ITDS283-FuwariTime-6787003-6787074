import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fuwari_time/features/auth/screens/login_screen.dart';
import '../../home/screens/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      initialData: AuthState(
        AuthChangeEvent.initialSession,
        Supabase.instance.client.auth.currentSession,
      ),
      builder: (context, snapshot) {
        final session = snapshot.data?.session;

        // ถ้ามี session กลับมาแล้ว พาไปหน้า Home เลย
        if (session != null) {
          return HomeScreen();
        }

        // ไม่มี session ก็ให้ไปหน้า Login เลย! ไม่ต้องมีวงแหวนหมุนแล้ว
        return const LoginScreen();
      },
    );
  }
}
