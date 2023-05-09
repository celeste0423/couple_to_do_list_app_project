import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/group_model.dart';

class BukkungListRepository {
  final GroupModel groupModel;

  BukkungListRepository({required this.groupModel});

  Stream<List<BukkungListModel>> getAllBukkungListByDate() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupModel.uid)
        .collection('bukkungLists')
        .orderBy('date')
        .snapshots()
        .map((event) {
      List<BukkungListModel> bukkungLists = [];
      for (var bukkungList in event.docs) {
        bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
      }
      return bukkungLists;
    });
  }
}
