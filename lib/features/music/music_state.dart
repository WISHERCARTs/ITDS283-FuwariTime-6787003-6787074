import 'package:flutter/material.dart';

// 💡 สร้างสวิตช์ส่วนกลาง ค่าเริ่มต้นเป็น false (ยังไม่โชว์แถบเพลง)
final ValueNotifier<bool> isMusicBarVisible = ValueNotifier(false);

// 💡 (แถม) ตัวแปรเก็บชื่อเพลงที่กำลังเล่นอยู่ตอนนี้
final ValueNotifier<String> currentSongTitle = ValueNotifier("No Song Playing");