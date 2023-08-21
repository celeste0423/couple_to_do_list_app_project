import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/models/group_model.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';

class GroupRepository {
  static Stream<GroupModel> streamGroupDataByUid(String groupId) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .snapshots()
        .map((snapshot) => GroupModel.fromJson(snapshot.data()!));
  }

  static Future<GroupModel> groupSignup(
    String uid,
    UserModel male,
    UserModel female,
  ) async {
    print('그룹 signUp');
    print('여자 uid${female.uid}');
    print('남자 uid${male.uid}');
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
    return groupModel;
  }

  static Future<GroupModel?> groupLogin(String? uid) async {
    // print('그룹 로그인 시작(gro repo)${uid}');
    var snapshot =
        await FirebaseFirestore.instance.collection('groups').doc(uid).get();
    if (!snapshot.exists) {
      print('에러 그룹 없음(gro repo)');
      return null;
    }
    return GroupModel.fromJson(snapshot.data()!);
  }

  static updateGroupDayMet(DateTime selectedDate) async {
    String groupId = AuthController.to.group.value.uid!;
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .update({'dayMet': selectedDate});
  }
}
