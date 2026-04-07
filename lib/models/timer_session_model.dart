class TimerSessionModel {
  final String id;
  final String userId;
  final String sessionType; // 'focus' or 'break'
  final int durationMins;
  final DateTime? createdAt;

  TimerSessionModel({
    required this.id,
    required this.userId,
    required this.sessionType,
    required this.durationMins,
    this.createdAt,
  });

  factory TimerSessionModel.fromJson(Map<String, dynamic> json) {
    return TimerSessionModel(
      id: json['id'],
      userId: json['user_id'],
      sessionType: json['session_type'],
      durationMins: json['duration_mins'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'session_type': sessionType,
      'duration_mins': durationMins,
    };
  }
}
