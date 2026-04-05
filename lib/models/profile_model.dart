class ProfileModel {
  final String id;
  final String? username;
  final String? avatarUrl;
  final int points;
  final DateTime? updatedAt;

  ProfileModel({
    required this.id,
    this.username,
    this.avatarUrl,
    this.points = 0,
    this.updatedAt,
  });

  // แปลงจาก Map (ที่ได้จาก Supabase) มาเป็น Object
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      username: json['username'],
      avatarUrl: json['avatar_url'],
      points: json['points'] ?? 0,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  // แปลงจาก Object มาเป็น Map เพื่อส่งค่าไปเก็บใน Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar_url': avatarUrl,
      'points': points,
      // 'updated_at' ปกติให้ Database เจนให้เอง
    };
  }
}
