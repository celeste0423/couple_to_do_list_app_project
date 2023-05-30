import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/group_model.dart';

class BukkungListRepository {
  final GroupModel groupModel;

  BukkungListRepository({required this.groupModel});

  Stream<Map<String, dynamic>> getGroupBukkungListByCategory() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupModel.uid)
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

  Stream<List<BukkungListModel>> getGroupBukkungListByDate() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupModel.uid)
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
        .doc(groupModel.uid)
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

  // Future<List<BukkungListModel>> getAllBukkungListByDate() {
  //   print('그룹모델(buk repo) ${groupModel.uid}');
  //   return FirebaseFirestore.instance
  //       .collection('groups')
  //       .doc(groupModel.uid)
  //       .collection('bukkungLists')
  //       .orderBy('date')
  //       .get()
  //       .then((querySnapshot) {
  //     List<BukkungListModel> bukkungLists = [];
  //     for (var bukkungList in querySnapshot.docs) {
  //       bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
  //     }
  //     return bukkungLists;
  //   });
  // }

  static Future<void> setSuggestionBukkungList(
      BukkungListModel bukkungLisData, String listId) async {
    await FirebaseFirestore.instance
        .collection('bukkungLists')
        .doc(listId)
        .set(bukkungLisData.toJson());
  }

  static Future<void> setGroupBukkungList(
      BukkungListModel bukkungLisData, String listId) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(AuthController.to.user.value.groupId)
        .collection('bukkungLists')
        .doc(listId)
        .set(bukkungLisData.toJson());
  }
}
