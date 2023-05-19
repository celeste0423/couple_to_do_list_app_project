import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';

class BukkungListModel {
  final String? listId;
  final String? category;
  final String? title;
  final String? content;
  final String? location;
  final String? imgUrl;
  final int? likeCount;
  final DateTime? date;
  final String? madeBy;
  final String? userId;
  final String? groupId;
  final DateTime? createdAt;

  BukkungListModel({
    this.listId,
    this.category,
    this.title,
    this.content,
    this.location,
    this.imgUrl,
    this.likeCount,
    this.date,
    this.madeBy,
    this.userId,
    this.groupId,
    this.createdAt,
  });

  factory BukkungListModel.init(UserModel userInfo) {
    var time = DateTime.now();
    return BukkungListModel(
      listId: '',
      category: '',
      title: '',
      content: '',
      location: '',
      imgUrl: null,
      likeCount: 0,
      date: time,
      madeBy: userInfo.nickname,
      userId: userInfo.uid,
      groupId: userInfo.groupId,
      createdAt: time,
    );
  }

  factory BukkungListModel.fromJson(Map<String, dynamic> json) {
    return BukkungListModel(
      listId: json['listId'] == null ? null : json['listId'] as String,
      category: json['category'] == null ? null : json['category'] as String,
      title: json['title'] == null ? null : json['title'] as String,
      content: json['content'] == null ? null : json['content'] as String,
      location: json['location'] == null ? null : json['location'] as String,
      imgUrl: json['imgUrl'] == null ? null : json['imgUrl'] as String,
      likeCount: json['likeCount'] == null ? 0 : json['likeCount'] as int,
      date: json['date'] == null
          ? DateTime.now()
          : (json['date'] as Timestamp).toDate(),
      madeBy: json['madeBy'] == null ? null : json['madeBy'] as String,
      userId: json['userId'] == null ? null : json['userId'] as String,
      groupId: json['groupId'] == null ? null : json['groupId'] as String,
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : json['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'listId': listId,
      'category': category,
      'title': title,
      'content': content,
      'location': location,
      'imgUrl': imgUrl,
      'likeCount': likeCount,
      'date': date,
      'madeBy': madeBy,
      'userId': userId,
      'groupId': groupId,
      'createdAt': createdAt,
    };
  }

  BukkungListModel copyWith({
    String? listId,
    String? category,
    String? title,
    String? content,
    String? location,
    String? imgUrl,
    int? likeCount,
    DateTime? date,
    String? madeBy,
    String? userId,
    String? groupId,
    DateTime? createdAt,
  }) {
    return BukkungListModel(
      listId: listId ?? this.listId,
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      location: location ?? this.location,
      imgUrl: imgUrl ?? this.imgUrl,
      likeCount: likeCount ?? this.likeCount,
      date: date ?? this.date,
      madeBy: madeBy ?? this.madeBy,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
