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
      uid: json['uid'] == null ? '' : json['uid'] as String,
      nickname: json['nickname'] == null ? '' : json['nickname'] as String,
      email: json['email'] == null ? '' : json['email'] as String,
      gender: json['gender'] == null ? '' : json['gender'] as String,
      birthday: json['birthday'] == null ? '' : json['birthday'].toDate(),
      groupId: json['groubId'] == null ? '' : json['groupId'] as String,
      dayMet: json['dayMet'] == null ? '' : json['dayMet'].toDate(),
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
}
