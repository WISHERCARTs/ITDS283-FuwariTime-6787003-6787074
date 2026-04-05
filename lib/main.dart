import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:fuwari_time/services/supabase_service.dart';
import 'package:fuwari_time/core/services/notification_service.dart';
import 'package:fuwari_time/features/auth/screens/auth_gate.dart';
import 'package:fuwari_time/features/home/services/background_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import 'package:fuwari_time/features/home/widgets/pomodoro_timer_dialog.dart';
import 'package:fuwari_time/features/home/widgets/todo_list_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await SupabaseService.initialize();

  // Initialize Notification Service
  await NotificationService().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BackgroundController()),
        ChangeNotifierProvider(create: (_) => PomodoroController()),
        ChangeNotifierProvider(create: (_) => TodoController()),
      ],
      child: const FuwariTimeApp(),
    ),
  );
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
