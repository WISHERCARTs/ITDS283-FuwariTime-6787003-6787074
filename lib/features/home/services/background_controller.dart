import 'package:flutter/material.dart';

enum TimeState { day, night }
enum WeatherState { clear, rain }

class BackgroundController extends ChangeNotifier {
  TimeState _timeState = TimeState.day;
  WeatherState _weatherState = WeatherState.clear;

  TimeState get timeState => _timeState;
  WeatherState get weatherState => _weatherState;

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
