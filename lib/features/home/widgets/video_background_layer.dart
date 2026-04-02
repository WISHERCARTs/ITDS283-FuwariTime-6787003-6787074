import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import '../services/background_controller.dart';

class VideoBackgroundLayer extends StatelessWidget {
  final PageController pageController;
  final Widget child;

  const VideoBackgroundLayer({
    super.key,
    required this.pageController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // ใช้ Consumer เพื่อดักฟังการเปลี่ยนวิดีโอจาก BackgroundController ทันทีที่กดปุ่ม
    return Consumer<BackgroundController>(
      builder: (context, bgController, _) {
        return Stack(
          children: [
            // 1. เลเยอร์วิดีโอพื้นหลัง (ใช้ AnimatedSwitcher เพื่อความเรียบเนียนเวลาเปลี่ยนวิดีโอ)
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000), // ค่อยๆ Fade 1 วินาที
                child: _VideoPlayerItem(
                  // ใช้ Key เพื่อให้ระบบรู้ว่าถ้า Path เปลี่ยน ต้องสร้างพระเอกตัวใหม่มาวาง
                  key: ValueKey(bgController.currentVideoPath),
                  videoPath: bgController.currentVideoPath,
                  pageController: pageController,
                ),
              ),
            ),
            
            // 2. เลเยอร์เนื้อหา (พวกปุ่มและ To-Do)
            child,
          ],
        );
      },
    );
  }
}

/// Widget ย่อยสำหรับจัดการ VideoPlayerController ของวิดีดโอแต่ละไฟล์
class _VideoPlayerItem extends StatefulWidget {
  final String videoPath;
  final PageController pageController;

  const _VideoPlayerItem({
    super.key,
    required this.videoPath,
    required this.pageController,
  });

  @override
  State<_VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<_VideoPlayerItem> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _controller.setLooping(true);
            _controller.play();
            _controller.setVolume(0);
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.pageController,
      builder: (context, _) {
        // คำนวณ Alignment ของวิดีโอตามหน้าปัจจุบัน (0, 1, 2)
        double page = 1.0;
        if (widget.pageController.hasClients) {
          page = widget.pageController.page ?? 1.0;
        }
        final alignmentX = (page - 1.0);

        return Container(
          color: Colors.black,
          child: _isInitialized
              ? FractionallySizedBox(
                  widthFactor: 2.0, // กว้างเป็น 2 เท่าสำหรับ Panorama
                  heightFactor: 1.0,
                  alignment: Alignment(alignmentX, 0),
                  child: VideoPlayer(_controller),
                )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
