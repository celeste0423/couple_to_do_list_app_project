import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/model/group_model.dart';
import 'package:couple_to_do_list_app/features/auth/model/user_model.dart';

class GroupRepository {
  static Future<void> groupSignup(
    String uid,
    UserModel male,
    UserModel female,
  ) async {
    GroupModel groupModel = GroupModel(
      maleUid: male.uid,
      femaleUid: female.uid,
      uid: uid,
      createdAt: DateTime.now(),
      dayMet: null,
    );

    try {
      print('그룹모델 생성');
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(uid)
          .set(groupModel.toJson());
    } catch (e) {
      print(e.toString());
    }
  }
}
