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

  factory GroupModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return GroupModel(
      maleUid: data['maleUid'] as String?,
      femaleUid: data['femaleUid'] as String?,
      uid: data['uid'] as String?,
      createdAt: data['createdAt'] == null
          ? null
          : (data['createdAt'] as Timestamp).toDate(),
      dayMet: data['dayMet'] == null
          ? null
          : (data['dayMet'] as Timestamp).toDate(),
    );
  }

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      maleUid: json['maleUid'] == null ? null : json['maleUid'] as String,
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

  GroupModel copyWith({
    String? maleUid,
    String? femaleUid,
    String? uid,
    DateTime? createdAt,
    DateTime? dayMet,
  }) {
    return GroupModel(
      maleUid: maleUid ?? this.maleUid,
      femaleUid: femaleUid ?? this.femaleUid,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      dayMet: dayMet ?? this.dayMet,
    );
  }
}
