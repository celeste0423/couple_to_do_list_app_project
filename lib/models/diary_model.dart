import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';
class DiaryModel {
  final String? title;
  final String? category;
  final String? location;
  final List<String>? imgUrlList;
  final String? mySogam;
  final String? bukkungSogam;
  final DateTime? date;
  final String? creatorUserID;
  final DateTime? createdAt;
  final String? lastUpdatorID;
  final DateTime? updatedAt;

  DiaryModel({
    this.title,
    this.category,
    this.location,
    this.imgUrlList,
    this.mySogam,
    this.bukkungSogam,
    this.date,
    this.creatorUserID,
    this.createdAt,
    this.lastUpdatorID,
    this.updatedAt,
  });

  factory DiaryModel.init(UserModel userInfo) {
    return DiaryModel(
      title: '',
      category: '',
      location: '',
      imgUrlList: [],
      mySogam: '',
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
      title: json['title'] == null ? null : json['title'] as String,
      category: json['category'] == null ? null : json['category'] as String,
      location: json['location'] == null ? null : json['location'] as String,
      imgUrlList: json['imgUrlList'] == null
          ? []
          : List<String>.from(json['imgUrlList'] as List<dynamic>),
      mySogam: json['mySogam'] == null ? null : json['mySogam'] as String,
      bukkungSogam:
      json['bukkungSogam'] == null ? null : json['bukkungSogam'] as String,
      date: json['date'] == null ? null : (json['date'] as Timestamp).toDate(),
      creatorUserID: json['creatorUserID'] == null ? null : json['creatorUserID'] as String,
      createdAt: json['createdAt'] == null ? null : (json['createdAt'] as Timestamp).toDate(),
      lastUpdatorID: json['lastUpdatorID'] == null ? null : json['lastUpdatorID'] as String,
      updatedAt: json['updatedAt'] == null ? null : (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'location': location,
      'imgUrlList': imgUrlList,
      'mySogam': mySogam,
      'bukkungSogam': bukkungSogam,
      'date': date,
      'creatorUserID': creatorUserID,
      'createdAt': createdAt,
      'lastUpdatorID': lastUpdatorID,
      'updatedAt': updatedAt,
    };
  }

  DiaryModel copyWith({
    String? title,
    String? category,
    String? location,
    List<String>? imgUrlList,
    String? mySogam,
    String? bukkungSogam,
    DateTime? date,
    String? creatorUserID,
    DateTime? createdAt,
    String? lastUpdatorID,
    DateTime? updatedAt,
  }) {
    return DiaryModel(
      title: title ?? this.title,
      category: category ?? this.category,
      location: location ?? this.location,
      imgUrlList: imgUrlList ?? this.imgUrlList??[],
      mySogam: mySogam ?? this.mySogam,
      bukkungSogam: bukkungSogam ?? this.bukkungSogam,
      date: date ?? this.date,
      creatorUserID: creatorUserID ?? this.creatorUserID,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatorID: lastUpdatorID ?? this.lastUpdatorID,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
