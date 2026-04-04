import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
// 🚀 1. Import Supabase เข้ามาเพื่อใช้ดึงข้อมูล User
import 'package:supabase_flutter/supabase_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  String username = '';
  
  // 🚀 2. สร้างตัวแปรไว้รอรับ Email จากฐานข้อมูล
  String userEmail = 'Loading...';

  File? _profileImage;
  final String _defaultImageUrl =
      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/anfl69ph_expires_30_days.png";

  // 🚀 3. ใช้ initState เพื่อดึงข้อมูลทันทีที่เปิดหน้านี้ขึ้นมา
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 💡 ฟังก์ชันดึงข้อมูลจาก Supabase
  void _loadUserData() {
    // ดึง User ปัจจุบันที่กำลังล็อกอินอยู่
    final user = Supabase.instance.client.auth.currentUser;
    setState(() {
      // ถ้าพบข้อมูล User ให้ดึง email มาใส่ตัวแปร แต่ถ้าหาไม่เจอให้แสดง 'No email found'
      userEmail = user?.email ?? 'No email found';
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      print('Selected image path: ${pickedFile.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 3,
      ), 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TopBar(currentIndex: 3),

              const SizedBox(height: 20),
              _buildProfileImagePicker(),

              const SizedBox(height: 30),
              _buildInfoSection(), 
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: _profileImage != null
              ? Image.file(
                  _profileImage!, 
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  _defaultImageUrl, 
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: _pickImage, 
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFD8B4FE), 
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt_rounded, 
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

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
            // 🚀 4. เอาตัวแปร userEmail มาแสดงผลแทนข้อความตายตัว
            child: Text(
              "Email: $userEmail",
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 10),
          _buildInfoItem(
            child: const Text(
              "Password: xxxxx",
              style: TextStyle(fontSize: 18),
            ),
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