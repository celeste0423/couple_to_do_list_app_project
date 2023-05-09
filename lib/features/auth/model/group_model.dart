import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String? manUid;
  final String? womanUid;
  final String? uid;
  final DateTime? dayMet;

  GroupModel({
    this.manUid,
    this.womanUid,
    this.uid,
    this.dayMet,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      manUid: json['uid'] == null ? null : json['uid'] as String,
      womanUid: json['nickname'] == null ? null : json['nickname'] as String,
      uid: json['email'] == null ? null : json['email'] as String,
      dayMet: json['dayMet'] == null
          ? null
          : (json['dayMet'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': manUid,
      'nickname': womanUid,
      'email': uid,
      'dayMet': dayMet,
    };
  }
}
