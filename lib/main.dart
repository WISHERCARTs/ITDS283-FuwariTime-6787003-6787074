import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fuwari_time/services/supabase_service.dart';
import 'package:fuwari_time/features/home/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Initialize Supabase
  await SupabaseService.initialize();
  
  runApp(const FuwariTimeApp());
}

class FuwariTimeApp extends StatelessWidget {
  const FuwariTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fuwari Time',
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.trackpad},
      ),
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.outfitTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B4E3D),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
