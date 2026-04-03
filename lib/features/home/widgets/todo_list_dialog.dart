import 'package:flutter/material.dart';

/// Model สำหรับเก็บข้อมูล Task 1 งาน
class TodoItem {
  final String id;
  String title;
  bool isCompleted;

  TodoItem({required this.id, required this.title, this.isCompleted = false});
}

/// Controller จัดการเรื่อง Todo List
class TodoController extends ChangeNotifier {
  final List<TodoItem> _items = [
    // ข้อมูลจำลองสำหรับโชว์
    TodoItem(id: '1', title: 'Machine Learning', isCompleted: true),
    TodoItem(id: '2', title: 'IOT', isCompleted: false),
    TodoItem(id: '3', title: 'Mobile-App', isCompleted: false),
    TodoItem(id: '4', title: 'Discrete-Math', isCompleted: false),
  ];

  List<TodoItem> get items => _items;

  void addTask(String title) {
    if (title.trim().isEmpty) return;
    _items.add(
      TodoItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
      ),
    );
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].isCompleted = !_items[index].isCompleted;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void editTask(String id, String newTitle) {
    if (newTitle.trim().isEmpty) return;
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].title = newTitle;
      notifyListeners();
    }
  }
}

/// หน้าต่างแสดงผล Todo List
class TodoListOverlay extends StatelessWidget {
  final TodoController controller;
  final VoidCallback onDismiss;

  const TodoListOverlay({
    super.key,
    required this.controller,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss, // กดพื้นที่นอกหน้าต่าง เพื่อปิด
      child: Container(
        color: Colors.black26, // พื้นหลังมืดโปร่งใส
        child: Center(
          child: GestureDetector(
            onTap: () {}, // ป้องกันไม่ให้กดทะลุตัวหน้าต่างนี้
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: _buildTodoCard(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodoCard(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // พื้นหลังการ์ดสีม่วงอ่อนอมเทา (คล้ายในดีไซน์)
        Container(
          width: 280,
          height: 400,
          margin: const EdgeInsets.only(
            top: 20,
            left: 20,
          ), // เว้นที่ให้ไอคอนกระดาษลอย
          decoration: BoxDecoration(
            color: const Color(0xFFDDCCCE), // สีพาสเทลตามรูป
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 24), // เว้นที่ด้านบน
              // === คำว่า TODO แถวบน ===
              const Text(
                "TODO",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              // === ปุ่ม + Newtask ===
              GestureDetector(
                onTap: () => _showAddTaskDialog(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFE5E5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 16,
                        color: Colors.grey.shade800,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Newtask",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // === รายการ Tasks (Scrollable ListView) ===
              Expanded(
                child: ListenableBuilder(
                  listenable: controller,
                  builder: (context, _) {
                    if (controller.items.isEmpty) {
                      return const Center(
                        child: Text(
                          "ไม่มีงานค้างเลย เก่งมาก!",
                          style: TextStyle(color: Colors.black54),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: controller.items.length,
                      itemBuilder: (context, index) {
                        final item = controller.items[index];
                        return _buildTaskRow(context, item);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // === ไอคอนกระดาษม่วงสีสด (รอยอยู่มุมซ้ายบน) ===
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6), // สีม่วงสด
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.description_rounded, // ไอคอนกระดาษ
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }

  /// แถบรายการ 1 แถว (Checkbox + ข้อความ + ลบ)
  Widget _buildTaskRow(BuildContext context, TodoItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // 1. Checkbox
          GestureDetector(
            onTap: () => controller.toggleTask(item.id),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFEFE5E5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: item.isCompleted
                  ? const Center(
                      child: Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: Colors.green, // ติ๊กถูกสีเขียวตามรูป
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          // 2. ชื่อ Task (ถ้าเสร็จแล้ว มีขีดฆ่า) - สามารถกดเพื่อแก้ไขได้
          Expanded(
            child: GestureDetector(
              onTap: () => _showEditTaskDialog(context, item),
              child: Container(
                color: Colors.transparent, // ให้พื้นที่โปร่งใสรับการกดได้หมด
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14,
                    color: item.isCompleted ? Colors.black54 : Colors.black87,
                    decoration: item.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 3. ปุ่มกากบาท ลบงาน
          GestureDetector(
            onTap: () => controller.deleteTask(item.id),
            child: const Icon(
              Icons.close_rounded,
              size: 20,
              color: Colors.redAccent, // กากบาทแดงตามรูป
            ),
          ),
        ],
      ),
    );
  }

  /// Dialog พิมพ์เพิ่มงานใหม่
  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController textCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFFE9D4F1),
          title: const Text("Add New Task"),
          content: TextField(
            controller: textCtrl,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Enter task name...",
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            onSubmitted: (value) {
              controller.addTask(value);
              Navigator.pop(ctx);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                controller.addTask(textCtrl.text);
                Navigator.pop(ctx);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  /// Dialog สำหรับแก้ไขงานเดิม
  void _showEditTaskDialog(BuildContext context, TodoItem item) {
    final TextEditingController textCtrl = TextEditingController(
      text: item.title,
    );
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFFE9D4F1),
          title: const Text("Edit Task"),
          content: TextField(
            controller: textCtrl,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Enter new task name...",
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            onSubmitted: (value) {
              controller.editTask(item.id, value);
              Navigator.pop(ctx);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                controller.editTask(item.id, textCtrl.text);
                Navigator.pop(ctx);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
