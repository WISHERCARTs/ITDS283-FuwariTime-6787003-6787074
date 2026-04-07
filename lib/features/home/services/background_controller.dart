import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../services/profile_service.dart';
import '../../../services/weather_service.dart';

enum TimeState { day, night }

enum WeatherState { clear, rain }

class BackgroundController extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final WeatherService _weatherService = WeatherService();

  TimeState _timeState = TimeState.day;
  WeatherState _weatherState = WeatherState.clear;
  String _currentAddress = "Checking location...";

  // 🕒 ระบบนับเวลาการใช้งานแอป
  final DateTime _appStartTime = DateTime.now();
  Timer? _usageTimer;
  int _lastRewardedMinute = 0;
  bool _isSyncing = false; // 🛡️ ตะแกรงกั้นไม่ให้ซิงค์ซ้อนกันจนค้าง

  BackgroundController() {
    // 🕒 เริ่ม Timer เพื่ออัปเดตเวลาการใช้งานทุกวินาที
    _usageTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkUsageReward();
      notifyListeners();
    });
  }

  /// 🛰️ ซิงค์พิกัด GPS เพื่อดึงอากาศและที่อยู่ล่าสุด
  Future<void> syncLocationAndWeather() async {
    // 🛡️ ถ้ากำลังซิงค์อยู่แล้ว ไม่ต้องทำซ้ำ (ป้องกันแอปค้างจากการเรียกซ้อน)
    if (_isSyncing) return;
    
    _isSyncing = true;
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // ✅ เพิ่ม Timeout ให้กับการตรวจสอบ Location Service (2 วินาทีพอ!)
      serviceEnabled = await Geolocator.isLocationServiceEnabled().timeout(
        const Duration(seconds: 2),
        onTimeout: () => false,
      );
      
      if (!serviceEnabled) {
        _currentAddress = "Location disabled";
        return;
      }

      // ✅ เพิ่ม Timeout ให้กับการเช็คสิทธิ์ (2 วินาที!)
      permission = await Geolocator.checkPermission().timeout(
        const Duration(seconds: 2),
        onTimeout: () => LocationPermission.denied,
      );

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _currentAddress = "Location denied";
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _currentAddress = "Permission denied forever";
        return;
      }

      // 📍 1. พยายามดึงพิกัด (ใช้ Last Known ก่อน หรือใช้ Current แบบมี Timeout)
      Position? position;
      
      // ✅ ก๊อก 1: เอาพิกัดเก่าที่มีในเครื่องมาใช้ก่อน (ไวมาก!)
      position = await Geolocator.getLastKnownPosition();

      // ✅ ก๊อก 2: ถ้าไม่มีพิกัดเก่า ให้ขอใหม่แต่ตั้งเวลาตายสั้นๆ 3 วินาที (ป้องกันแอปค้าง)
      position ??= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 3), // 🕒 3 Sec Limit
      );

      // ☁️ 2. ดึงสภาพอากาศจากพิกัด (OpenWeather API)
      _weatherState = await _weatherService.fetchWeatherByLocation(
        position.latitude, 
        position.longitude,
      );

      // 🗺️ 3. แปลเป็นชื่อที่อยู่ (อำเภอ, จังหวัด, ประเทศ)
      _currentAddress = await _weatherService.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      // 🚑 กรณี Timeout หรือ Error อื่นๆ ให้แอปไปต่อได้ ไม่ค้าง
      print("📍 GPS Sync Error/Timeout: $e");
      if (_currentAddress == "Checking location...") {
        _currentAddress = "Location sync error (Timeout)";
      }
    }

    notifyListeners();
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
      _profileService.addPoints(userId, 20);
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
  String get currentAddress => _currentAddress;

  Duration get appUsageDuration => DateTime.now().difference(_appStartTime);

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
    _weatherState = _weatherState == WeatherState.clear
        ? WeatherState.rain
        : WeatherState.clear;
    notifyListeners();
  }
}
