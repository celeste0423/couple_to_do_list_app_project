import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BukkungListRepository {
  BukkungListRepository();

  Stream<Map<String, dynamic>> getGroupBukkungListByCategory() {
    print('(buk repo) 리스트 겟 유저그룹id ${AuthController.to.user.value.groupId}');
    print('(buk repo) 리스트 겟 그룹id ${AuthController.to.group.value.uid}');
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(AuthController.to.group.value.uid)
        .collection('bukkungLists')
        .orderBy('category', descending: false)
        .snapshots()
        .map((event) {
      List<BukkungListModel> bukkungLists = [];
      List<int> categoryCount = [0, 0, 0, 0, 0, 0];
      for (var bukkungList in event.docs) {
        final bukkungListModel = BukkungListModel.fromJson(bukkungList.data());
        bukkungLists.add(bukkungListModel);

        //카테고리별 개수 추가
        final categoryIndex =
            int.parse(bukkungListModel.category!.substring(0, 1));
        categoryCount[categoryIndex - 1]++;
      }
      print('버꿍리스트(buk repo)${bukkungLists.length}');
      return {
        'bukkungLists': bukkungLists,
        'categoryCount': categoryCount,
      };
    });
  }

  Stream<List<BukkungListModel>> getGroupBukkungListByCreatedAt() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(AuthController.to.group.value.uid)
        .collection('bukkungLists')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) {
      List<BukkungListModel> bukkungLists = [];
      for (var bukkungList in event.docs) {
        bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
      }
      return bukkungLists;
    });
  }

  Stream<List<BukkungListModel>> getGroupBukkungListByDate() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(AuthController.to.group.value.uid)
        .collection('bukkungLists')
        .orderBy('date', descending: true)
        .snapshots()
        .map((event) {
      List<BukkungListModel> bukkungLists = [];
      for (var bukkungList in event.docs) {
        bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
      }
      return bukkungLists;
    });
  }

  Stream<List<BukkungListModel>> getGroupBukkungListByReverseDate() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(AuthController.to.group.value.uid)
        .collection('bukkungLists')
        .orderBy('date', descending: false)
        .snapshots()
        .map((event) {
      List<BukkungListModel> bukkungLists = [];
      for (var bukkungList in event.docs) {
        bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
      }
      return bukkungLists;
    });
  }

  Future<BukkungListModel?> getBukkungList(String bukkungListId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(AuthController.to.group.value.uid)
        .collection('bukkungLists')
        .doc(bukkungListId)
        .get();
      print('list exist? ${snapshot.exists}');
    if (snapshot.exists) {
      return BukkungListModel.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      openAlertDialog(title: '해당 버꿍리스트가 존재하지 않습니다.');
      return null;
    }
  }

  static Future<void> setSuggestionBukkungList(
      BukkungListModel bukkungLisData) async {
    await FirebaseFirestore.instance
        .collection('bukkungLists')
        .doc(bukkungLisData.listId)
        .set(bukkungLisData.toJson());
  }

  static Future<void> setGroupBukkungList(
    BukkungListModel bukkungListData,
    String? groupId,
  ) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId ?? AuthController.to.user.value.groupId)
        .collection('bukkungLists')
        .doc(bukkungListData.listId)
        .set(bukkungListData.toJson());
  }

  static Future<void> updateGroupBukkungList(
      BukkungListModel bukkungListModel) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(AuthController.to.user.value.groupId)
        .collection('bukkungLists')
        .doc(bukkungListModel.listId) // 업데이트할 문서의 ID
        .update(bukkungListModel.toJson()); // 업데이트할 데이터
  }

  Future<void> deleteList(BukkungListModel bukkungListModel) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc('${AuthController.to.user.value.groupId}')
        .collection('bukkungLists')
        .doc('${bukkungListModel.listId}')
        .delete();
  }

  Future<void> deleteListImage(String imagePath) async {
    try {
      Reference imageRef = FirebaseStorage.instance
          .ref()
          .child('group_bukkunglist')
          .child('${AuthController.to.user.value.groupId}/$imagePath');

      await imageRef.delete();
    } catch (e) {
      openAlertDialog(title: '이미지 삭제 오류 $e');
    }
  }

  static Future<void> deleteImage(String imgUrl) async {
    Reference storageRef = FirebaseStorage.instance.refFromURL(imgUrl);
    try {
      // 이미지 삭제
      await storageRef.delete();
      print('이미지 삭제 완료');
    } catch (e) {
      openAlertDialog(title: '이미지 삭제 오류 $e');
    }
  }

  // Stream<List<BukkungListModel>> getBukkungListByCreatedAt() {
  //   return FirebaseFirestore.instance
  //       .collectionGroup('bukkungLists')
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map((event) {
  //     List<BukkungListModel> bukkungLists = [];
  //     for (var bukkungList in event.docs) {
  //       bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
  //     }
  //     return bukkungLists;
  //   });
  // }
}
