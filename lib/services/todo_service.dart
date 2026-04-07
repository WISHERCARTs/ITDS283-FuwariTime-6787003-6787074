import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/todo_model.dart';

class TodoService {
  final _supabase = Supabase.instance.client;

  // ดึงรายการ Todo ทั้งหมดของ User
  Future<List<TodoModel>> getTodos(String userId) async {
    try {
      final List<Map<String, dynamic>> response = await _supabase
          .from('todos')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return response.map((data) => TodoModel.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching todos: $e');
      return [];
    }
  }

  // เพิ่ม Todo ใหม่
  Future<TodoModel?> addTodo(String userId, String title) async {
    try {
      final response = await _supabase
          .from('todos')
          .insert({'user_id': userId, 'title': title})
          .select()
          .single();
      return TodoModel.fromJson(response);
    } catch (e) {
      print('Error adding todo: $e');
      return null;
    }
  }

  // สลับสถานะเสร็จ/ยังไม่เสร็จ
  Future<void> toggleTodo(String todoId, bool isCompleted) async {
    try {
      await _supabase
          .from('todos')
          .update({'is_completed': isCompleted})
          .eq('id', todoId);
    } catch (e) {
      print('Error toggling todo: $e');
    }
  }

  // แก้ไขชื่องาน
  Future<void> updateTodo(String todoId, String newTitle) async {
    try {
      await _supabase
          .from('todos')
          .update({'title': newTitle})
          .eq('id', todoId);
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  // ลบ Todo
  Future<void> deleteTodo(String todoId) async {
    try {
      await _supabase.from('todos').delete().eq('id', todoId);
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }
}
