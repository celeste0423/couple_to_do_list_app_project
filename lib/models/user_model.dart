import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? nickname;
  final String? loginType;
  final String? email;
  final String? gender;
  final DateTime? birthday;
  final String? groupId;

  UserModel({
    this.uid,
    this.nickname,
    this.loginType,
    this.email,
    this.gender,
    this.birthday,
    this.groupId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] == null ? null : json['uid'] as String,
      nickname: json['nickname'] == null ? null : json['nickname'] as String,
      loginType: json['loginType'] == null ? null : json['loginType'] as String,
      email: json['email'] == null ? null : json['email'] as String,
      gender: json['gender'] == null ? null : json['gender'] as String,
      birthday: json['birthday'] == null
          ? null
          : (json['birthday'] as Timestamp).toDate(),
      groupId: json['groupId'] == null ? null : json['groupId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nickname': nickname,
      'loginType': loginType,
      'email': email,
      'gender': gender,
      'birthday': birthday,
      'groupId': groupId,
    };
  }

  UserModel copyWith({
    String? uid,
    String? nickname,
    String? loginType,
    String? email,
    String? gender,
    DateTime? birthday,
    String? groupId,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      loginType: loginType ?? this.loginType,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      groupId: groupId ?? this.groupId,
    );
  }
}
