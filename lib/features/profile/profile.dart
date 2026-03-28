import 'dart:io'; // 💡 สำหรับจัดการไฟล์รูปในเครื่อง
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 💡 แพ็กเกจเลือกรูปภาพ
import 'package:fuwari_time/features/home/screens/home_screen.dart'; // 💡 นำเข้า HomeScreen เพื่อใช้เป็นหน้าเริ่มต้น (ถ้าต้องการ)
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  String username = '';
  
  // 💡 ตัวแปรเก็บไฟล์รูปภาพที่เลือกใหม่ (อาจจะเป็น null ถ้ายังไม่ได้เลือก)
  File? _profileImage;
  
  // 💡 ลิงก์รูปภาพเริ่มต้น (Default) ถ้ายังไม่ได้เลือกรูป
  final String _defaultImageUrl = "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/anfl69ph_expires_30_days.png";

  // 💡 ฟังก์ชันเปิดแกลเลอรี่เพื่อเลือกรูปภาพ
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // เลือกรูปภาพจากแกลเลอรี่ (ถ้าต้องการเปิดกล้องให้เปลี่ยนเป็น ImageSource.camera)
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // อัปเดตสถานะ (setState) เพื่อแสดงรูปภาพใหม่บนหน้าจอ
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      print('Selected image path: ${pickedFile.path}');
      // TODO: คุณสามารถสั่งอัปโหลดไฟล์รูปนี้ไปยัง Supabase Storage ตรงนี้ได้
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3), //highlight icon profile
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              const TopBar(),
              // ===========================================
              // 💡 ส่วนที่ 2: รูปโปรไฟล์ (แก้ไขเพื่อให้เลือกได้)
              // ===========================================
              _buildProfileImagePicker(), 
              
              const SizedBox(height: 30),
              _buildInfoSection(), // ฟอร์มข้อมูล
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Header สี Gradient เหมือนเดิม
  // ==========================================
  

  // ===========================================
  // 💡 ส่วนย่อยที่ 2 (แก้ไขใหม่): รูปโปรไฟล์ที่มีปุ่มเลือกรูป
  // ===========================================
  Widget _buildProfileImagePicker() {
    return Stack(
      children: [
        // 1. ตัวแสดงรูปโปรไฟล์ (สลับระหว่างไฟล์ในเครื่องกับ URL)
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: _profileImage != null
              ? Image.file(
                  _profileImage!, // แสดงรูปที่ User เพิ่งเลือกมา
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  _defaultImageUrl, // แสดงรูปDefault ถ้ายังไม่ได้เลือก
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
        ),
        
        // 2. ปุ่มกล้องถ่ายรูปเล็กๆ แปะที่มุม (OnTop)
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: _pickImage, // เมื่อกด ให้เปิดแกลเลอรี่
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFD8B4FE), // สีม่วงอ่อน
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: const Icon(
                Icons.camera_alt_rounded, // ไอคอนกล้อง
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // กล่องข้อมูล User เหมือนเดิม
  // ==========================================
  Widget _buildInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFECD4F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoItem(
            child: TextField(
              onChanged: (value) => setState(() => username = value),
              decoration: const InputDecoration(
                hintText: "Username: Wishercart",
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 10),
          _buildInfoItem(
            child: const Text("Email: Wishnak@gmail.com", style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 10),
          _buildInfoItem(
            child: const Text("Password: xxxxx", style: TextStyle(fontSize: 18)),
          ),
        ],
          ),
    );
  }

  Widget _buildInfoItem({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}