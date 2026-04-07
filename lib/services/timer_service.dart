import 'package:supabase_flutter/supabase_flutter.dart';

class TimerService {
  final _supabase = Supabase.instance.client;

  // บันทึก Session หลังจากจับเวลาเสร็จ
  Future<void> saveSession({
    required String userId,
    required String type, // 'focus' or 'break'
    required int durationMins,
  }) async {
    try {
      await _supabase.from('timer_sessions').insert({
        'user_id': userId,
        'session_type': type,
        'duration_mins': durationMins,
      });
    } catch (e) {
      print('Error saving timer session: $e');
    }
  }

  // ดึงข้อมูลสถิติรวมของวันนี้ (สำหร้บหน้า Stats)
  Future<Map<String, double>> getTodayStats(String userId) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();

      final List<Map<String, dynamic>> response = await _supabase
          .from('timer_sessions')
          .select('session_type, duration_mins')
          .eq('user_id', userId)
          .gte('created_at', startOfDay);

      double focusTotal = 0;
      double breakTotal = 0;

      for (var item in response) {
        if (item['session_type'] == 'focus') {
          focusTotal += (item['duration_mins'] as int).toDouble();
        } else {
          breakTotal += (item['duration_mins'] as int).toDouble();
        }
      }

      // ส่งกลับคืนเป็นชั่วโมง (Divided by 60)
      return {
        'focus_hours': focusTotal / 60,
        'break_hours': breakTotal / 60,
      };
    } catch (e) {
      print('Error getting today stats: $e');
      return {'focus_hours': 0, 'break_hours': 0};
    }
  }
}
