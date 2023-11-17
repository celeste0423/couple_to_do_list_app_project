class DeviceTokenModel {
  final String? tid;
  final String? uid;
  final String? deviceToken;
  final DateTime? createdAt;

  DeviceTokenModel({
    this.tid,
    this.uid,
    this.deviceToken,
    this.createdAt,
  });

  factory DeviceTokenModel.fromJson(Map<String, dynamic> json) {
    return DeviceTokenModel(
      tid: json['tid'] == null ? null : json['tid'] as String,
      uid: json['uid'] == null ? null : json['uid'] as String,
      deviceToken:
          json['device_token'] == null ? null : json['device_token'] as String,
      createdAt: json['created_at'] == null
          ? DateTime.now()
          : json['created_at'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tid': tid,
      'uid': uid,
      'device_token': deviceToken,
      'created_at': createdAt,
    };
  }

  DeviceTokenModel copyWith({
    String? tid,
    String? uid,
    String? deviceToken,
    DateTime? createdAt,
  }) {
    return DeviceTokenModel(
      tid: tid ?? this.tid,
      uid: uid ?? this.uid,
      deviceToken: deviceToken ?? this.deviceToken,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
