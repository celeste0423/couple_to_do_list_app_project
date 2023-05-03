import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? nickname;
  final String? email;
  final String? gender;
  final DateTime? birthday;
  final String? groupId;
  final DateTime? dayMet;

  UserModel({
    this.uid,
    this.nickname,
    this.email,
    this.gender,
    this.birthday,
    this.groupId,
    this.dayMet,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] == null ? null : json['uid'] as String,
      nickname: json['nickname'] == null ? null : json['nickname'] as String,
      email: json['email'] == null ? null : json['email'] as String,
      gender: json['gender'] == null ? null : json['gender'] as String,
      birthday: json['birthday'] == null
          ? null
          : (json['birthday'] as Timestamp).toDate(),
      groupId: json['groubId'] == null ? null : json['groupId'] as String,
      dayMet: json['dayMet'] == null
          ? null
          : (json['dayMet'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nickname': nickname,
      'email': email,
      'gender': gender,
      'birthday': birthday,
      'groupId': groupId,
      'dayMet': dayMet,
    };
  }

  UserModel copyWith({
    String? uid,
    String? nickname,
    String? email,
    String? gender,
    DateTime? birthday,
    String? groupId,
    DateTime? dayMet,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      groupId: groupId ?? this.groupId,
      dayMet: dayMet ?? this.dayMet,
    );
  }
}
