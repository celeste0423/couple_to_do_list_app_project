import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String? maleUid;
  final String? femaleUid;
  final String? uid;
  final DateTime? createdAt;
  final DateTime? dayMet;

  GroupModel({
    this.maleUid,
    this.femaleUid,
    this.uid,
    this.createdAt,
    this.dayMet,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      maleUid: json['maleUid'] == null ? null : json['mailUid'] as String,
      femaleUid: json['femaleUid'] == null ? null : json['femaleUid'] as String,
      uid: json['uid'] == null ? null : json['uid'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : (json['createdAt'] as Timestamp).toDate(),
      dayMet: json['dayMet'] == null
          ? null
          : (json['dayMet'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maleUid': maleUid,
      'femaleUid': femaleUid,
      'uid': uid,
      'createdAt': createdAt,
      'dayMet': dayMet,
    };
  }
}
