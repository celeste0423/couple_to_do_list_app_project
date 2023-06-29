import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';

class ListCompletedRepository {
  int completedBukkungListCount = 0;

  Stream<List<BukkungListModel>> getCompletedBukkungListByDate() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(AuthController.to.group.value.uid)
        .collection('completedBukkungLists')
        .orderBy('date', descending: true)
        .snapshots()
        .map((event) {
      List<BukkungListModel> bukkungLists = [];
      for (var bukkungList in event.docs) {
        bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
        completedBukkungListCount++;
      }
      return bukkungLists;
    });
  }

  static Future<void> setCompletedBukkungList(
      BukkungListModel bukkungListData) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(AuthController.to.user.value.groupId)
        .collection('completedBukkungLists')
        .doc(bukkungListData.listId)
        .set(bukkungListData.toJson());
  }
}
