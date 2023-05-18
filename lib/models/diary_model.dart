import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryModel {
  final String? title;
  final String? category;
  final String? location;
  final String? imgUrl1;
  final String? imgUrl2;
  final String? imgUrl3;
  final String? imgUrl4;
  final String? mySogam;
  final String? bukkungSogam;
  final DateTime? startDate;
  final DateTime? endDate;

  DiaryModel({
    this.title,
    this.category,
    this.location,
    this.imgUrl1,
    this.imgUrl2,
    this.imgUrl3,
    this.imgUrl4,
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
      imgUrl1: json['imgUrl1'] == null ? null : json['imgUrl1'] as String,
      imgUrl2: json['imgUrl2'] == null ? null : json['imgUrl2'] as String,
      imgUrl3: json['imgUrl3'] == null ? null : json['imgUrl3'] as String,
      imgUrl4: json['imgUrl4'] == null ? null : json['imgUrl4'] as String,
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
      'imgUrl1': imgUrl1,
      'imgUrl2': imgUrl2,
      'imgUrl3': imgUrl3,
      'imgUrl4': imgUrl4,
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
    String? imgUrl1,
    String? imgUrl2,
    String? imgUrl3,
    String? imgUrl4,
    String? mySogam,
    String? bukkungSogam,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return DiaryModel(
      title: title ?? this.title,
      category: category ?? this.category,
      location: location ?? this.location,
      imgUrl1: imgUrl1 ?? this.imgUrl1,
      imgUrl2: imgUrl2 ?? this.imgUrl2,
      imgUrl3: imgUrl3 ?? this.imgUrl3,
      imgUrl4: imgUrl4 ?? this.imgUrl4,
      mySogam: mySogam ?? this.mySogam,
      bukkungSogam: bukkungSogam ?? this.bukkungSogam,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
