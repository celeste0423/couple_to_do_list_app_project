import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryModel {
  final String? title;
  final String? category;
  final String? location;
  final List<String>? imgUrlList;
  final String? mySogam;
  final String? bukkungSogam;
  final DateTime? startDate;
  final DateTime? endDate;

  DiaryModel({
    this.title,
    this.category,
    this.location,
    this.imgUrlList,
    this.mySogam,
    this.bukkungSogam,
    this.startDate,
    this.endDate,
  });

  factory DiaryModel.fromJson(Map<String, dynamic> json) {
    return DiaryModel(
      title: json['title'] == null ? null : json['title'] as String,
      category: json['category'] == null ? null : json['category'] as String,
      location: json['location'] == null ? null : json['location'] as String,
      imgUrlList: json['imgUrlList'] == null
          ? null
          : List<String>.from(json['imgUrlList'] as List<dynamic>),
      mySogam: json['mySogam'] == null ? null : json['mySogam'] as String,
      bukkungSogam:
      json['bukkungSogam'] == null ? null : json['bukkungSogam'] as String,
      startDate: json['startDate'] == null
          ? null
          : (json['startDate'] as Timestamp).toDate(),
      endDate: json['endDate'] == null
          ? null
          : (json['endDate'] as Timestamp).toDate(),
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
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  DiaryModel copyWith({
    String? title,
    String? category,
    String? location,
    List<String>? imgUrlList,
    String? mySogam,
    String? bukkungSogam,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return DiaryModel(
      title: title ?? this.title,
      category: category ?? this.category,
      location: location ?? this.location,
      imgUrlList: imgUrlList ?? this.imgUrlList,
      mySogam: mySogam ?? this.mySogam,
      bukkungSogam: bukkungSogam ?? this.bukkungSogam,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
