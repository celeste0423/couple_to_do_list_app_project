class UserModel {
  final String uid;
  final String email;
  final String gender;
  final DateTime birthday;
  final String groupId;

  UserModel({
    required this.uid,
    required this.email,
    required this.gender,
    required this.birthday,
    required this.groupId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      gender: json['gender'],
      birthday: json['birthday'],
      groupId: json['groubId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': uid,
        'email': email,
        'gender': gender,
        'birthday': birthday,
        'groupId': groupId
      };
}
