import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/profile_service.dart';

enum TimeState { day, night }
enum WeatherState { clear, rain }

class BackgroundController extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  TimeState _timeState = TimeState.day;
  WeatherState _weatherState = WeatherState.clear;
  
  // 🕒 ระบบนับเวลาการใช้งานแอป
  final DateTime _appStartTime = DateTime.now();
  Timer? _usageTimer;
  int _lastRewardedMinute = 0; // 🎁 เก็บนาทีล่าสุดที่แจกเหรียญ (10, 20, 30...)

  BackgroundController() {
    // เริ่ม Timer เพื่ออัปเดตเวลาการใช้งานทุกวินาที
    _usageTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkUsageReward();
      notifyListeners();
    });
  }

  // 🎁 เช็คทุกนาทีว่าถึงคิวแจกเหรียญหรือยัง (10 นาที = 20 เหรียญ)
  void _checkUsageReward() {
    final currentMins = appUsageDuration.inMinutes;
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId != null && 
        currentMins > 0 && 
        currentMins % 10 == 0 && 
        currentMins != _lastRewardedMinute) {
      
      _lastRewardedMinute = currentMins;
      _profileService.addPoints(userId, 20); // 💸 แจก 20 เหรียญ
      print("🎁 Reward: 20 Coins added for $currentMins minutes usage!");
    }
  }

  @override
  void dispose() {
    _usageTimer?.cancel();
    super.dispose();
  }

  TimeState get timeState => _timeState;
  WeatherState get weatherState => _weatherState;

  // 🚀 Getter สำหรับเวลาที่ใช้งานแอปวันนี้
  Duration get appUsageDuration => DateTime.now().difference(_appStartTime);

  // Paths จาก assets/videos/ ที่เพื่อนเตรียมไว้
  String get currentVideoPath {
    if (_timeState == TimeState.day) {
      return _weatherState == WeatherState.clear 
          ? 'assets/videos/sun.mp4' 
          : 'assets/videos/sun_rain.mp4';
    } else {
      return _weatherState == WeatherState.clear 
          ? 'assets/videos/moon.mp4' 
          : 'assets/videos/moon_rain.mp4';
    }
  }

  void setTime(TimeState state) {
    if (_timeState != state) {
      _timeState = state;
      notifyListeners();
    }
  }

  void setWeather(WeatherState state) {
    if (_weatherState != state) {
      _weatherState = state;
      notifyListeners();
    }
  }

  void toggleTime() {
    _timeState = _timeState == TimeState.day ? TimeState.night : TimeState.day;
    notifyListeners();
  }

  void toggleWeather() {
    _weatherState = _weatherState == WeatherState.clear ? WeatherState.rain : WeatherState.clear;
    notifyListeners();
  }
}
