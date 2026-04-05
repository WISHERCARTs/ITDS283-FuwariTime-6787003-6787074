import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';
import 'package:fuwari_time/features/home/widgets/top_bar.dart';
import 'package:fuwari_time/features/home/widgets/pomodoro_timer_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/profile_service.dart';
import '../../models/profile_model.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final ProfileService _profileService = ProfileService();
  final TextEditingController _usernameController = TextEditingController();

  String userEmail = 'Loading...';
  bool _isSaving = false;
  bool _isEditing = false; // 🚀 เพิ่มโหมดแก้ไข
  bool _isPasswordVisible = false; // 👁️ สถานะการมองเห็นรหัสผ่าน

  File? _profileImage;
  final String _defaultImageUrl =
      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/anfl69ph_expires_30_days.png";

  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  // 💡 ฟังก์ชันดึงข้อมูลจาก Supabase
  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() {
      userEmail = user.email ?? 'No email found';
    });

    // โหลดครั้งแรกเท่านั้น เพื่อให้มีข้อมูลเริ่มต้นใน Controller
    final profile = await _profileService.getProfile(user.id);
    if (profile != null && !_isEditing) {
      _usernameController.text = profile.username ?? '';
    }
  }

  // ฟังก์ชันบันทึกชื่อใหม่
  Future<void> _saveProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);

    try {
      // ดึงค่าโปรไฟล์ล่าสุดมาเพื่อรักษาแต้มไว้
      final profile = await _profileService.getProfile(user.id);

      final updatedProfile = ProfileModel(
        id: user.id,
        username: _usernameController.text,
        points: profile?.points ?? 0,
        avatarUrl: profile?.avatarUrl,
      );

      await _profileService.updateProfile(updatedProfile);

      setState(() {
        _isSaving = false;
        _isEditing = false; // ปิดโหมดแก้ไขเมื่อเซฟเสร็จ
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
    // 🚀 ใช้ select เฝ้าดูเฉพาะสถานะ ไม่ rebuild ทุกวินาที
    final pomodoroState = context.select<PomodoroController, PomodoroState>(
      (c) => c.state,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _currentUserId != null
            ? Supabase.instance.client
                .from('profiles')
                .stream(primaryKey: ['id'])
                .eq('id', _currentUserId!)
            : null,
        builder: (context, snapshot) {
          // ดึงข้อมูลจาก Stream
          Map<String, dynamic>? profileData;
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            profileData = snapshot.data!.first;

            // 🚀 อัปเดตชื่อใน Controller เฉพาะตอนที่ไม่ได้กำลังแก้ไขอยู่
            if (!_isEditing) {
              _usernameController.text = profileData['username'] ?? '';
            }
          }

          final int points = profileData?['points'] ?? 0;
          final topPadding = MediaQuery.of(context).padding.top;

          return Stack(
            children: [
              // 1. เนื้อหาหลักของหน้า Profile (เลื่อนได้)
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: topPadding + 80), // 🚀 เว้นที่ให้ TopBar แบบไดนามิก
                    _buildProfileImagePicker(),
                    const SizedBox(height: 10),
                    // 💰 แต้มพ้อยท์
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF9C3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/siq2ut46_expires_30_days.png",
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "$points Points",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFA16207),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoSection(),
                    const SizedBox(height: 20),
                    if (_isEditing) _buildEditButtons(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // 2. แถบเมนูด้านบน (Top Bar - นิ่งอยูากับที่)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: TopBar(currentIndex: 3),
              ),

              // 3. 🕒 Mini Timer (ลอยทับหน้า Profile เมื่อรันอยู่)
              if (pomodoroState == PomodoroState.running)
                Positioned(
                  top: 150,
                  right: 20,
                  child: Consumer<PomodoroController>(
                    builder: (context, controller, _) =>
                        PomodoroMiniTimer(controller: controller),
                  ),
                ),

              // 4. ⚙️ Settings Overlay
              if (pomodoroState == PomodoroState.expanded)
                Consumer<PomodoroController>(
                  builder: (context, controller, _) => Positioned.fill(
                    child: PomodoroExpandedOverlay(controller: controller),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEditButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => setState(() => _isEditing = false),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                side: const BorderSide(color: Color(0xFF8B5CF6)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Cancel"),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "General Info",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                onPressed: () => setState(() => _isEditing = !_isEditing),
                icon: Icon(
                  _isEditing ? Icons.close : Icons.edit_rounded,
                  size: 20,
                  color: const Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildInfoItem(
            child: TextField(
              controller: _usernameController,
              enabled: _isEditing, // 🚀 ปลดล็อกเฉพาะตอนแก้ไข
              decoration: const InputDecoration(
                labelText: "Username",
                hintText: "Enter your name",
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 10),
          _buildInfoItem(
            child: Text(
              "Email: $userEmail",
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 10),
          _buildInfoItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _isPasswordVisible ? "Password: MySecurePassword123" : "Password: ••••••••",
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    size: 20,
                    color: const Color(0xFF8B5CF6),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
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
        border: _isEditing && child is TextField
            ? Border.all(color: const Color(0xFF8B5CF6), width: 1)
            : null,
      ),
      child: child,
    );
  }
}
