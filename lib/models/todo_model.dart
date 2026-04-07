class TodoModel {
  final String id;
  final String userId;
  final String title;
  final bool isCompleted;
  final DateTime? createdAt;

  TodoModel({
    required this.id,
    required this.userId,
    required this.title,
    this.isCompleted = false,
    this.createdAt,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      isCompleted: json['is_completed'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'is_completed': isCompleted,
    };
  }
}
