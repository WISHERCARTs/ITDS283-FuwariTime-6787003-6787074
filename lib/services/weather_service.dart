import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:fuwari_time/services/supabase_service.dart';
import 'package:fuwari_time/features/home/services/background_controller.dart';

class WeatherService {
  final String _apiKey = SupabaseService.weatherApiKey;

  /// ดึงข้อมูลอากาศจากพิกัด Lat/Lon
  Future<WeatherState> fetchWeatherByLocation(double lat, double lon) async {
    if (_apiKey.isEmpty) return WeatherState.clear;

    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final weatherMain = data['weather'][0]['main'].toString().toLowerCase();

        // ตรวจเช็คว่าฝนตกไหม (รวมถึงพายุหรือดีเปรสชัน)
        if (weatherMain.contains('rain') ||
            weatherMain.contains('thunderstorm') ||
            weatherMain.contains('drizzle')) {
          return WeatherState.rain;
        }
      }
    } catch (e) {
      print('❌ Error fetching weather: $e');
    }
    return WeatherState.clear;
  }

  /// แปลงพิกัด Lat/Lon เป็นชื่อ "อำเภอ, จังหวัด, ประเทศ"
  Future<String> getAddressFromLatLng(double lat, double lon) async {
    try {
      // ตั้งเวลาตาย 5 วินาทืสำหรับการดึงชื่อที่อยู่ (ป้องกันเน็ตช้าทำแอปค้าง)
      List<Placemark> placemarks = await placemarkFromCoordinates(
        lat,
        lon,
      ).timeout(const Duration(seconds: 5));
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // ดึงชื่อ อำเภอ, จังหวัด, และประเทศ
        String subDistrict = place.subLocality ?? "";
        String district = place.locality ?? "";
        String province = place.administrativeArea ?? "";
        String country = place.country ?? "";

        // จัดรูปแบบให้สวยงาม (แสดงแค่อำเภอ จังหวัด และประเทศ ตามที่ขอ)
        return "${district.isNotEmpty ? district : subDistrict}, $province, $country";
      }
    } catch (e) {
      print('❌ Error getting address: $e');
    }
    return "Unknown Location";
  }
}
