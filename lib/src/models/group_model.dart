import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String? maleUid;
  final String? femaleUid;
  final String? uid;
  final DateTime? createdAt;
  final DateTime? dayMet;
  final bool? isPremium; // Added property

  GroupModel({
    this.maleUid,
    this.femaleUid,
    this.uid,
    this.createdAt,
    this.dayMet,
    this.isPremium,
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
      isPremium: data['isPremium'] as bool?, // Added property
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
      isPremium: json['isPremium'] ==null ? false: json['isPremium'] as bool, // Added property
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maleUid': maleUid,
      'femaleUid': femaleUid,
      'uid': uid,
      'createdAt': createdAt,
      'dayMet': dayMet,
      'isPremium': isPremium ?? false, // Added property
    };
  }

  GroupModel copyWith({
    String? maleUid,
    String? femaleUid,
    String? uid,
    DateTime? createdAt,
    DateTime? dayMet,
    bool? isPremium, // Added property
  }) {
    return GroupModel(
      maleUid: maleUid ?? this.maleUid,
      femaleUid: femaleUid ?? this.femaleUid,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      dayMet: dayMet ?? this.dayMet,
      isPremium: isPremium ?? this.isPremium ?? false, // Added property
    );
  }
}
