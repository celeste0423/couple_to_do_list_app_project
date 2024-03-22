import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentId;
  final String uid;
  final String nickname;
  final String comment;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CommentModel({
    required this.commentId,
    required this.uid,
    required this.nickname,
    required this.comment,
    required this.createdAt,
    this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['comment_id'] as String,
      uid: json['uid'] as String,
      nickname: json['nickname'] as String,
      comment: json['comment'] as String,
      createdAt: (json['created_at'] as Timestamp).toDate(),
      updatedAt: json['updated_at'] == null
          ? null
          : (json['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'uid': uid,
      'nickname': nickname,
      'comment': comment,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  CommentModel copyWith({
    String? commentId,
    String? uid,
    String? nickname,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
