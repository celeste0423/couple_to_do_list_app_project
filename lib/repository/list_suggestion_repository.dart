import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';

class ListSuggestionRepository {
  ListSuggestionRepository();

  Future<List<BukkungListModel>> getAllBukkungList() async {
    print('파이어스토어에서 전체 받아옴');
    var snapshot = await FirebaseFirestore.instance
        .collection('bukkungLists')
        .orderBy('likeCount', descending: true)
        .orderBy('createdAt', descending: true)
        .get();
    List<BukkungListModel> bukkungLists = [];
    for (var bukkungList in snapshot.docs) {
      bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
    }
    return bukkungLists;
  }

  Future<List<BukkungListModel>> getTypeBukkungList(String category) async {
    print('파이어스토에서 받아옴(sugg repo) $category');
    var snapshot = await FirebaseFirestore.instance
        .collection('bukkungLists')
        .where('category', isEqualTo: category)
        .orderBy('likeCount', descending: true)
        .orderBy('createdAt', descending: true)
        .get();
    List<BukkungListModel> bukkungLists = [];
    for (var bukkungList in snapshot.docs) {
      bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
    }
    return bukkungLists;
  }
}
