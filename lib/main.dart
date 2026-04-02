import 'package:flutter/material.dart';

import 'package:fuwari_time/features/auth/screens/login_screen.dart';


import 'package:flutter_dotenv/flutter_dotenv.dart';



import 'package:fuwari_time/features/stats/stat.dart';


import 'package:fuwari_time/features/shop/shop.dart';
import 'package:fuwari_time/features/shop/shop_pay/shop_pay.dart';

import 'package:fuwari_time/services/supabase_service.dart';
import 'package:fuwari_time/features/auth/screens/auth_gate.dart';
import 'package:google_fonts/google_fonts.dart';


import 'features/welcome/welcome.dart';

import 'dart:ui';


import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'features/welcome/welcome.dart';



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
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
        },
      ),
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.outfitTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B4E3D)),
      ),

      home: const AuthGate(),


    );
  }
}
