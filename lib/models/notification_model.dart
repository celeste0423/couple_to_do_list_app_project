import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String notificationId;
  final String? title;
  final String? type;
  final String? content;
  final String? contentId;
  final bool isChecked;
  final DateTime createdAt;

  NotificationModel({
    required this.notificationId,
    this.title,
    this.type,
    this.content,
    this.contentId,
    required this.isChecked,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notification_id'] as String,
      title: json['title'] == null ? null : json['title'] as String,
      type: json['type'] == null ? null : json['type'] as String,
      content: json['content'] == null ? null : json['content'] as String,
      contentId:
          json['content_id'] == null ? null : json['content_id'] as String,
      isChecked: json['is_checked'] ?? false,
      createdAt: (json['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_id': notificationId,
      'title': title,
      'type': type,
      'content': content,
      'content_id': contentId,
      'is_checked': isChecked,
      'created_at': createdAt,
    };
  }

  NotificationModel copyWith({
    String? notificationId,
    String? title,
    String? type,
    String? content,
    String? contentId,
    bool? isChecked,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      type: type ?? this.type,
      content: content ?? this.content,
      contentId: contentId ?? this.contentId,
      isChecked: isChecked ?? this.isChecked,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
