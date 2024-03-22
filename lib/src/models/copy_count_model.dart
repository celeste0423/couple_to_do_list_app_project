class CopyCountModel {
  final String? id;
  final String? uid;
  final String? listId;
  final DateTime? createdAt;

  CopyCountModel({
    this.id,
    this.uid,
    this.listId,
    this.createdAt,
  });

  factory CopyCountModel.fromJson(Map<String, dynamic> json) {
    return CopyCountModel(
      id: json['id'] == null ? null : json['id'] as String,
      uid: json['uid'] == null ? null : json['uid'] as String,
      listId: json['list_id'] == null ? null : json['list_id'] as String,
      createdAt: json['created_at'] == null
          ? DateTime.now()
          : json['created_at'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'list_id': listId,
      'created_at': createdAt,
    };
  }

  CopyCountModel copyWith({
    String? id,
    String? uid,
    String? listId,
    DateTime? createdAt,
  }) {
    return CopyCountModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      listId: listId ?? this.listId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
