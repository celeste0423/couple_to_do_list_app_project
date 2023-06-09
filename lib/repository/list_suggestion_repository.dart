import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/list_suggestion/controller/list_suggestion_page_controller.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ListSuggestionRepository {
  ListSuggestionRepository();

  Stream<List<BukkungListModel>> getSearchedBukkungList(
      List<String> searchWords) {
    return FirebaseFirestore.instance
        .collection('bukkungLists')
        .orderBy('likeCount', descending: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) {
      List<BukkungListModel> bukkungLists = [];
      for (var bukkungList in event.docs) {
        Map<String, dynamic> data = bukkungList.data();
        int wordMatchCount = 0;
        for (String word in searchWords) {
          if (data.toString().contains(word)) {
            wordMatchCount++;
          }
        }
        if (wordMatchCount > 0) {
          bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
        }
      }
      bukkungLists.sort((a, b) {
        int matchCountA = 0;
        int matchCountB = 0;
        for (String word in searchWords) {
          if (a.toString().contains(word)) {
            matchCountA++;
          }
          if (b.toString().contains(word)) {
            matchCountB++;
          }
        }
        return matchCountB.compareTo(matchCountA);
      });
      print(bukkungLists);
      return bukkungLists;
    });
  }

  // static void fetchSuggestionBukkungList(
  //     DocumentSnapshot<Object?>? pageKey, int pageSize) async {
  //   QuerySnapshot<Map<String, dynamic>> loadedBukkungLists;
  //   if (pageKey != null) {
  //     loadedBukkungLists = await FirebaseFirestore.instance
  //         .collection('bukkungLists')
  //         .orderBy('likeCount', descending: true)
  //         .orderBy('createdAt', descending: true)
  //         .startAfterDocument(pageKey)
  //         .limit(pageSize)
  //         .get();
  //   } else {
  //     loadedBukkungLists = await FirebaseFirestore.instance
  //         .collection('bukkungLists')
  //         .orderBy('likeCount', descending: true)
  //         .orderBy('createdAt', descending: true)
  //         .limit(pageSize)
  //         .get();
  //   }
  //   print('로드된 리스트 수 ${loadedBukkungLists.docs.length} (sugg repo)');
  //   final isLastPage = loadedBukkungLists.docs.length < pageSize;
  //   if (isLastPage) {
  //     ListSuggestionPageController.to.pagingController
  //         .appendLastPage(loadedBukkungLists.docs);
  //   } else {
  //     final nextPageKey = loadedBukkungLists.docs.last;
  //     ListSuggestionPageController.to.pagingController
  //         .appendPage(loadedBukkungLists.docs, nextPageKey);
  //   }
  // }

  Future<List<BukkungListModel>> getAllTestFutureBukkungList(
    int pageSize,
    QueryDocumentSnapshot<Map<String, dynamic>>? keyPage,
    List<BukkungListModel>? prevList,
  ) async {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('bukkungLists')
        .orderBy('likeCount', descending: true)
        .orderBy('createdAt', descending: true);
    if (keyPage != null) {
      query = query.startAfterDocument(keyPage);
    }
    query = query.limit(pageSize);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
    List<BukkungListModel> bukkungLists = prevList ?? [];
    for (var bukkungList in querySnapshot.docs) {
      bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
    }
    //키페이지 설정
    QueryDocumentSnapshot<Map<String, dynamic>>? lastDocument =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
    ListSuggestionPageController.to.keyPage = lastDocument;
    //이전 리스트 저장
    ListSuggestionPageController.to.prevList = bukkungLists;
    //마지막 페이지인지 여부 확인
    if (querySnapshot.docs.length < pageSize) {
      ListSuggestionPageController.to.isLastPage = true;
    }
    return bukkungLists;
  }

  // Stream<List<BukkungListModel>> getAllTestStreamBukkungList(
  //   int pageSize,
  //   QueryDocumentSnapshot<Map<String, dynamic>>? keyPage,
  // ) {
  //   if (keyPage != null) {
  //     return FirebaseFirestore.instance
  //         .collection('bukkungLists')
  //         .orderBy('likeCount', descending: true)
  //         .orderBy('createdAt', descending: true)
  //         .startAfterDocument(keyPage)
  //         .limit(pageSize)
  //         .snapshots()
  //         .map((querySnapshot) {
  //       List<BukkungListModel> bukkungLists = [];
  //       for (var bukkungList in querySnapshot.docs) {
  //         bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
  //       }
  //       return bukkungLists;
  //     });
  //   } else {
  //     return FirebaseFirestore.instance
  //         .collection('bukkungLists')
  //         .orderBy('likeCount', descending: true)
  //         .orderBy('createdAt', descending: true)
  //         .limit(pageSize)
  //         .snapshots()
  //         .map((querySnapshot) {
  //       List<BukkungListModel> bukkungLists = [];
  //       for (var bukkungList in querySnapshot.docs) {
  //         bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
  //       }
  //       return bukkungLists;
  //     });
  //   }
  // }

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
