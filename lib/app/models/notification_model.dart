class AppNotification {
  final int id;
  final String title;
  final String body;
  final String type;
  final String? image;
  final Map<String, dynamic>? data;
  final DateTime timestamp;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.image,
    this.data,
    required this.timestamp,
    this.isRead = false,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      type: type,
      image: image,
      data: data,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'image': image,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      image: json['image'],
      data: json['data'],
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      isRead: json['is_read'] ?? false,
    );
  }
}
