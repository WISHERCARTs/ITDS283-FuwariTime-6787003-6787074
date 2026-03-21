import 'package:flutter/material.dart';

/// หน้า Task Planner / Work Zone (หน้าซ้ายสุด)
/// ใช้สำหรับจัดการ To-Do list และแสดงผลความสำเร็จ (Recent Achievements)
class TaskPlannerPage extends StatelessWidget {
  const TaskPlannerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/3wq8cvs8_expires_30_days.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.only(top: 140, left: 24, right: 24), // Push down below TopBar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recent Achievements Card
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFFFFFFFF),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 15,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Recent Achievements",
                      style: TextStyle(
                        color: Color(0xFF1F2937),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          begin: Alignment(-1, -1),
                          end: Alignment(-1, 1),
                          colors: [
                            Color(0x33E4D4F4),
                            Color(0x33FFD6E8),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.only(right: 16),
                            width: 48,
                            height: 48,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/mhigfhlt_expires_30_days.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "First Week!",
                                  style: TextStyle(
                                    color: Color(0xFF1F2937),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Complete 7 days streak",
                                  style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            "+100",
                            style: TextStyle(
                              color: Color(0xFFC8B8E6),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              // Arrow Icon (Right pointing to Center page)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.network(
                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/zG8hWyVkYp/r1xmywj6_expires_30_days.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(height: 160), // Space for music player and bottom nav
            ],
          ),
        ),
      ),
    );
  }
}
