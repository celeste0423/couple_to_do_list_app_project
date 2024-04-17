import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/src/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/src/models/group_model.dart';
import 'package:couple_to_do_list_app/src/models/user_model.dart';
import 'package:uuid/uuid.dart';

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
    GroupModel groupModel = GroupModel(
      maleUid: male.uid,
      femaleUid: female.uid,
      uid: uid,
      createdAt: DateTime.now(),
      dayMet: null,
    );

    try {
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
      print('그룹 없음(gro repo)');
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

  static upgradePremium() async {
    String groupId = AuthController.to.group.value.uid!;

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .update({'isPremium': true});

    AuthController.to.group.value.copyWith(isPremium: true);
  }

  Future<GroupModel?> updateSoloGroup(
    UserModel noGroupUserData,
    UserModel groupUserData,
  ) async {
    //그룹 데이터 받아옴
    DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupUserData.groupId)
        .get();
    GroupModel groupData =
        GroupModel.fromJson(groupSnapshot.data()! as Map<String, dynamic>);
    //solo를 뺸 uid 를 집어넣어야 하니까
    String newGid = groupData.uid!.substring(4);
    //버꿍리스트 받아옴
    QuerySnapshot bukkungListSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupUserData.groupId)
        .collection('bukkungLists')
        .get();
    //다이어리 받아옴
    QuerySnapshot diarySnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupUserData.groupId)
        .collection('diary')
        .get();
    //이전 solo그룹 삭제
    await deleteGroup(groupUserData.groupId!);

    if (groupData.femaleUid == 'solo') {
      GroupModel updatedGroupData =
          groupData.copyWith(uid: newGid, femaleUid: noGroupUserData.uid);
      try {
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(newGid)
            .set(updatedGroupData.toJson());
      } catch (e) {
        print(e.toString());
      }

      // 각 문서를 새 컬렉션에 추가
      for (QueryDocumentSnapshot docSnapshot in bukkungListSnapshot.docs) {
        Map<String, dynamic> docData =
            docSnapshot.data() as Map<String, dynamic>;
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(newGid)
            .collection('bukkungLists')
            .doc(docSnapshot.id)
            .set(docData);
      }
      for (QueryDocumentSnapshot docSnapshot in diarySnapshot.docs) {
        Map<String, dynamic> docData =
            docSnapshot.data() as Map<String, dynamic>;
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(newGid)
            .collection('diary')
            .doc(docSnapshot.id)
            .set(docData);
      }

      return updatedGroupData;
    } else if (groupData.maleUid == 'solo') {
      GroupModel updatedGroupData =
          groupData.copyWith(uid: newGid, maleUid: noGroupUserData.uid);
      try {
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(newGid)
            .set(updatedGroupData.toJson());
      } catch (e) {
        print(e.toString());
      }

      // 각 문서를 새 컬렉션에 추가
      for (QueryDocumentSnapshot docSnapshot in bukkungListSnapshot.docs) {
        Map<String, dynamic> docData =
            docSnapshot.data() as Map<String, dynamic>;
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(newGid)
            .collection('bukkungLists')
            .doc(docSnapshot.id)
            .set(docData);
      }
      for (QueryDocumentSnapshot docSnapshot in diarySnapshot.docs) {
        Map<String, dynamic> docData =
            docSnapshot.data() as Map<String, dynamic>;
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(newGid)
            .collection('diary')
            .doc(docSnapshot.id)
            .set(docData);
      }

      return updatedGroupData;
    }
    return null;
  }

  Future<GroupModel?> mergeSoloGroup(
    UserModel maleData,
    UserModel femaleData,
  ) async {
    var uuid = Uuid();
    String groupId = uuid.v1();
    //그룹 데이터 받아옴
    GroupModel newGroupData = await groupSignup(groupId, maleData, femaleData);
    //버꿍리스트 받아옴
    QuerySnapshot maleBukkungListSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(maleData.groupId)
        .collection('bukkungLists')
        .get();
    QuerySnapshot femaleBukkungListSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(femaleData.groupId)
        .collection('bukkungLists')
        .get();
    //다이어리 받아옴
    QuerySnapshot maleDiarySnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(maleData.groupId)
        .collection('diary')
        .get();
    QuerySnapshot femaleDiarySnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(femaleData.groupId)
        .collection('diary')
        .get();
    //이전 solo그룹 삭제
    await deleteGroup(maleData.groupId!);
    await deleteGroup(femaleData.groupId!);

    // 각 문서를 새 컬렉션에 추가
    for (QueryDocumentSnapshot docSnapshot in maleBukkungListSnapshot.docs) {
      Map<String, dynamic> docData = docSnapshot.data() as Map<String, dynamic>;
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(newGroupData.uid)
          .collection('bukkungLists')
          .doc(docSnapshot.id)
          .set(docData);
    }
    for (QueryDocumentSnapshot docSnapshot in femaleBukkungListSnapshot.docs) {
      Map<String, dynamic> docData = docSnapshot.data() as Map<String, dynamic>;
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(newGroupData.uid)
          .collection('bukkungLists')
          .doc(docSnapshot.id)
          .set(docData);
    }
    for (QueryDocumentSnapshot docSnapshot in maleDiarySnapshot.docs) {
      Map<String, dynamic> docData = docSnapshot.data() as Map<String, dynamic>;
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(newGroupData.uid)
          .collection('diary')
          .doc(docSnapshot.id)
          .set(docData);
    }
    for (QueryDocumentSnapshot docSnapshot in femaleDiarySnapshot.docs) {
      Map<String, dynamic> docData = docSnapshot.data() as Map<String, dynamic>;
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(newGroupData.uid)
          .collection('diary')
          .doc(docSnapshot.id)
          .set(docData);
    }
    return newGroupData;
  }

  Future<void> deleteGroup(String groupId) async {
    QuerySnapshot bukkungListSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('bukkungLists')
        .get();

    for (QueryDocumentSnapshot docSnapshot in bukkungListSnapshot.docs) {
      await docSnapshot.reference.delete();
    }
    // 컬렉션 자체를 삭제
    DocumentSnapshot parentSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('bukkungLists')
        .doc('bukkungLists') // 컬렉션의 문서 ID
        .get();

    if (parentSnapshot.exists) {
      await parentSnapshot.reference.delete();
    }

    QuerySnapshot diarySnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('bukkungLists')
        .get();

    for (QueryDocumentSnapshot docSnapshot in diarySnapshot.docs) {
      await docSnapshot.reference.delete();
    }
    // 컬렉션 자체를 삭제
    DocumentSnapshot parentDiarySnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('bukkungLists')
        .doc('bukkungLists') // 컬렉션의 문서 ID
        .get();

    if (parentDiarySnapshot.exists) {
      await parentDiarySnapshot.reference.delete();
    }

    FirebaseFirestore.instance.collection('groups').doc(groupId).delete();
  }
}
