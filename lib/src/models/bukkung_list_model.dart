import 'package:cloud_firestore/cloud_firestore.dart';

class BukkungListModel {
  final String? listId;
  final String? category;
  final String? title;
  final String? content;
  final String? location;
  final String? imgUrl;
  final String? imgId;
  // int? likeCount;
  final int? viewCount;
  final int? copyCount;
  final DateTime? date;
  final String? madeBy;
  final String? userId;
  final String? groupId;
  final bool? isCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // final List<String>? likedUsers;

  BukkungListModel({
    this.listId,
    this.category,
    this.title,
    this.content,
    this.location,
    this.imgUrl,
    this.imgId,
    // this.likeCount = 0,
    this.viewCount,
    this.copyCount,
    this.date,
    this.madeBy,
    this.userId,
    this.groupId,
    this.isCompleted,
    this.createdAt,
    this.updatedAt,
    // this.likedUsers,
  });

  // factory BukkungListModel.init(UserModel userInfo) {
  //   return BukkungListModel(
  //     listId: '',
  //     category: '',
  //     title: '',
  //     content: '',
  //     location: '',
  //     imgUrl: null,
  //     imgId: null,
  //     // likeCount: 0,
  //     viewCount: null,
  //     copyCount: null,
  //     date: null,
  //     madeBy: userInfo.nickname,
  //     userId: userInfo.uid,
  //     groupId: userInfo.groupId,
  //     createdAt: DateTime.now(),
  //     updatedAt: null,
  //     likedUsers: [],
  //   );
  // }

  factory BukkungListModel.fromJson(Map<String, dynamic> json) {
    return BukkungListModel(
      listId: json['listId'] == null ? null : json['listId'] as String,
      category: json['category'] == null ? null : json['category'] as String,
      title: json['title'] == null ? null : json['title'] as String,
      content: json['content'] == null ? null : json['content'] as String,
      location: json['location'] == null ? null : json['location'] as String,
      imgUrl: json['imgUrl'] == null ? null : json['imgUrl'] as String,
      imgId: json['imgId'] == null ? null : json['imgId'] as String,
      // likeCount: json['likeCount'] == null ? 0 : json['likeCount'] as int,
      viewCount: json['viewCount'] == null ? 0 : json['viewCount'] as int,
      copyCount: json['copyCount'] == null ? 0 : json['copyCount'] as int,
      date: json['date'] == null ? null : (json['date'] as Timestamp).toDate(),
      madeBy: json['madeBy'] == null ? null : json['madeBy'] as String,
      userId: json['userId'] == null ? null : json['userId'] as String,
      groupId: json['groupId'] == null ? null : json['groupId'] as String,
      isCompleted:
          json['isCompleted'] == null ? null : json['isCompleted'] as bool,
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : json['createdAt'].toDate(),
      updatedAt: json['updatedAt'] == null ? null : json['createdAt'].toDate(),
      // likedUsers: json['likedUsers'] != null
      //     ? List<String>.from(json['likedUsers'] as List<dynamic>)
      //     : null,
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
      'imgId': imgId,
      // 'likeCount': likeCount,
      'viewCount': viewCount,
      'copyCount': copyCount,
      'date': date,
      'madeBy': madeBy,
      'userId': userId,
      'groupId': groupId,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      // 'likedUsers': likedUsers,
    };
  }

  BukkungListModel copyWith({
    String? listId,
    String? category,
    String? title,
    String? content,
    String? location,
    String? imgUrl,
    String? imgId,
    // int? likeCount,
    int? viewCount,
    int? copyCount,
    DateTime? date,
    String? madeBy,
    String? userId,
    String? groupId,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    // List<String>? likedUsers,
  }) {
    //print('날짜 받는중 model $date');
    return BukkungListModel(
      listId: listId ?? this.listId,
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      location: location ?? this.location,
      imgUrl: imgUrl ?? this.imgUrl,
      imgId: imgId ?? this.imgId,
      // likeCount: likeCount ?? this.likeCount,
      viewCount: viewCount ?? this.viewCount,
      copyCount: copyCount ?? this.copyCount,
      date: date,
      madeBy: madeBy ?? this.madeBy,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.createdAt,
      // likedUsers: likedUsers,
    );
  }
}
