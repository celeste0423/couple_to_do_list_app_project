import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/group_model.dart';

class BukkungListRepository {
  final GroupModel groupModel;

  BukkungListRepository({required this.groupModel});

  Stream<List<BukkungListModel>> getAllBukkungListByDate() {
    print('스트림 시작');
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
      print('버꿍리스트(buk repo)${bukkungLists.length}');
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
}
