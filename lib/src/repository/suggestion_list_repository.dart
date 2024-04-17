import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/src/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/src/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/src/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/src/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SuggestionListRepository {
  SuggestionListRepository();

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
        BukkungListModel bukkungListModel =
            BukkungListModel.fromJson(bukkungList.data());
        int wordMatchCount = 0;
        for (String word in searchWords) {
          if (bukkungListModel.title!.contains(word) ||
              bukkungListModel.location!.contains(word)) {
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
      return bukkungLists;
    });
  }

  Future<List<BukkungListModel>> getSearchedBukkungListAsFuture(
      List<String> searchWords) async {
    List<BukkungListModel> bukkungLists = [];
    await FirebaseFirestore.instance
        .collection('bukkungLists')
        .orderBy('likeCount', descending: true)
        .orderBy('createdAt', descending: true)
        .get()
        .then((QuerySnapshot event) {
      for (var bukkungList in event.docs) {
        Map<String, dynamic> bukkungData =
            bukkungList.data() as Map<String, dynamic>;
        BukkungListModel bukkungListModel =
            BukkungListModel.fromJson(bukkungData);

        int wordMatchCount = 0;
        for (String word in searchWords) {
          if (bukkungListModel.title!.contains(word) ||
              bukkungListModel.location!.contains(word)) {
            wordMatchCount++;
          }
        }
        if (wordMatchCount > 0) {
          if (bukkungLists.length < 10) {
            bukkungLists.add(bukkungListModel);
          } else {
            // 최대 10개를 넘으면 루프 종료
            break;
          }
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
    });
    return bukkungLists;
  }

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

  Stream<List<BukkungListModel>> getCategoryBukkungList(String category) {
    // print('파이어스토에서 받아옴(sugg repo) $category');
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
    // print('파이어스토어에서 전체 받아옴');
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

  Future<List<BukkungListModel>> getFutureMyBukkungList() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('bukkungLists')
        .where('userId', isEqualTo: AuthController.to.user.value.uid)
        .get();
    print('리스트 가져오는 중');
    List<BukkungListModel> bukkungLists = snapshot.docs.map((doc) {
      return BukkungListModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    return bukkungLists;
  }

  //Todo: 마이페이지 좋아요, 조회수 스트림으로 처리할 것
  Stream<List<int>> getMyLikeViewCount(UserModel userModel) {
    // print('파이어스토어에서 전체 받아옴');
    //0 번째 리스트가 likeCount
    //1 번째 리스트가 ViewCount
    return FirebaseFirestore.instance
        .collection('bukkungLists')
        .where('userId', isEqualTo: userModel.uid)
        .snapshots()
        .map((event) {
      List<int> likeViewCount = List<int>.filled(2, 0);
      for (var bukkungList in event.docs) {
        // likeViewCount[0] +=
        //     BukkungListModel.fromJson(bukkungList.data()).likeCount!;
        likeViewCount[1] +=
            BukkungListModel.fromJson(bukkungList.data()).viewCount!;
      }
      return likeViewCount;
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

  Future<void> addCopyCount(String listId) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('bukkungLists').doc(listId);
    // 현재 copyCount 필드의 값을 가져와서 1 증가시킴
    final DocumentSnapshot documentSnapshot = await documentReference.get();
    final data = documentSnapshot.data() as Map<String, dynamic>;
    int? currentCopyCount = BukkungListModel.fromJson(data).copyCount;
    currentCopyCount ??= 0;
    final newCopyCount = currentCopyCount + 1;
    // copyCount 필드를 새로운 값으로 업데이트
    await documentReference.update({'copyCount': newCopyCount});
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

  Future<QuerySnapshot<Map<String, dynamic>>> getSuggestionListByDate(
    DocumentSnapshot<Object?>? pageKey,
    int pageSize,
  ) async {
    if (pageKey == null) {
      return FirebaseFirestore.instance
          .collection('bukkungLists')
          .orderBy('createdAt', descending: true)
          .limit(pageSize)
          .get();
    } else {
      return FirebaseFirestore.instance
          .collection('bukkungLists')
          .orderBy('createdAt', descending: true)
          .startAfterDocument(pageKey)
          .limit(pageSize)
          .get();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSuggestionListByCopy(
    DocumentSnapshot<Object?>? pageKey,
    int pageSize,
  ) async {
    if (pageKey == null) {
      return FirebaseFirestore.instance
          .collection('bukkungLists')
          .orderBy('copyCount', descending: true)
          .orderBy('viewCount', descending: true)
          .limit(pageSize)
          .get();
    } else {
      return FirebaseFirestore.instance
          .collection('bukkungLists')
          .orderBy('copyCount', descending: true)
          .orderBy('viewCount', descending: true)
          .startAfterDocument(pageKey)
          .limit(pageSize)
          .get();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSuggestionListMy(
    DocumentSnapshot<Object?>? pageKey,
    int pageSize,
  ) async {
    if (pageKey == null) {
      return FirebaseFirestore.instance
          .collection('bukkungLists')
          .where('userId', isEqualTo: AuthController.to.user.value.uid)
          .orderBy('copyCount', descending: true)
          .orderBy('viewCount', descending: true)
          .limit(pageSize)
          .get();
    } else {
      return FirebaseFirestore.instance
          .collection('bukkungLists')
          .where('userId', isEqualTo: AuthController.to.user.value.uid)
          .orderBy('copyCount', descending: true)
          .orderBy('viewCount', descending: true)
          .startAfterDocument(pageKey)
          .limit(pageSize)
          .get();
    }
  }

  Future<BukkungListModel?> getSuggestionListById(String bukkungListId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('bukkungLists')
        .doc(bukkungListId)
        .get();
    if (snapshot.exists) {
      return BukkungListModel.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      openAlertDialog(title: '해당 버꿍리스트가 존재하지 않습니다.');
      return null;
    }
  }
}
