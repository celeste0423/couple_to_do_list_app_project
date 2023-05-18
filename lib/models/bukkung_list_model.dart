import 'package:cloud_firestore/cloud_firestore.dart';

class BukkungListModel {
  final String? category;
  final String? title;
  final String? content;
  final String? location;
  final String? imgUrl;
  final int? likeCount;
  final DateTime? date;

  BukkungListModel({
    this.category,
    this.title,
    this.content,
    this.location,
    this.imgUrl,
    this.likeCount,
    this.date,
  });

  factory BukkungListModel.fromJson(Map<String, dynamic> json) {
    return BukkungListModel(
      category: json['category'] == null ? null : json['category'] as String,
      title: json['title'] == null ? null : json['title'] as String,
      content: json['content'] == null ? null : json['content'] as String,
      location: json['location'] == null ? null : json['location'] as String,
      imgUrl: json['imgUrl'] == null ? null : json['imgUrl'] as String,
      likeCount: json['likeCount'] == null ? 0 : json['likeCount'] as int,
      date: json['date'] == null
          ? DateTime.now()
          : (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'title': title,
      'content': content,
      'location': location,
      'imgUrl': imgUrl,
      'likeCount': likeCount,
      'date': date,
    };
  }

  BukkungListModel copyWith({
    String? category,
    String? title,
    String? content,
    String? location,
    String? imgUrl,
    int? likeCount,
    DateTime? date,
  }) {
    return BukkungListModel(
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      location: location ?? this.location,
      imgUrl: imgUrl ?? this.imgUrl,
      likeCount: likeCount ?? this.likeCount,
      date: date ?? this.date,
    );
  }
}
