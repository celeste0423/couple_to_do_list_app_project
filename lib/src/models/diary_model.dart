import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/src/models/user_model.dart';

class DiaryModel {
  final String? diaryId; // Added property
  final String? title;
  final String? category;
  final String? location;
  final List<String>? imgUrlList;
  final String? creatorSogam;
  final String? bukkungSogam;
  final DateTime? date;
  final String? creatorUserID;
  final DateTime? createdAt;
  final String? lastUpdatorID;
  final DateTime? updatedAt;

  DiaryModel({
    this.diaryId,
    this.title,
    this.category,
    this.location,
    this.imgUrlList,
    this.creatorSogam,
    this.bukkungSogam,
    this.date,
    this.creatorUserID,
    this.createdAt,
    this.lastUpdatorID,
    this.updatedAt,
  });

  factory DiaryModel.init(UserModel userInfo) {
    return DiaryModel(
      diaryId: null,
      title: '',
      category: '',
      location: '',
      imgUrlList: [],
      creatorSogam: '',
      bukkungSogam: '',
      date: DateTime.now(),
      creatorUserID: userInfo.uid,
      createdAt: DateTime.now(),
      lastUpdatorID: '',
      updatedAt: DateTime.now(),
    );
  }

  factory DiaryModel.fromJson(Map<String, dynamic> json) {
    return DiaryModel(
      diaryId: json['diaryId'] == null ? null : json['diaryId'] as String,
      title: json['title'] == null ? null : json['title'] as String,
      category: json['category'] == null ? null : json['category'] as String,
      location: json['location'] == null ? null : json['location'] as String,
      imgUrlList: json['imgUrlList'] == null
          ? []
          : List<String>.from(json['imgUrlList'] as List<dynamic>),
      creatorSogam:
          json['creatorSogam'] == null ? null : json['creatorSogam'] as String,
      bukkungSogam:
          json['bukkungSogam'] == null ? null : json['bukkungSogam'] as String,
      date: json['date'] == null ? null : (json['date'] as Timestamp).toDate(),
      creatorUserID: json['creatorUserID'] == null
          ? null
          : json['creatorUserID'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : (json['createdAt'] as Timestamp).toDate(),
      lastUpdatorID: json['lastUpdatorID'] == null
          ? null
          : json['lastUpdatorID'] as String,
      updatedAt: json['updatedAt'] == null
          ? null
          : (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diaryId': diaryId,
      'title': title,
      'category': category,
      'location': location,
      'imgUrlList': imgUrlList,
      'creatorSogam': creatorSogam,
      'bukkungSogam': bukkungSogam,
      'date': date,
      'creatorUserID': creatorUserID,
      'createdAt': createdAt,
      'lastUpdatorID': lastUpdatorID,
      'updatedAt': updatedAt,
    };
  }

  DiaryModel copyWith({
    String? diaryId,
    String? title,
    String? category,
    String? location,
    List<String>? imgUrlList,
    String? creatorSogam,
    String? bukkungSogam,
    DateTime? date,
    String? creatorUserID,
    DateTime? createdAt,
    String? lastUpdatorID,
    DateTime? updatedAt,
  }) {
    return DiaryModel(
      diaryId: diaryId ?? this.diaryId,
      title: title ?? this.title,
      category: category ?? this.category,
      location: location ?? this.location,
      imgUrlList: imgUrlList ?? this.imgUrlList ?? [],
      creatorSogam: creatorSogam ?? this.creatorSogam,
      bukkungSogam: bukkungSogam ?? this.bukkungSogam,
      date: date ?? this.date,
      creatorUserID: creatorUserID ?? this.creatorUserID,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatorID: lastUpdatorID ?? this.lastUpdatorID,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool isEmptyDiary() {
    return diaryId == null &&
        title == null &&
        category == null &&
        location == null &&
        imgUrlList == null &&
        creatorSogam == null &&
        bukkungSogam == null &&
        date == null &&
        creatorUserID == null &&
        createdAt == null &&
        lastUpdatorID == null &&
        updatedAt == null;
  }

  // DiaryModel copyDiaryModel(DiaryModel other) {
  //   return DiaryModel(
  //     diaryId: other.diaryId,
  //     title: other.title,
  //     category: other.category,
  //     location: other.location,
  //     imgUrlList: List.from(other.imgUrlList ?? []),
  //     creatorSogam: other.creatorSogam,
  //     bukkungSogam: other.bukkungSogam,
  //     date: other.date,
  //     creatorUserID: other.creatorUserID,
  //     createdAt: other.createdAt,
  //     lastUpdatorID: other.lastUpdatorID,
  //     updatedAt: other.updatedAt,
  //   );
  // }
}
