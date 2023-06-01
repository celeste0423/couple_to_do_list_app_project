import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ListSuggestionRepository {
  ListSuggestionRepository();

  Stream<List<BukkungListModel>> getAllBukkungList() {
    return FirebaseFirestore.instance
        .collection('bukkungLists')
        .orderBy('likeCount', descending: true)
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

  Stream<List<BukkungListModel>> getTypeBukkungList(String category) {
    print('파이어스토에서 받아옴(sugg repo) $category');
    return FirebaseFirestore.instance
        .collection('bukkungLists')
        .where('category', isEqualTo: category)
        .orderBy('likeCount', descending: true)
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
  // Future<List<BukkungListModel>> getAllBukkungList() async {
  //   print('파이어스토어에서 전체 받아옴');
  //   var snapshot = await FirebaseFirestore.instance
  //       .collection('bukkungLists')
  //       .orderBy('likeCount', descending: true)
  //       .orderBy('createdAt', descending: true)
  //       .get();
  //   List<BukkungListModel> bukkungLists = [];
  //   for (var bukkungList in snapshot.docs) {
  //     bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
  //   }
  //   return bukkungLists;
  // }
  //
  // Future<List<BukkungListModel>> getTypeBukkungList(String category) async {
  //   print('파이어스토에서 받아옴(sugg repo) $category');
  //   var snapshot = await FirebaseFirestore.instance
  //       .collection('bukkungLists')
  //       .where('category', isEqualTo: category)
  //       .orderBy('likeCount', descending: true)
  //       .orderBy('createdAt', descending: true)
  //       .get();
  //   List<BukkungListModel> bukkungLists = [];
  //   for (var bukkungList in snapshot.docs) {
  //     bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
  //   }
  //   return bukkungLists;
  // }

  Stream<List<BukkungListModel>> getMyBukkungList() {
    print('파이어스토어에서 전체 받아옴');
    return FirebaseFirestore.instance
        .collection('bukkungLists')
        .where('userId', isEqualTo: AuthController.to.user.value.uid)
        .orderBy('likeCount', descending: true)
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

  void updateLike(String listId, int likeCount, List<String> likedUsers) {
    FirebaseFirestore.instance.collection('bukkungLists').doc(listId).update({
      'likeCount': likeCount,
      'likedUsers': likedUsers,
    });
  }

  void updateViewCount(String listId, int viewCount) {
    FirebaseFirestore.instance.collection('bukkungLists').doc(listId).update({
      'viewCount': viewCount,
    });
  }

  void deleteList(String listId) {
    FirebaseFirestore.instance.collection('bukkungLists').doc(listId).delete();
  }

  Future<void> deleteListImage(String imagePath) async {
    try {
      Reference imageRef = FirebaseStorage.instance
          .ref()
          .child('suggestion_bukkunglist')
          .child(imagePath);

      await imageRef.delete();
    } catch (e) {
      openAlertDialog(title: '이미지 삭제 오류 $e');
    }
  }
}
